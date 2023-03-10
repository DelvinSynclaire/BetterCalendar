//
//  ToDoGroupAlgorithm.swift
//  BetterCalendar1.1
//
//  Created by Delvin Cockroft on 2/28/23.
//

import Foundation
import SwiftUI

extension ToDoData {
    func addTaskToGroup(groupID: Int, givenTask: TaskItem) {
        groupOfTasks[groupID].taskItems.append(givenTask)
    }

    func activateGroupTask(givenItem: TaskItem, groupID: Int, action: String) {
        for (index, item) in groupOfTasks[groupID].taskItems.enumerated() {
            if item.id == givenItem.id {
                if action == "item" {
                    groupOfTasks[groupID].taskItems[index].changeActive()
                } else if action == "position" {
                    groupOfTasks[groupID].taskItems[index].deletingPosition = -190
                } else if action == "details" {
                    groupOfTasks[groupID].taskItems[index].changeDetails()
                }
            } else {
                groupOfTasks[groupID].taskItems[index].detailsActive = false
            }
        }
    }
    
    func deactivateGroup(givenItem: TaskItem, groupID: Int, action: String) {
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
    
    
    func holdItemGroup(givenItem: TaskItem, groupID: Int) {
        for (index, item) in groupOfTasks[groupID].taskItems.enumerated() {
            if item.id == givenItem.id {
                groupOfTasks[groupID].taskItems[index].holdActive()
            }
        }
    }
    
    func sortArrayOfTaskItemsGroup(groupID: Int) {
        var AMArray = groupOfTasks[groupID].taskItems
        var PMArray = groupOfTasks[groupID].taskItems
        
        AMArray.removeAll(where: {$0.startTime.timeOfDay == "PM"})
        PMArray.removeAll(where: {$0.startTime.timeOfDay == "AM"})

        var sortedAMArray = AMArray.sorted{$0.startTime.time < $1.startTime.time}
        var sortedPMArray = PMArray.sorted{$0.startTime.time < $1.startTime.time}
        
        for (index,item) in sortedAMArray.enumerated() {
            if item.startTime.time == 12 {
                let tempItem = item
                sortedAMArray.remove(at: index)
                sortedAMArray.insert(tempItem, at: 0)
            }
        }
        
        for (index,item) in sortedPMArray.enumerated() {
            if item.startTime.time == 12 {
                let tempItem = item
                sortedPMArray.remove(at: index)
                sortedPMArray.insert(tempItem, at: 0)
            }
        }

        let sortedItems : [TaskItem] = sortedAMArray + sortedPMArray
        groupOfTasks[groupID].taskItems = sortedItems
    }
    
    func setSubTaskNameGroup(item: TaskItem, groupID: Int, bind: String) {
        for (index, task) in self.groupOfTasks[groupID].taskItems.enumerated() {
            if item.id == task.id {
                let subID = self.groupOfTasks[groupID].taskItems[index].subtasks.count - 1
                self.groupOfTasks[groupID].taskItems[index].subtasks[subID].name = bind
                self.groupOfTasks[groupID].taskItems[index].subtasks[subID].isNamed = true
            }
        }
    }
    
    func addGroupToGroupTask() {
        let emptyGroup = GroupOfTaskItem(id: groupOfTasks.count, name: "", taskItems: [])
        self.groupOfTasks.append(emptyGroup)
    }
    
    func detailsOnAppearConfigureFrameSizeGroup(givenItem: TaskItem, groupID: Int) {
        for (index, task) in self.groupOfTasks[groupID].taskItems.enumerated() {
            if givenItem.id == task.id {
                if task.subtasks.count == 0 {
                    self.groupOfTasks[groupID].taskItems[index].frameSize = 180
                } else {
                    self.groupOfTasks[groupID].taskItems[index].frameSize = CGFloat(210 + givenItem.subtasks.count * 41)
                }
            }
        }
    }
    
    func detailsActivateSubtaskGroup(item: TaskItem,subTask: TaskItem.SubTask, groupID: Int) {
        for (index, task) in self.groupOfTasks[groupID].taskItems.enumerated() {
            if item.id == task.id {
                for (subIndex, sub) in self.groupOfTasks[groupID].taskItems[index].subtasks.enumerated() {
                    if sub.id == subTask.id {
                        self.groupOfTasks[groupID].taskItems[index].subtasks[subIndex].changeActive()
                        if self.groupOfTasks[groupID].taskItems[index].subtasks.allSatisfy({$0.isActive}) {
                            withAnimation(Animation.spring()) {
                                self.groupOfTasks[groupID].taskItems[index].isActive = 2
                            }
                        } else if self.groupOfTasks[groupID].taskItems[index].subtasks.allSatisfy({$0.isActive == false}){
                            withAnimation(Animation.spring()) {
                                self.groupOfTasks[groupID].taskItems[index].isActive = 0
                            }
                        } else {
                            withAnimation(Animation.spring()) {
                                self.groupOfTasks[groupID].taskItems[index].isActive = 1
                            }
                        }
                    }
                }
            }
        }
    }
    
    func detailsDeleteSubtaskGroup(item: TaskItem,subTask: TaskItem.SubTask, groupID: Int) {
        for (index, task) in self.groupOfTasks[groupID].taskItems.enumerated() {
            if item.id == task.id {
                withAnimation(Animation.spring()) {
                    self.groupOfTasks[groupID].taskItems[index].subtasks.removeAll(where: {$0.id == subTask.id})
                    if self.groupOfTasks[groupID].taskItems[index].subtasks.count == 0 {
                        self.groupOfTasks[groupID].taskItems[index].frameSize = 180
                    } else {
                        self.groupOfTasks[groupID].taskItems[index].frameSize -= 40
                    }
                }
            }
        }
    }
    
    func detailsAddSubTaskGroup(item: TaskItem, groupID: Int,bind: Binding<String>) {
        for (index, task) in self.groupOfTasks[groupID].taskItems.enumerated() {
            if item.id == task.id {
                if bind.wrappedValue != "" {
                    self.setSubTaskName(item: item, bind: bind.wrappedValue)
                    bind.wrappedValue = ""
                }
                self.groupOfTasks[groupID].taskItems[index].subtasks.removeAll(where: {$0.name == ""})
                self.groupOfTasks[groupID].taskItems[index].addSubTask()
                withAnimation(Animation.spring()) {
                    if self.groupOfTasks[groupID].taskItems[index].subtasks.count == 0 {
                        self.groupOfTasks[groupID].taskItems[index].frameSize = 190
                    } else {
                        let numOfSubTasks = self.groupOfTasks[groupID].taskItems[index].subtasks.count
                        self.groupOfTasks[groupID].taskItems[index].frameSize = CGFloat(195 + (numOfSubTasks * 45))
                    }
                }
            }
        }
    }
    
    func onlyAddSubtaskGroup(item: TaskItem, groupID: Int) {
        for (index, task) in self.groupOfTasks[groupID].taskItems.enumerated() {
            if item.id == task.id {
                self.groupOfTasks[groupID].taskItems[index].addSubTask()
                withAnimation(Animation.spring()) {
                    let numOfSubTasks = self.groupOfTasks[groupID].taskItems[index].subtasks.count
                    self.groupOfTasks[groupID].taskItems[index].frameSize = CGFloat(180 + (numOfSubTasks * 45))
                }
            }
        }
    }
    
    func onlyReconfigureFrameSizeGroup(item: TaskItem, groupID: Int) {
        for (index, task) in self.groupOfTasks[groupID].taskItems.enumerated() {
            if item.id == task.id {
                withAnimation(Animation.spring()) {
                    let numOfSubTasks = self.groupOfTasks[groupID].taskItems[index].subtasks.count
                    self.groupOfTasks[groupID].taskItems[index].frameSize = CGFloat(180 + (numOfSubTasks * 45))
                }
            }
        }
    }
    
    func deleteBlankSubTasksGroup() {
        for (groupIndex, tasks) in self.groupOfTasks.enumerated() {
            for (taskIndex, _) in tasks.taskItems.enumerated() {
                self.groupOfTasks[groupIndex].taskItems[taskIndex].clearSubTasks()
            }
        }
    }
    
    func deleteBlankTasksGroup() {
        for (index, _) in self.groupOfTasks.enumerated() {
            self.groupOfTasks[index].taskItems.removeAll(where: {$0.name == ""})
        }
    }
    
    func deleteBlankGroups() {
        for _ in self.groupOfTasks {
            self.groupOfTasks.removeAll(where: {$0.name == ""})
        }
    }
    
    func checkTimeForTasksGroup() {
        for group in self.groupOfTasks {
            for(index, task) in self.groupOfTasks[group.id].taskItems.enumerated() {
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
                    self.groupOfTasks[group.id].taskItems[index].changeDetails()
                }
            }
        }
    }
}

