//
//  NewTaskData.swift
//  BetterCalendar1.1
//
//  Created by Delvin Cockroft on 2/17/23.
//

import Foundation
import SwiftUI

class NewTaskData: ObservableObject {
    /// Here is a changing task that can be added to the 'To Do' list
    @Published var dynamicTask = TaskItem(
        name: "",
        startTime: TaskItem.StartTime(time: 0, timeOfDay: "AM"), endTime: TaskItem.EndTime(time: 0, timeOfDay: "PM"), dateTime: TaskItem.DateTime(day: 0, month: 0, year: 2023),
        urgency: "", location: "", description: "", lifespan: 0, isActive: 0, deletingPosition: 0, detailsActive: false, subtasks: [], frameSize: 0
    )
    /// this is a published variable to define the animatable data for the black seperator on the 'new task view
    @Published var backgroundSeperator: DataForAnimation = DataForAnimation(frameWidth: 0, frameHeight: 0, offsetX: 0, offsetY: 0, opacity: 0.5)
    /// this is a published variable to define the animatable data for the white rectangle in the 'new task' view
    @Published var backgroundCard: DataForAnimation = DataForAnimation(frameWidth: 0, frameHeight: 0, offsetX: 0, offsetY: 0, opacity: 0)
    
    func backgroundSeperatorAnimation(isActive: Bool) {
        if isActive{
            withAnimation(Animation.spring()) {
                backgroundSeperator.opacity = 0.6
            }
        } else {
            withAnimation(Animation.spring()) {
                backgroundSeperator.opacity = 0
            }
        }
    }
    func backgroundCardAnimation(isActive: Bool) {
                if isActive {
            withAnimation(Animation.spring()) {
                backgroundCard.offsetY = 200
            }
        } else {
            withAnimation(Animation.spring()) {
                backgroundCard.offsetY = 200
            }
        }
    }
    
    func resetDynamicTaskItem() {
        dynamicTask = TaskItem(
            name: "",
            startTime: TaskItem.StartTime(time: 0, timeOfDay: "AM"), endTime: TaskItem.EndTime(time: 0, timeOfDay: "PM"), dateTime: TaskItem.DateTime(day: 0, month: 0, year: 2023),
            urgency: "", location: "", description: "", lifespan: 0, isActive: 0, deletingPosition: 0, detailsActive: false, subtasks: [], frameSize: 0
        )
    }
}
