//
//  ToDoData.swift
//  BetterCalendar1.1
//
//  Created by Delvin Cockroft on 2/17/23.
//

import Foundation
import SwiftUI

class ToDoData: ObservableObject {
    @Published var items : [Item] = [
        Item(
            name: "Brush Teeth",
            startTime: Item.StartTime(hour: 6, minute: 30, timeOfDay: "AM"), endTime: Item.EndTime(hour: 10, minute: 30, timeOfDay: "AM"), dateTime: Item.DateTime(day: 1, month: 2, year: 2023) ,
            urgency: "Low", location: "", descrition: "Something I have to do in the morning", isActive: 0, deletingPosition: 0, detailsActive: false),
        Item(
            name: "Cook Breakfast",
            startTime: Item.StartTime(hour: 3, minute: 30, timeOfDay: "PM"), endTime: Item.EndTime(hour: 8, minute: 30, timeOfDay: "PM"), dateTime: Item.DateTime(day: 1, month: 2, year: 2023),
            urgency: "High", location: "723 The Falls Parkway", descrition: "I am having ube, eggs and rice", isActive: 0, deletingPosition: 0, detailsActive: false),
        Item(
            name: "Cook Lunch",
            startTime: Item.StartTime(hour: 1, minute: 30, timeOfDay: "AM"), endTime: Item.EndTime(hour: 1, minute: 30, timeOfDay: "PM"), dateTime: Item.DateTime(day: 1, month: 2, year: 2023),
            urgency: "Medium", location: "1450 LakeBoat Way", descrition: "I dont know what I am having yet", isActive: 0, deletingPosition: 0, detailsActive: false
        )
    ]
    
    func activate(givenItem: Item, action: String) {
        for (index, item) in items.enumerated() {
            if item.id == givenItem.id {
                if action == "item" {
                    items[index].changeActive()
                } else if action == "position" {
                    items[index].deletingPosition = -150
                } else if action == "details" {
                    items[index].changeDetails()

                }
            }
        }
    }
    
    func deactivate(givenItem: Item, action: String) {
        for (index, item) in items.enumerated() {
            if item.id == givenItem.id {
                if action == "item" {
                    items[index].resetActive()
                } else if action == "position" {
                    items[index].deletingPosition = 0
                }
            }
        }
    }
        
    func holdItem(givenItem: Item) {
        for (index, item) in items.enumerated() {
            if item.id == givenItem.id {
                items[index].holdActive()
            }
        }
    }
    
    
    /// This function returns a VIEW that defines how all 'To Do Items' should look
    func toDoItem(item: Item) -> some View{
        VStack {
            HStack{
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
                        self.activate(givenItem: item, action: "item")
                        if item.isActive == 2 {
                            self.deactivate(givenItem: item, action: "item")
                        }
                    }
                }
               
                //// here is the title of the task (its on the far right of a task tile)
                HStack {
                    Text("\(item.name)")
                        .padding(.leading)
                        .foregroundColor(item.isActive > 0 ? MainData().colors.activeWords : MainData().colors.inactiveWords)
                        .lineLimit(1)
                    Spacer()
                }
                .frame(width: 150)
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
                //// here is the status of the task (its on the left of the name)
                let activeDescription = ["", "In Progress", "Complete", "On Hold"]
                Text("\(activeDescription[item.isActive])")
                    .fixedSize()
                    .font(.subheadline)
                    .padding(.leading)
                    .foregroundColor(item.isActive > 0 ? MainData().colors.activeWords : MainData().colors.inactiveWords)
                    .frame(width: 100)
                if item.urgency == "High" && item.isActive != 0{
                    Image(systemName: "exclamationmark")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(MainData().colors.activeWords)
                        .frame(height: 20)
                }
                Spacer()
                if item.deletingPosition == 0 {
                    Image(systemName: "chevron.down")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(MainData().colors.inactiveWords)
                        .frame(height: 8)
                        .onTapGesture {
                            withAnimation(Animation.spring()) {
                                self.activate(givenItem: item, action: "details")
                            }
                            print("item ID : \(item.id) name : \(item.name) was selected")
                        }
                }
            }
            
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
                        if item.descrition.isEmpty {
                            Text("No Description")
                                .foregroundColor(MainData().colors.activeWords)
                        } else {
                            Text("\(item.descrition)")
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
        .frame(height: item.detailsActive ? 150 : 50)
        .padding([.leading, .trailing])
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .offset(x: item.deletingPosition)
                    .fill(MainData().colors.mainBackground)
                    .padding([.trailing, .leading], 5)
                    .frame(height: item.detailsActive ? 180 : 50)
                if item.isActive < 1 {
                    RoundedRectangle(cornerRadius: 10)
                        .offset(x: item.deletingPosition)
                        .fill(MainData().colors.secondaryBackground)
                        .padding([.trailing, .leading], 5)
                        .frame(height: item.detailsActive ? 180 : 50)
                } else {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .offset(x: item.deletingPosition)
                        .fill(MainData().colors.secondaryBackground)
                        .padding([.trailing, .leading], 5)
                        .frame(height: item.detailsActive ? 180 : 50)
                }
            }
        )

    }
    
    /// This function adds an item to the list of 'To Do Items'
    func addToDoItem(item: Item) {
        items.append(item)
    }
}

struct Item: Identifiable {
    let id = UUID()
    var name: String
    var startTime: StartTime
    var endTime: EndTime
    var dateTime: DateTime
    var urgency: String
    var location: String
    var descrition: String
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
