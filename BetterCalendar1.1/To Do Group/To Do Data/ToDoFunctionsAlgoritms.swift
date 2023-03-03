//
//  ToDoFunctionsAlgoritms.swift
//  BetterCalendar1.1
//
//  Created by Delvin Cockroft on 2/23/23.
//

import Foundation
import SwiftUI

extension ToDoData {
    func activateNewTaskView() {
        accessToNewTaskView.toggle()
    }
        
    func activate(givenItem: TaskItem, action: String) {
        for (index, item) in defaultTasks.enumerated() {
            if item.id == givenItem.id {
                if action == "item" {
                    defaultTasks[index].changeActive()
                } else if action == "position" {
                    defaultTasks[index].deletingPosition = -190
                } else if action == "details" {
                    defaultTasks[index].changeDetails()
                }
            } else {
                defaultTasks[index].detailsActive = false
            }
        }
    }
        
    func deactivate(givenItem: TaskItem, action: String) {
        for (index, item) in defaultTasks.enumerated() {
            if item.id == givenItem.id {
                if action == "item" {
                    defaultTasks[index].resetActive()
                } else if action == "position" {
                    defaultTasks[index].deletingPosition = 0
                }
            }
        }
    }
    
    func holdItem(givenItem: TaskItem) {
        for (index, item) in defaultTasks.enumerated() {
            if item.id == givenItem.id {
                defaultTasks[index].holdActive()
            }
        }
    }
        
    func sortArrayOfTaskItems() {
        defaultTasks = defaultTasks.sorted(by: {$0.returnStartMilitaryTime() > $1.returnStartMilitaryTime() })
    }
        
    func setSubTaskName(item: TaskItem, bind: String) {
        for (index, task) in self.defaultTasks.enumerated() {
            if item.id == task.id {
                let subID = self.defaultTasks[index].subtasks.count - 1
                self.defaultTasks[index].subtasks[subID].name = bind
                self.defaultTasks[index].subtasks[subID].isNamed = true
            }
        }
    }
    
    // Details functions
    func detailsOnAppearConfigureFrameSize(givenItem: TaskItem) {
        for (index, task) in self.defaultTasks.enumerated() {
            if givenItem.id == task.id {
                if task.subtasks.count == 0 {
                    self.defaultTasks[index].frameSize = 180
                } else {
                    self.defaultTasks[index].frameSize = CGFloat(210 + givenItem.subtasks.count * 41)
                }
            }
        }
    }
    
    func detailsActivateSubtask(item: TaskItem,subTask: TaskItem.SubTask) {
        for (index, task) in self.defaultTasks.enumerated() {
            if item.id == task.id {
                for (subIndex, sub) in self.defaultTasks[index].subtasks.enumerated() {
                    if sub.id == subTask.id {
                        self.defaultTasks[index].subtasks[subIndex].changeActive()
                        if self.defaultTasks[index].subtasks.allSatisfy({$0.isActive}) {
                            withAnimation(Animation.spring()) {
                                self.defaultTasks[index].isActive = 2
                            }
                        } else if self.defaultTasks[index].subtasks.allSatisfy({$0.isActive == false}){
                            withAnimation(Animation.spring()) {
                                self.defaultTasks[index].isActive = 0
                            }
                        } else {
                            withAnimation(Animation.spring()) {
                                self.defaultTasks[index].isActive = 1
                            }
                        }
                    }
                }
            }
        }
    }
    
    func detailsDeleteSubtask(item: TaskItem,subTask: TaskItem.SubTask) {
        for (index, task) in self.defaultTasks.enumerated() {
            if item.id == task.id {
                withAnimation(Animation.spring()) {
                    self.defaultTasks[index].subtasks.removeAll(where: {$0.id == subTask.id})
                    if self.defaultTasks[index].subtasks.count == 0 {
                        self.defaultTasks[index].frameSize = 180
                    } else {
                        self.defaultTasks[index].frameSize -= 40
                    }
                }
            }
        }
    }
    
    func detailsAddSubTask(item: TaskItem,bind: Binding<String>) {
        for (index, task) in self.defaultTasks.enumerated() {
            if item.id == task.id {
                if bind.wrappedValue != "" {
                    self.setSubTaskName(item: item, bind: bind.wrappedValue)
                    bind.wrappedValue = ""
                }
                self.defaultTasks[index].subtasks.removeAll(where: {$0.name == ""})
                self.defaultTasks[index].addSubTask()
                withAnimation(Animation.spring()) {
                    if self.defaultTasks[index].subtasks.count == 0 {
                        self.defaultTasks[index].frameSize = 190
                    } else {
                        let numOfSubTasks = self.defaultTasks[index].subtasks.count
                        self.defaultTasks[index].frameSize = CGFloat(195 + (numOfSubTasks * 45))
                    }
                }
            }
        }
    }
        
    func onlyAddSubtask(item: TaskItem) {
        for (index, task) in self.defaultTasks.enumerated() {
            if item.id == task.id {
                self.defaultTasks[index].addSubTask()
                withAnimation(Animation.spring()) {
                    let numOfSubTasks = self.defaultTasks[index].subtasks.count
                    self.defaultTasks[index].frameSize = CGFloat(180 + (numOfSubTasks * 45))
                }
            }
        }
    }
    
    func onlyReconfigureFrameSize(item: TaskItem) {
        for (index, task) in self.defaultTasks.enumerated() {
            if item.id == task.id {
                withAnimation(Animation.spring()) {
                    let numOfSubTasks = self.defaultTasks[index].subtasks.count
                    self.defaultTasks[index].frameSize = CGFloat(180 + (numOfSubTasks * 45))
                }
            }
        }
    }
    
    /// deleting functions
    func deleteBlankItems() {
        self.deleteBlankSubTasks()
        self.deleteBlankTasks()
        self.deleteBlankGroups()
    }
    
    func deleteBlankSubTasks() {
        for (taskIndex, _) in defaultTasks.enumerated() {
            self.defaultTasks[taskIndex].clearSubTasks()
        }
    }
    
    func deleteBlankTasks() {
        for (_, _) in self.defaultTasks.enumerated() {
            self.defaultTasks.removeAll(where: {$0.name == ""})
        }
    }
    
    func checkTimeForTasks() {
        for _ in self.defaultTasks {
            for(index, task) in self.defaultTasks.enumerated() {
                var tempStartTime = 0
                var tempEndTime = 0
                if task.startTime.timeOfDay == "PM" {
                    tempStartTime = task.startTime.time + 12
                } else {
                    tempStartTime = task.startTime.time
                }
                if task.endTime.timeOfDay == "PM" {
                    tempEndTime = task.endTime.time + 12
                } else {
                    tempEndTime = task.endTime.time
                }
                if self.timeComponents.hour! > tempStartTime && self.timeComponents.hour! < tempEndTime {
                    self.defaultTasks[index].changeDetails()
                }
            }
        }

    }
    
    func addTaskToDefaultTasks(givenTask: TaskItem) {
        defaultTasks.append(givenTask)
    }
}
