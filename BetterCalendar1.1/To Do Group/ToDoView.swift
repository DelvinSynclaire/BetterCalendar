//
//  ToDoView.swift
//  BetterCalendar1.1
//
//  Created by Delvin Cockroft on 2/17/23.
//

import SwiftUI

struct ToDoView: View {
    @ObservedObject var newTask = NewTaskData()
    @StateObject var top: TopBarData
    @StateObject var toDoData: ToDoData
    @StateObject var main: MainData
    
    @State private var groupID = 0
    @State private var bind = ""
    @FocusState private var subTaskFocus : Bool

    var body: some View {
        ScrollView {
            VStack {
                ZStack{
                    items
                        .frame(width: main.width / 1.1)
                    if toDoData.accessToNewTaskView{
                        NewTaskView(top: top,toDoData: toDoData, newTask: newTask, main: main, groupID: $groupID)
                    }
                }
                .onAppear {
                    toDoData.width = main.width
                    toDoData.height = main.height
                }
            }
        }
    }
    
    var items: some View {
        VStack{
            ForEach(toDoData.groupOfTasks){ group in
                VStack {
                    HStack {
                        Text("\(group.name)")
                            .font(.title)
                            .bold()
                            .padding(.leading)
                            .foregroundColor(Color.white)
                        Text("\(group.taskItems.count)")
                            .font(.subheadline)
                            .padding(.leading)
                            .foregroundColor(main.colors.inactiveWords)
                        Spacer()
                    }
                    ForEach(group.taskItems) { item in
                        ZStack {
                            /// Here is the RESET and DELETE buttons behind the items
                            toDoData.resetAndDeleteButtons(item: item, groupID: group.id)
                            
                            toDoData.toDoItem(item: item, groupID: group.id, bind: $bind, focus: $subTaskFocus)
                                .offset(x: item.deletingPosition)
                                .frame(height: item.detailsActive ? item.frameSize + 10 : 25)
                                .onAppear {
                                    subTaskFocus = true
                                }
                                .onSubmit {
                                    toDoData.setSubTaskName(item: item, groupID: group.id, bind: bind)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        bind = ""
                                        subTaskFocus = true
                                    }
                                }
                                .gesture(
                                    DragGesture()
                                        .onEnded{ gesture in
                                            if gesture.translation.width < -50 {
                                                withAnimation(Animation.easeIn(duration: 0.2)) {
                                                    toDoData.activate(givenItem: item, groupID: group.id, action: "position")
                                                }
                                            } else  {
                                                withAnimation(Animation.spring()) {
                                                    toDoData.deactivate(givenItem: item, groupID: group.id, action: "position")
                                                }
                                            }
                                        }
                                )
                        }
                        .padding(.top)
                    }
                    Button {
                        toDoData.activateNewTaskView()
                        groupID = group.id
                    }label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 2)
                                .fill(main.colors.secondaryBackground)
                                .frame(height: 25)
                            Image(systemName: "plus")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18)
                                .foregroundColor(main.colors.secondaryBackground)
                        }
                        .padding(.top, 7)
                    }
                }
                .onAppear{
                    toDoData.sortArrayOfTaskItems(groupID: group.id)
                }
            }
        }
    }
}

struct ToDoView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
