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
        Item(name: "do this Number 1", urgency: "High", isActive: 0, deletingPosition: 0),
        Item(name: "do this Number 2", urgency: "High", isActive: 0, deletingPosition: 0),
        Item(name: "do this Number 3", urgency: "High", isActive: 0, deletingPosition: 0)
    ]
    
    func activateItem(givenItem: Item) {
        for (index, item) in items.enumerated() {
            if item.id == givenItem.id {
                items[index].changeActive()
            }
        }
    }
    
    func deactivateItem(givenItem: Item) {
        for (index, item) in items.enumerated() {
            if item.id == givenItem.id {
                items[index].resetActive()
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
    
    func activateDeletingPosition(givenItem: Item) {
        for (index, item) in items.enumerated() {
            if item.id == givenItem.id {
                items[index].deletingPosition = -150
            }
        }
    }
    
    func deactivateDeletingPosition(givenItem: Item) {
        for (index, item) in items.enumerated() {
            if item.id == givenItem.id {
                items[index].deletingPosition = 0
            }
        }
    }
    
    /// This function returns a VIEW that defines how all 'To Do Items' should look
    func toDoItem(item: Item) -> some View{
        HStack{
            if item.isActive == 0{
                RoundedRectangle(cornerRadius: 7)
                    .stroke(lineWidth: 2)
                    .foregroundColor(MainData().colors.inactiveWords)
                    .frame(width: 30, height: 30)
                    
            } else if item.isActive == 1{
                RoundedRectangle(cornerRadius: 7)
                    .fill(MainData().colors.inProgressColor)
                    .frame(width: 30, height: 30)
                    .overlay(
                        Image(systemName: "dot.circle")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color.white)
                            .frame(width: 15)
                    )
            }  else if item.isActive == 2{
                RoundedRectangle(cornerRadius: 7)
                    .fill(MainData().colors.completedColor)
                    .frame(width: 30, height: 30)
                    .overlay(
                        Image(systemName: "checkmark")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color.white)
                            .frame(width: 15)
                    )
            }  else if item.isActive == 3{
                RoundedRectangle(cornerRadius: 7)
                    .fill(MainData().colors.onHoldColor)
                    .frame(width: 30, height: 30)
                    .overlay(
                        Image(systemName: "minus.circle")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color.white)
                            .frame(width: 15)
                    )
            }
            Text("\(item.name)")
                .foregroundColor(item.isActive > 0 ? MainData().colors.activeWords : MainData().colors.inactiveWords)
            Text("\(item.urgency)")
                .foregroundColor(item.isActive > 0 ? MainData().colors.activeWords : MainData().colors.inactiveWords)
            Spacer()
        }
        .padding([.leading, .trailing])
    }
    
    /// This function adds an item to the list of 'To Do Items'
    func addToDoItem(item: Item) {
        items.append(item)
    }
}

struct Item: Identifiable {
    let id = UUID()
    var name: String
    var urgency: String
    var isActive: Int
    var deletingPosition: CGFloat
    
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
}
