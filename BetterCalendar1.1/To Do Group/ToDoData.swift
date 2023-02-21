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
        Item(name: "Brush Teeth", urgency: "Low", location: "", isActive: 0, deletingPosition: 0, detailsActive: false),
        Item(name: "Cook Breakfast", urgency: "High", location: "723 The Falls Parkway", isActive: 0, deletingPosition: 0, detailsActive: false),
        Item(name: "Cook Lunch", urgency: "Medium", location: "1450 LakeBoat Way", isActive: 0, deletingPosition: 0, detailsActive: false)
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
    
    func activateDetails(givenItem: Item) {
        for (index, item) in items.enumerated() {
            if item.id == givenItem.id {
                items[index].changeDetails()
            }
        }
    }
    
    /// This function returns a VIEW that defines how all 'To Do Items' should look
    func toDoItem(item: Item) -> some View{
        VStack {
            HStack{
                /// here is the button for changing the state
                ZStack {
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
                }
                .onTapGesture {
                    withAnimation(Animation.easeIn){
                        self.activateItem(givenItem: item)
                        if item.isActive == 2 {
                            self.deactivateItem(givenItem: item)
                        }
                    }
                }
               
                HStack {
                    Text("\(item.name)")
                        .padding(.leading)
                        .foregroundColor(item.isActive > 0 ? MainData().colors.activeWords : MainData().colors.inactiveWords)
                        .lineLimit(1)
                    Spacer()
                }
                .frame(width: 150)
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
                Image(systemName: "chevron.down")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(MainData().colors.inactiveWords)
                    .frame(height: 8)
                    .onTapGesture {
                        withAnimation(Animation.spring()) {
                            self.activateDetails(givenItem: item)
                        }
                        print("item ID : \(item.id) name : \(item.name) was selected")
                    }
            }
            
            /// here needs to be the details being displayed on tap
            if item.detailsActive {
                HStack {
                    if item.location.isEmpty == false {
                        Image(systemName: "mappin.and.ellipse")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15)
                            .padding(.trailing, 10)
                            .foregroundColor(Color.white)
                    }
                    Text("\(item.location)")
                        .foregroundColor(MainData().colors.activeWords)
                    Spacer()
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
    var urgency: String
    var location: String
    var isActive: Int
    var deletingPosition: CGFloat
    var detailsActive: Bool
    
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
