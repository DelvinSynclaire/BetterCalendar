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
    @State private var checkSubTaskFocus = false
    @FocusState private var subTaskFocus : Bool
    
    @State private var groupName = ""
    @FocusState private var newGroupFocus : Bool

    var body: some View {
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
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation(Animation.spring()) {
                        toDoData.checkTimeForTasks()
                    }
                }
            }
        }
    }
        
    var items: some View {
        ScrollViewReader { value in
            ScrollView {
                VStack{
                    ForEach(toDoData.defaultTasks) { item in
                        ZStack {
                            /// Here is the RESET and DELETE buttons behind the items
                            toDoData.resetAndDeleteButtons(item: item, groupID: groupID)
                            toDoData.toDoItem(item: item, groupID: groupID, bind: $bind, focus: $subTaskFocus)
                                .offset(x: item.deletingPosition)
                                .frame(height: item.detailsActive ? item.frameSize + 10 : 25)
                                .onAppear {
                                    subTaskFocus = true
                                }
                                .onChange(of: subTaskFocus) { thing in
                                    if thing == true {
                                        toDoData.tempTask = item
                                    }
                                    if thing == false {
                                        toDoData.deleteBlankItems()
                                        bind = ""
                                    }
                                }
                                .onSubmit {
                                    if bind == "" {
                                        toDoData.deleteBlankItems()
                                        toDoData.onlyReconfigureFrameSize(item: item)
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            bind = ""
                                            subTaskFocus = true
                                        }
                                    } else {
                                        toDoData.onlyAddSubtask(item: item)
                                        toDoData.setSubTaskName(item: item, bind: bind)
                                        subTaskFocus = true
                                        bind = ""
                                    }
                                    
                                }
                                .gesture(
                                    DragGesture()
                                        .onEnded{ gesture in
                                            if gesture.translation.width < -50 {
                                                withAnimation(Animation.easeIn(duration: 0.2)) {
                                                    toDoData.activate(givenItem: item, action: "position")
                                                }
                                            } else  {
                                                withAnimation(Animation.spring()) {
                                                    toDoData.deactivate(givenItem: item, action: "position")
                                                }
                                            }
                                        }
                                )
                        }
                        .padding(.top)
                    }

                }
                Spacer()
                    .frame(height: main.height)
            }
        }
    }
}

struct ToDoView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
