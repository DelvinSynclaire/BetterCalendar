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
    
    mutating func addSubTask() {
        subtasks.append(SubTask(name: "", isActive: false, isNamed: false))
    }
    
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
