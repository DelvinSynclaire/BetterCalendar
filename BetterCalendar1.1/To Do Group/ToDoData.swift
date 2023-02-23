//
//  ToDoData.swift
//  BetterCalendar1.1
//
//  Created by Delvin Cockroft on 2/17/23.
//

import Foundation
import SwiftUI

class ToDoData: ObservableObject {
    @Published var groupOfTasks : [GroupOfTaskItem] = [
        GroupOfTaskItem(
            id: 0, name: "Default", taskItems: [
                TaskItem(
                    name: "Brush Teeth",
                    startTime: TaskItem.StartTime(hour: 6, minute: 30, timeOfDay: "AM"), endTime: TaskItem.EndTime(hour: 10, minute: 30, timeOfDay: "AM"), dateTime: TaskItem.DateTime(day: 1, month: 2, year: 2023) ,
                    urgency: "Low", location: "", description: "Something I have to do in the morning", lifespan: 0, isActive: 0, deletingPosition: 0, detailsActive: false),
                TaskItem(
                    name: "Cook Brunch",
                    startTime: TaskItem.StartTime(hour: 9, minute: 30, timeOfDay: "AM"), endTime: TaskItem.EndTime(hour: 8, minute: 30, timeOfDay: "PM"), dateTime: TaskItem.DateTime(day: 1, month: 2, year: 2023),
                    urgency: "High", location: "723 The Falls Parkway", description: "I am having ube, eggs and rice", lifespan: 0, isActive: 0, deletingPosition: 0, detailsActive: false),
                TaskItem(
                    name: "Cook Dinner",
                    startTime: TaskItem.StartTime(hour: 3, minute: 30, timeOfDay: "PM"), endTime: TaskItem.EndTime(hour: 8, minute: 30, timeOfDay: "PM"), dateTime: TaskItem.DateTime(day: 1, month: 2, year: 2023),
                    urgency: "High", location: "723 The Falls Parkway", description: "I am having ube, eggs and rice", lifespan: 0, isActive: 0, deletingPosition: 0, detailsActive: false),
                TaskItem(
                    name: "Cook Lunch",
                    startTime: TaskItem.StartTime(hour: 1, minute: 30, timeOfDay: "PM"), endTime: TaskItem.EndTime(hour: 1, minute: 30, timeOfDay: "PM"), dateTime: TaskItem.DateTime(day: 1, month: 2, year: 2023),
                    urgency: "Medium", location: "1450 LakeBoat Way", description: "I dont know what I am having yet", lifespan: 0, isActive: 0, deletingPosition: 0, detailsActive: false),
                TaskItem(
                    name: "Cook Breakfast",
                    startTime: TaskItem.StartTime(hour: 12, minute: 30, timeOfDay: "PM"), endTime: TaskItem.EndTime(hour: 8, minute: 30, timeOfDay: "PM"), dateTime: TaskItem.DateTime(day: 1, month: 2, year: 2023),
                    urgency: "High", location: "723 The Falls Parkway", description: "I am having ube, eggs and rice", lifespan: 0, isActive: 0, deletingPosition: 0, detailsActive: false),
                TaskItem(
                    name: "Cook Dessert",
                    startTime: TaskItem.StartTime(hour: 8, minute: 30, timeOfDay: "PM"), endTime: TaskItem.EndTime(hour: 8, minute: 30, timeOfDay: "PM"), dateTime: TaskItem.DateTime(day: 1, month: 2, year: 2023),
                    urgency: "High", location: "723 The Falls Parkway", description: "I am having ube, eggs and rice", lifespan: 0, isActive: 0, deletingPosition: 0, detailsActive: false),
                TaskItem(
                    name: "Cook Midnight Snack",
                    startTime: TaskItem.StartTime(hour: 12, minute: 30, timeOfDay: "AM"), endTime: TaskItem.EndTime(hour: 8, minute: 30, timeOfDay: "PM"), dateTime: TaskItem.DateTime(day: 1, month: 2, year: 2023),
                    urgency: "High", location: "723 The Falls Parkway", description: "I am having ube, eggs and rice", lifespan: 0, isActive: 0, deletingPosition: 0, detailsActive: false)

            ]
        )
    ]
    @Published var taskItems : [TaskItem] = []
    @Published var accessToNewTaskView = false
    @Published var width = 0.0
    @Published var height = 0.0
    
    func activateNewTaskView() {
        accessToNewTaskView.toggle()
    }
    
    func addTaskToGroup(groupID: Int, givenTask: TaskItem) {
        groupOfTasks[groupID].taskItems.append(givenTask)
    }
    
    func activate(givenItem: TaskItem, groupID: Int, action: String) {
        for (index, item) in groupOfTasks[groupID].taskItems.enumerated() {
            if item.id == givenItem.id {
                if action == "item" {
                    groupOfTasks[groupID].taskItems[index].changeActive()
                } else if action == "position" {
                    groupOfTasks[groupID].taskItems[index].deletingPosition = -150
                } else if action == "details" {
                    groupOfTasks[groupID].taskItems[index].changeDetails()
                }
            }
        }
    }
    
    func deactivate(givenItem: TaskItem, groupID: Int, action: String) {
        for (index, item) in groupOfTasks[groupID].taskItems.enumerated() {
            if item.id == givenItem.id {
                if action == "item" {
                    groupOfTasks[groupID].taskItems[index].resetActive()
                } else if action == "position" {
                    groupOfTasks[groupID].taskItems[index].deletingPosition = 0
                }
            }
        }
    }
        
    func holdItem(givenItem: TaskItem, groupID: Int) {
        for (index, item) in groupOfTasks[groupID].taskItems.enumerated() {
            if item.id == givenItem.id {
                groupOfTasks[groupID].taskItems[index].holdActive()
            }
        }
    }
    
    
    func sortArrayOfTaskItems(groupID: Int) {
        var AMArray = groupOfTasks[groupID].taskItems
        var PMArray = groupOfTasks[groupID].taskItems
        
        AMArray.removeAll(where: {$0.startTime.timeOfDay == "PM"})
        PMArray.removeAll(where: {$0.startTime.timeOfDay == "AM"})

        var sortedAMArray = AMArray.sorted{$0.startTime.hour < $1.startTime.hour}
        var sortedPMArray = PMArray.sorted{$0.startTime.hour < $1.startTime.hour}
        
        for (index,item) in sortedAMArray.enumerated() {
            if item.startTime.hour == 12 {
                let tempItem = item
                sortedAMArray.remove(at: index)
                sortedAMArray.insert(tempItem, at: 0)
            }
        }
        
        for (index,item) in sortedPMArray.enumerated() {
            if item.startTime.hour == 12 {
                let tempItem = item
                sortedPMArray.remove(at: index)
                sortedPMArray.insert(tempItem, at: 0)
            }
        }

        let sortedItems : [TaskItem] = sortedAMArray + sortedPMArray
        groupOfTasks[groupID].taskItems = sortedItems
    }
    
    /// This function returns a VIEW that defines how all 'To Do Items' should look
    func toDoItem(item: TaskItem, groupID: Int) -> some View{
        ZStack {
            self.toDoBackground(item: item, groupID: groupID)
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
                self.toDoItemDetails(item: item, groupID: groupID)
            }
            .frame(width: width / 1.1, height: item.detailsActive ? height / 10 : height / 20)
        }
        .frame(width: width / 1.05, height: item.detailsActive ? height / 4.1 : height / 18)
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
                        .frame(width: 100,height: 40)
                    HStack {
                        Text("\(item.startTime.hour):\(item.startTime.minute)\(item.startTime.timeOfDay)")
                            .fixedSize()
                            .font(.subheadline)
                            .padding(.leading)
                            .foregroundColor(MainData().colors.inactiveWords)
                        Spacer()
                    }
                }
                .frame(width: 50)
                .offset(x: 10)
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
                    //// here is the location
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
                    //// here is the description
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
                .padding(.top, 10)
                Spacer()
            }
        }
    }
    
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
    
    /// This function adds an item to the list of 'To Do Items'
    func addToDoItem(item: TaskItem) {
        taskItems.append(item)
    }
}

struct TaskItem: Identifiable {
    let id = UUID()
    var name: String
    var startTime: StartTime
    var endTime: EndTime
    var dateTime: DateTime
    var urgency: String
    var location: String
    var description: String
    var lifespan: Int
    var isActive: Int
    var deletingPosition: CGFloat
    var detailsActive: Bool
    
    struct StartTime {
        var hour: Int
        var minute: Int
        var timeOfDay: String
    }
    
    struct EndTime {
        var hour: Int
        var minute: Int
        var timeOfDay: String
    }
    
    struct DateTime {
        var day: Int
        var month: Int
        var year: Int
    }
    
    mutating func changeActive() {
        if isActive < 2 {
            isActive += 1
        }
        if isActive == 3 {
            isActive = 2
        }
    }
    
    mutating func holdActive() {
        isActive = 3
    }
    
    mutating func resetActive() {
        isActive = 0
    }
    
    mutating func changeDetails() {
        detailsActive.toggle()
    }
}

struct GroupOfTaskItem: Identifiable {
    var id: Int
    var name: String
    var taskItems: [TaskItem]
    
    mutating func sortTaskItems() {
        taskItems.sort {$0.startTime.hour > $1.startTime.hour}
    }
}
