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
    func toDoItem(item: TaskItem, groupID: Int, bind: Binding<String>, focus: FocusState<Bool>.Binding) -> some View{
        VStack {
            HStack{
                self.toDoItemCompletionButton(item: item, groupID: groupID)
               
                self.toDoItemName(item: item, groupID: groupID)
                                
                self.toDoItemStatus(item: item, groupID: groupID)
                
                self.toDoItemUrgency(item: item, groupID: groupID)
                
                Spacer()
                HStack {
                    self.toDoItemTime(item: item, groupID: groupID)
                    // here is the button that allow you to see the details
                    self.toDoItemDetailsButton(item: item, groupID: groupID)
                }
            }
            .padding([.leading, .trailing])
            self.toDoItemDetails(item: item, groupID: groupID, bind: bind, focus: focus)
        }
        .background(
            self.toDoBackground(item: item, groupID: groupID)
                .frame(height:  item.detailsActive ? item.frameSize + 27 : 45)
        )
        .onAppear {
            self.detailsOnAppearConfigureFrameSize(givenItem: item)
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
                self.deleteBlankItems()
                self.activate(givenItem: item, action: "item")
                if item.isActive == 2 {
                    self.deactivate(givenItem: item, action: "item")
                }
            }
        }
    }
    
    func toDoItemName(item: TaskItem, groupID: Int) -> some View {
        //// here is the title of the task (its on the far right of a task tile)
        HStack {
            Text("\(item.name)")
                .padding(.leading)
                .fixedSize(horizontal: item.detailsActive, vertical: item.detailsActive)
                .foregroundColor(item.isActive > 0 ? MainData().colors.activeWords : MainData().colors.inactiveWords)
                .lineLimit(1)
            Spacer()
        }
        .frame(width: 150)
    }
    
    func toDoItemTime(item: TaskItem, groupID: Int) -> some View {
        ZStack {
            ////here is the time of the task
            if item.isActive == 0 && item.detailsActive != true && item.startTime.time != 0 && item.deletingPosition == 0{
                ZStack {
                    Text("\(item.returnProperDisplayOfStartTime())")
                        .fixedSize()
                        .font(.subheadline)
                        .foregroundColor(MainData().colors.inactiveWords)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(MainData().colors.mainBackground)
                                .frame(width: 65, height: 22)
                        )
                }
                .frame(width: 20)
                .offset(x: -30)
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
    
    func toDoItemDetailsButton(item: TaskItem, groupID: Int) -> some View {
        ZStack {
            if item.deletingPosition == 0 {
                Button {
                    withAnimation(Animation.spring()) {
                        self.activate(givenItem: item,action: "details")
                    }
                    print("item ID : \(item.id) name : \(item.name) was selected")
                } label: {
                    Image(systemName: "chevron.down")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(MainData().colors.inactiveWords)
                        .frame(height: 8)
                        .overlay {
                            Rectangle()
                                .frame(width: 25, height: 25)
                                .foregroundColor(Color.clear)
                        }
                }
            }
        }
    }
    
    ////  Active Details functions for the views
    func toDoItemDetails(item: TaskItem, groupID: Int, bind: Binding<String>, focus: FocusState<Bool>.Binding) -> some View {
        ZStack {
            /// here needs to be the details being displayed on tap
            if item.detailsActive {
                VStack(alignment: .leading) {
                    //// here is the time
                    detailsTime(item: item, groupID: groupID)
                    //// here is the location
                    detailsLocation(item: item, groupID: groupID)
                    //// here is the description
                    detailsDescription(item: item, groupID: groupID)
                    ForEach(item.subtasks) { task in
                        self.detailsSubTasks(item: item, groupID: groupID, subTask: task, bind: bind, focus: focus)
                    }
                    
                    //// here is the sub task button
                    detailsSubTaskButton(item: item, groupID: groupID, bind: bind)
                }
                .padding(.top, 10)
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
            if item.startTime.time == 0 {
                Text("Not Scheduled")
                    .foregroundColor(MainData().colors.activeWords)
            } else {
                Text("\(item.dateTime.day)/\(item.dateTime.month)")
                    .font(.headline)
                    .foregroundColor(MainData().colors.activeWords)
                Text("\(item.returnProperDisplayOfStartTime()) - \(item.returnProperDisplayOfEndTime())")
                    .font(.headline)
                    .foregroundColor(MainData().colors.activeWords)
            }
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
        }

    }
    
    func detailsSubTasks(item: TaskItem, groupID: Int, subTask: TaskItem.SubTask, bind: Binding<String>, focus: FocusState<Bool>.Binding) -> some View {
        HStack {
            Button {
                self.deleteBlankItems()
                self.detailsActivateSubtask(item: item, subTask: subTask)
            } label: {
                if subTask.isActive {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(item.isActive == 2 ? MainData().colors.completedColor : MainData().colors.inProgressColor)
                        .frame(width: 35, height: 30)
                } else {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 1)
                        .frame(width: 35, height: 30)
                }
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 1)
                HStack {
                    if subTask.isNamed {
                        Text("\(subTask.name)")
                    } else {
                        TextField("", text: bind)
                            .focused(focus)
                    }
                    Spacer()
                    Button {
                        self.detailsDeleteSubtask(item: item, subTask: subTask)
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 10)
                    }
                }
                .padding([.leading, .trailing])
            }
            .frame(width: 200,height: 30)
        }
        .foregroundColor(MainData().colors.activeWords)
        .offset(x: -5)
    }
    
    func detailsSubTaskButton(item: TaskItem, groupID: Int,bind: Binding<String>) -> some View {
        HStack {
            Button {
                withAnimation(Animation.spring()) {
                    if bind.wrappedValue == "" {
                        self.detailsAddSubTask(item: item, bind: bind)
                    } else {
                        self.setSubTaskName(item: item, bind: bind.wrappedValue)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            self.detailsAddSubTask(item: item, bind: bind)
                        }
                    }
                }
            } label : {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 1)
                    .offset(x: 45)
                    .frame(width: 200,height: 30)
                    .foregroundColor(MainData().colors.activeWords)
                    .overlay(
                        Image(systemName: "plus")
                            .resizable()
                            .scaledToFit()
                            .offset(x: 45)
                            .frame(width: 15)
                            .foregroundColor(MainData().colors.activeWords)
                    )
            }
        }
        .offset(x: -5)
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
    
    func resetAndDeleteButtons(item: TaskItem, groupID: Int) -> some View {
        HStack {
            Spacer()
            
            Button {
                withAnimation(Animation.easeIn) {
                    self.deactivate(givenItem: item, action: "item")
                    self.deactivate(givenItem: item, action: "position")
                }
            } label: {
                Text("RESET")
                    .font(.subheadline)
                    .padding(.trailing, 5)
            }
            Button {
                withAnimation(Animation.easeIn){
                    self.holdItem(givenItem: item)
                    self.deactivate(givenItem: item, action: "position")
                }
            } label: {
                Text("HOLD")
                    .font(.subheadline)
                    .padding(.trailing, 5)
            }
            Button {
                withAnimation(Animation.easeIn) {
                    self.groupOfTasks[groupID].taskItems.removeAll(where: {$0.id == item.id})
                }
            } label: {
                Text("DELETE")
                    .font(.subheadline)
                    .padding(.trailing)
            }
        }

    }
    
    
}
