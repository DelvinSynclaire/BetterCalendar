//
//  ToDoStructs.swift
//  BetterCalendar1.1
//
//  Created by Delvin Cockroft on 2/23/23.
//

import Foundation
import SwiftUI

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
    var subtasks: [SubTask]
    var frameSize: CGFloat
    
    struct SubTask: Identifiable {
        var id = UUID()
        var name : String
        var isActive: Bool
        var isNamed: Bool
        
        mutating func changeActive() {
            isActive.toggle()
        }
    }
    
    func returnStartMilitaryTime() -> Int {
        var militaryTime = 0
        if startTime.timeOfDay == "PM" {
            militaryTime = startTime.time + 1200
        }
        return militaryTime
    }
    
    func returnEndMilitaryTime() -> Int {
        var standardTime = 0
        if endTime.timeOfDay == "PM" {
            standardTime = endTime.time + 1200
        }
        return standardTime
    }
    
    func returnProperDisplayOfStartTime() -> String {
        var properDisplayOfTime = ""
        if startTime.time >= 1000 {
            properDisplayOfTime = String(format: "%02d", startTime.time)
            properDisplayOfTime.insert(":", at: properDisplayOfTime.index(properDisplayOfTime.startIndex, offsetBy: 2))
        } else {
            properDisplayOfTime = String(format: "%01d", startTime.time)
            properDisplayOfTime.insert(":", at: properDisplayOfTime.index(properDisplayOfTime.startIndex, offsetBy: 1))
        }
        properDisplayOfTime.append("\(startTime.timeOfDay)")
        return properDisplayOfTime
    }
    
    func returnProperDisplayOfEndTime() -> String {
        var properDisplayOfTime = ""
        if endTime.time >= 1000 {
            properDisplayOfTime = String(format: "%02d", endTime.time)
            properDisplayOfTime.insert(":", at: properDisplayOfTime.index(properDisplayOfTime.startIndex, offsetBy: 2))
        } else {
            properDisplayOfTime = String(format: "%01d", endTime.time)
            properDisplayOfTime.insert(":", at: properDisplayOfTime.index(properDisplayOfTime.startIndex, offsetBy: 1))
        }
        properDisplayOfTime.append("\(endTime.timeOfDay)")
        return properDisplayOfTime
    }
    
    mutating func clearSubTasks() {
        subtasks.removeAll(where: {$0.isNamed == false})
    }
    
    mutating func addSubTask() {
        subtasks.append(SubTask(name: "", isActive: false, isNamed: false))
    }
    
    struct StartTime {
        var time: Int
        var timeOfDay: String
    }
    
    struct EndTime {
        var time: Int
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
        taskItems.sort {$0.startTime.time > $1.startTime.time}
    }
}
