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
            id: 0, name: "Default", taskItems: []
        )
    ]
    @Published var defaultTasks = [
        TaskItem(
            name: "Brush Teeth",
            startTime: TaskItem.StartTime(time: 600, timeOfDay: "AM"), endTime: TaskItem.EndTime(time: 1000, timeOfDay: "AM"), dateTime: TaskItem.DateTime(day: 1, month: 2, year: 2023) ,
            urgency: "Low", location: "", description: "Something I have to do in the morning", lifespan: 0, isActive: 0, deletingPosition: 0, detailsActive: false, subtasks:
                [], frameSize: MainData().height / 3.8),
        TaskItem(
            name: "Cook Brunch",
            startTime: TaskItem.StartTime(time: 900, timeOfDay: "AM"), endTime: TaskItem.EndTime(time: 800, timeOfDay: "PM"), dateTime: TaskItem.DateTime(day: 1, month: 2, year: 2023),
            urgency: "High", location: "723 The Falls Parkway", description: "I am having ube, eggs and rice", lifespan: 0, isActive: 0, deletingPosition: 0, detailsActive: false, subtasks: [TaskItem.SubTask(name: "Something", isActive: false, isNamed: true)], frameSize: 30),
        TaskItem(
            name: "Cook Dinner",
            startTime: TaskItem.StartTime(time: 300, timeOfDay: "PM"), endTime: TaskItem.EndTime(time: 800, timeOfDay: "PM"), dateTime: TaskItem.DateTime(day: 1, month: 2, year: 2023),
            urgency: "High", location: "723 The Falls Parkway", description: "I am having ube, eggs and rice", lifespan: 0, isActive: 0, deletingPosition: 0, detailsActive: false, subtasks: [], frameSize: 30),
        TaskItem(
            name: "Cook Lunch",
            startTime: TaskItem.StartTime(time: 100, timeOfDay: "PM"), endTime: TaskItem.EndTime(time: 100, timeOfDay: "PM"), dateTime: TaskItem.DateTime(day: 1, month: 2, year: 2023),
            urgency: "Medium", location: "1450 LakeBoat Way", description: "I dont know what I am having yet", lifespan: 0, isActive: 0, deletingPosition: 0, detailsActive: false, subtasks: [], frameSize: 30),
        TaskItem(
            name: "Cook Breakfast",
            startTime: TaskItem.StartTime(time: 1200, timeOfDay: "PM"), endTime: TaskItem.EndTime(time: 800, timeOfDay: "PM"), dateTime: TaskItem.DateTime(day: 1, month: 2, year: 2023),
            urgency: "High", location: "723 The Falls Parkway", description: "I am having ube, eggs and rice", lifespan: 0, isActive: 0, deletingPosition: 0, detailsActive: false, subtasks: [], frameSize: 30),
        TaskItem(
            name: "Cook Dessert",
            startTime: TaskItem.StartTime(time: 800, timeOfDay: "PM"), endTime: TaskItem.EndTime(time: 800, timeOfDay: "PM"), dateTime: TaskItem.DateTime(day: 1, month: 2, year: 2023),
            urgency: "High", location: "723 The Falls Parkway", description: "I am having ube, eggs and rice", lifespan: 0, isActive: 0, deletingPosition: 0, detailsActive: false, subtasks: [], frameSize: 30),
        TaskItem(
            name: "Cook Midnight Snack",
            startTime: TaskItem.StartTime(time: 1200, timeOfDay: "AM"), endTime: TaskItem.EndTime(time: 800, timeOfDay: "PM"), dateTime: TaskItem.DateTime(day: 1, month: 2, year: 2023),
            urgency: "High", location: "723 The Falls Parkway", description: "I am having ube, eggs and rice", lifespan: 0, isActive: 0, deletingPosition: 0, detailsActive: false, subtasks: [], frameSize: 25)
    ]
    
    @Published var accessToNewTaskView = true
    @Published var accessToGroupTaskView = false

    @Published var width = 0.0
    @Published var height = 0.0
    
    @Published var timeComponents = Calendar.current.dateComponents([.hour, .minute, .day, .month, .era], from: Date())

    @Published var tempTask = TaskItem(
        name: "Cook Midnight Snack",
        startTime: TaskItem.StartTime(time: 12, timeOfDay: "AM"), endTime: TaskItem.EndTime(time: 8, timeOfDay: "PM"), dateTime: TaskItem.DateTime(day: 1, month: 2, year: 2023),
        urgency: "High", location: "723 The Falls Parkway", description: "I am having ube, eggs and rice", lifespan: 0, isActive: 0, deletingPosition: 0, detailsActive: false, subtasks: [], frameSize: 25)
    
    @Published var dynamicTask = TaskItem(
        name: "",
        startTime: TaskItem.StartTime(time: 0, timeOfDay: "AM"), endTime: TaskItem.EndTime(time: 0, timeOfDay: "PM"), dateTime: TaskItem.DateTime(day: 0, month: 0, year: 2023),
        urgency: "", location: "", description: "", lifespan: 0, isActive: 0, deletingPosition: 0, detailsActive: false, subtasks: [], frameSize: 0
    )
}
