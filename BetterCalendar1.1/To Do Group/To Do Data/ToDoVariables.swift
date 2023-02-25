//
//  ToDoVariables.swift
//  BetterCalendar1.1
//
//  Created by Delvin Cockroft on 2/23/23.
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
                    urgency: "Low", location: "", description: "Something I have to do in the morning", lifespan: 0, isActive: 0, deletingPosition: 0, detailsActive: false, subtasks:
                        [], frameSize: MainData().height / 3.8),
                TaskItem(
                    name: "Cook Brunch",
                    startTime: TaskItem.StartTime(hour: 9, minute: 30, timeOfDay: "AM"), endTime: TaskItem.EndTime(hour: 8, minute: 30, timeOfDay: "PM"), dateTime: TaskItem.DateTime(day: 1, month: 2, year: 2023),
                    urgency: "High", location: "723 The Falls Parkway", description: "I am having ube, eggs and rice", lifespan: 0, isActive: 0, deletingPosition: 0, detailsActive: false, subtasks: [TaskItem.SubTask(name: "Something", isActive: false, isNamed: true)], frameSize: 30),
                TaskItem(
                    name: "Cook Dinner",
                    startTime: TaskItem.StartTime(hour: 3, minute: 30, timeOfDay: "PM"), endTime: TaskItem.EndTime(hour: 8, minute: 30, timeOfDay: "PM"), dateTime: TaskItem.DateTime(day: 1, month: 2, year: 2023),
                    urgency: "High", location: "723 The Falls Parkway", description: "I am having ube, eggs and rice", lifespan: 0, isActive: 0, deletingPosition: 0, detailsActive: false, subtasks: [], frameSize: 30),
                TaskItem(
                    name: "Cook Lunch",
                    startTime: TaskItem.StartTime(hour: 1, minute: 30, timeOfDay: "PM"), endTime: TaskItem.EndTime(hour: 1, minute: 30, timeOfDay: "PM"), dateTime: TaskItem.DateTime(day: 1, month: 2, year: 2023),
                    urgency: "Medium", location: "1450 LakeBoat Way", description: "I dont know what I am having yet", lifespan: 0, isActive: 0, deletingPosition: 0, detailsActive: false, subtasks: [], frameSize: 30),
                TaskItem(
                    name: "Cook Breakfast",
                    startTime: TaskItem.StartTime(hour: 12, minute: 30, timeOfDay: "PM"), endTime: TaskItem.EndTime(hour: 8, minute: 30, timeOfDay: "PM"), dateTime: TaskItem.DateTime(day: 1, month: 2, year: 2023),
                    urgency: "High", location: "723 The Falls Parkway", description: "I am having ube, eggs and rice", lifespan: 0, isActive: 0, deletingPosition: 0, detailsActive: false, subtasks: [], frameSize: 30),
                TaskItem(
                    name: "Cook Dessert",
                    startTime: TaskItem.StartTime(hour: 8, minute: 30, timeOfDay: "PM"), endTime: TaskItem.EndTime(hour: 8, minute: 30, timeOfDay: "PM"), dateTime: TaskItem.DateTime(day: 1, month: 2, year: 2023),
                    urgency: "High", location: "723 The Falls Parkway", description: "I am having ube, eggs and rice", lifespan: 0, isActive: 0, deletingPosition: 0, detailsActive: false, subtasks: [], frameSize: 30),
                TaskItem(
                    name: "Cook Midnight Snack",
                    startTime: TaskItem.StartTime(hour: 12, minute: 30, timeOfDay: "AM"), endTime: TaskItem.EndTime(hour: 8, minute: 30, timeOfDay: "PM"), dateTime: TaskItem.DateTime(day: 1, month: 2, year: 2023),
                    urgency: "High", location: "723 The Falls Parkway", description: "I am having ube, eggs and rice", lifespan: 0, isActive: 0, deletingPosition: 0, detailsActive: false, subtasks: [], frameSize: 25)

            ]
        )
    ]
    @Published var accessToNewTaskView = false
    @Published var width = 0.0
    @Published var height = 0.0
   
}
