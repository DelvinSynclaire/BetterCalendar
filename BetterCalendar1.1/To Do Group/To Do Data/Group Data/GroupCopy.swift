////
////  GroupCopy.swift
////  BetterCalendar1.1
////
////  Created by Delvin Cockroft on 2/28/23.
////
//
//import Foundation
//import SwiftUI
//
//ForEach(toDoData.groupOfTasks){ group in
//    VStack {
//        HStack {
//            if group.name == "" {
//                TextField("", text: $groupName)
//                    .focused($newGroupFocus)
//                    .font(.title)
//                    .bold()
//                    .padding(.leading)
//                    .foregroundColor(Color.white)
//                    .frame(width: 200)
//                    .onAppear {
//                        newGroupFocus = true
//                    }
//                    .onSubmit {
//                        for (index, groups) in toDoData.groupOfTasks.enumerated() {
//                            if group.id == groups.id {
//                                toDoData.groupOfTasks[index].name = groupName
//                                groupName = ""
//                            }
//                        }
//                    }
//                    .onChange(of: newGroupFocus) { change in
//                        let groupNumber = toDoData.groupOfTasks.count
//                        withAnimation(Animation.spring()) {
//                            value.scrollTo(groupNumber - 1, anchor: .top)
//                        }
//                    }
//            } else {
//                Text("\(group.name)")
//                    .font(.title)
//                    .bold()
//                    .padding(.leading)
//                    .foregroundColor(Color.white)
//                Text("\(group.taskItems.count)")
//                    .font(.subheadline)
//                    .padding(.leading)
//                    .foregroundColor(main.colors.inactiveWords)
//            }
//            Spacer()
//            Button {
//                for (_, groups) in toDoData.groupOfTasks.enumerated() {
//                    if group.id == groups.id {
//                        withAnimation(Animation.spring()) {
//                            toDoData.groupOfTasks.removeAll(where: {$0.id == groups.id})
//                            value.scrollTo(0, anchor: .top)
//                        }
//
//                    }
//                }
//            } label: {
//                ZStack {
//                    Circle()
//                        .fill(main.colors.secondaryBackground)
//                        .frame(width: 22)
//                    Image(systemName: "xmark")
//                        .resizable()
//                        .scaledToFit()
//                        .foregroundColor(Color.white)
//                        .frame(width: 9)
//                }
//            }
//        }
//        Button {
//            toDoData.deleteBlankItems()
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                toDoData.activateNewTaskView()
//            }
//
//            groupID = group.id
//        }label: {
//            ZStack {
//                RoundedRectangle(cornerRadius: 10)
//                    .stroke(lineWidth: 2)
//                    .fill(main.colors.secondaryBackground)
//                    .frame(height: 25)
//                Image(systemName: "plus")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 18)
//                    .foregroundColor(main.colors.secondaryBackground)
//            }
//            .padding(.top, 7)
//        }
//    }
//    .id(group.id)
//    .onAppear{
//        toDoData.sortArrayOfTaskItems(groupID: group.id)
//    }
//}
