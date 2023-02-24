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
}
