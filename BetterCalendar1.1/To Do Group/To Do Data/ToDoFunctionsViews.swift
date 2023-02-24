//
//  ToDoFunctionsViews.swift
//  BetterCalendar1.1
//
//  Created by Delvin Cockroft on 2/23/23.
//

import Foundation
import SwiftUI

// This function returns a VIEW that defines how all 'To Do Items' should look
extension ToDoData {    
    func toDoItem(item: TaskItem, groupID: Int) -> some View{
        VStack {
            HStack{
                self.toDoItemCompletionButton(item: item, groupID: groupID)
               
                self.toDoItemName(item: item, groupID: groupID)
                
                self.toDoItemTime(item: item, groupID: groupID)
                
                self.toDoItemStatus(item: item, groupID: groupID)
                
                self.toDoItemUrgency(item: item, groupID: groupID)
                
                Spacer()
                
                self.toDoItemDetailsButton(item: item, groupID: groupID)
            }
            
            HStack {
                Spacer()
                self.toDoItemDetails(item: item, groupID: groupID)
            }
            
            if item.detailsActive {
                Spacer()
            }
        }
        .frame(width: width / 1.1)
        .background(
            self.toDoBackground(item: item, groupID: groupID)
                .frame(width: width / 1.05, height:  item.detailsActive ? item.frameSize + 27 : 45)
        )
        .onAppear {
            for (index, task) in self.groupOfTasks[groupID].taskItems.enumerated() {
                if item.id == task.id {
                    self.groupOfTasks[groupID].taskItems[index].frameSize = CGFloat(200 + item.subtasks.count * 41)
                }
            }
        }
        .onChange(of: item.subtasks.count) { num in
            withAnimation(Animation.spring()) {
                for (index, task) in self.groupOfTasks[groupID].taskItems.enumerated() {
                    if item.id == task.id {
                        self.groupOfTasks[groupID].taskItems[index].frameSize = CGFloat(200 + item.subtasks.count * 41)
                    }
                }
            }
        }
    }
    
    func toDoItemCompletionButton(item: TaskItem, groupID: Int) -> some View {
        //// here is the button for changing the state
        ZStack {
            if item.isActive == 0{
                RoundedRectangle(cornerRadius: 7)
                    .stroke(lineWidth: 2)
                    .foregroundColor(MainData().colors.inactiveWords)
                    .frame(width: 30, height: 30)
            } else if item.isActive >= 1{
                let progressNames = ["dot.circle","checkmark","minus.circle"]
                let progressColors = [MainData().colors.inProgressColor,MainData().colors.completedColor,MainData().colors.onHoldColor]
                RoundedRectangle(cornerRadius: 7)
                    .fill(progressColors[item.isActive - 1])
                    .frame(width: 30, height: 30)
                    .overlay(
                        Image(systemName: "\(progressNames[item.isActive - 1])")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color.white)
                            .frame(width: 15)
                    )
            }
        }
        .onTapGesture {
            withAnimation(Animation.easeIn){
                self.activate(givenItem: item, groupID: groupID, action: "item")
                if item.isActive == 2 {
                    self.deactivate(givenItem: item, groupID: groupID, action: "item")
                }
            }
        }
    }
    
    func toDoItemName(item: TaskItem, groupID: Int) -> some View {
        //// here is the title of the task (its on the far right of a task tile)
        HStack {
            Text("\(item.name)")
                .padding(.leading)
                .foregroundColor(item.isActive > 0 ? MainData().colors.activeWords : MainData().colors.inactiveWords)
                .lineLimit(1)
            Spacer()
        }
        .frame(width: 150)
    }
    
    func toDoItemTime(item: TaskItem, groupID: Int) -> some View {
        ZStack {
            ////here is the time of the task
            if item.isActive == 0 && item.detailsActive != true && item.startTime.hour != 0 && item.deletingPosition == 0{
                ZStack {
                    RoundedRectangle(cornerRadius: 7)
                        .fill(MainData().colors.mainBackground)
                        .frame(width: width / 5.5,height: height / 24)
                    Text("\(item.startTime.hour):\(item.startTime.minute)\(item.startTime.timeOfDay)")
                        .fixedSize()
                        .font(.subheadline)
                        .foregroundColor(MainData().colors.inactiveWords)
                }
                .frame(width: 20)
                .offset(x: 20)
            }
        }
    }
    
    func toDoItemStatus(item: TaskItem, groupID: Int) -> some View {
        ZStack {
            //// here is the status of the task (its on the left of the name)
            let activeDescription = ["", "In Progress", "Complete", "On Hold"]
            Text("\(activeDescription[item.isActive])")
                .fixedSize()
                .font(.subheadline)
                .padding(.leading)
                .foregroundColor(item.isActive > 0 ? MainData().colors.activeWords : MainData().colors.inactiveWords)
                .frame(width: 100)
        }
    }
    
    func toDoItemUrgency(item: TaskItem, groupID: Int) -> some View {
        ZStack {
            if item.urgency == "High" && item.isActive != 0{
                Image(systemName: "exclamationmark")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(MainData().colors.activeWords)
                    .frame(height: 20)
            }
        }
    }
    
    ////  Detials functions for the views
    func toDoItemDetailsButton(item: TaskItem, groupID: Int) -> some View {
        ZStack {
            if item.deletingPosition == 0 {
                Image(systemName: "chevron.down")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(MainData().colors.inactiveWords)
                    .frame(height: 8)
                    .onTapGesture {
                        withAnimation(Animation.spring()) {
                            self.activate(givenItem: item, groupID: groupID, action: "details")
                        }
                        print("item ID : \(item.id) name : \(item.name) was selected")
                    }
                    
            }
        }
    }
    
    func toDoItemDetails(item: TaskItem, groupID: Int) -> some View {
        ZStack {
            /// here needs to be the details being displayed on tap
            if item.detailsActive {
                VStack {
                    //// here is the time
                    detailsTime(item: item, groupID: groupID)
                    //// here is the location
                    detailsLocation(item: item, groupID: groupID)
                    //// here is the description
                    detailsDescription(item: item, groupID: groupID)
                    
                    ForEach(item.subtasks) { task in
                        self.detailsSubTasks(item: item, groupID: groupID, subTask: task)
                    }
                    
                    //// here is the sub task button
                    detailsSubTaskButton(item: item, groupID: groupID)
                }
                .padding(.top, 10)
                .frame(width: width / 1.15)
                Spacer()
            }
        }
    }
    
    func detailsTime(item: TaskItem, groupID: Int) -> some View {
        HStack {
            Image(systemName: "clock")
                .resizable()
                .scaledToFit()
                .frame(width: 15)
                .padding(.trailing, 10)
                .foregroundColor(Color.white)
            if item.startTime.hour == 0 {
                Text("Not Scheduled")
                    .foregroundColor(MainData().colors.activeWords)
            } else {
                Text("\(item.dateTime.day)/\(item.dateTime.month)")
                    .font(.headline)
                    .foregroundColor(MainData().colors.activeWords)
                Text("\(item.startTime.hour):\(item.startTime.minute)\(item.startTime.timeOfDay) - \(item.endTime.hour):\(item.endTime.minute)\(item.endTime.timeOfDay)")
                    .font(.headline)
                    .foregroundColor(MainData().colors.activeWords)
            }
            
            Spacer()
        }
    }
    
    func detailsLocation(item: TaskItem, groupID: Int) -> some View {
        HStack {
            Image(systemName: "mappin.and.ellipse")
                .resizable()
                .scaledToFit()
                .frame(width: 15)
                .padding(.trailing, 10)
                .foregroundColor(Color.white)
            if item.location.isEmpty {
                Text("No Location")
                    .foregroundColor(MainData().colors.activeWords)
            } else {
                Text("\(item.location)")
                    .font(.headline)
                    .foregroundColor(MainData().colors.activeWords)
            }
            Spacer()
        }

    }
    
    func detailsDescription(item: TaskItem, groupID: Int) -> some View {
        HStack {
            Image(systemName: "doc")
                .resizable()
                .scaledToFit()
                .frame(width: 15)
                .padding(.trailing, 10)
                .foregroundColor(Color.white)
            if item.description.isEmpty {
                Text("No Description")
                    .foregroundColor(MainData().colors.activeWords)
            } else {
                Text("\(item.description)")
                    .font(.headline)
                    .foregroundColor(MainData().colors.activeWords)
            }
            Spacer()
        }

    }
    
    func detailsSubTasks(item: TaskItem, groupID: Int, subTask: TaskItem.SubTask) -> some View {
        HStack {
            RoundedRectangle(cornerRadius: 8)
                .stroke(lineWidth: 1)
                .frame(width: 35, height: 30)
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 1)
                HStack {
                    if subTask.isNamed {
                        Text("\(subTask.name)")
                    }
                    Spacer()
                    Button {
                        for (index, task) in self.groupOfTasks[groupID].taskItems.enumerated() {
                            if item.id == task.id {
                                self.groupOfTasks[groupID].taskItems[index].subtasks.removeAll(where: {$0.id == subTask.id})
                            }
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 10)
                    }
                }
                .padding([.leading, .trailing])
               
            }
            .frame(width: 250,height: 30)

            Spacer()
        }
        .foregroundColor(MainData().colors.activeWords)
        .offset(x: -5)
    }
    
    
    func detailsSubTaskButton(item: TaskItem, groupID: Int) -> some View {
        Button {
            for (index, task) in self.groupOfTasks[groupID].taskItems.enumerated() {
                if item.id == task.id {
                    self.groupOfTasks[groupID].taskItems[index].addSubTask()
                }
            }
        } label : {
            HStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 1)
                    .frame(width: 35, height: 30)
                    .foregroundColor(MainData().colors.activeWords)
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 1)
                    .frame(width: 250,height: 30)
                    .foregroundColor(MainData().colors.activeWords)
                    .overlay(
                        Image(systemName: "plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15)
                            .foregroundColor(MainData().colors.activeWords)
                    )
                Spacer()
            }
            .offset(x: -5)
        }
    }
    
    //// Background function
    func toDoBackground(item: TaskItem, groupID: Int) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(MainData().colors.mainBackground)
            if item.isActive < 1 {
                RoundedRectangle(cornerRadius: 10)
                    .fill(MainData().colors.secondaryBackground)
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 2)
                    .fill(MainData().colors.secondaryBackground)
            }
        }
    }
}
