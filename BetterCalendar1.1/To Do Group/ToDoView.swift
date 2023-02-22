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

    var body: some View {
        ZStack{
            items
            if top.accessToAddMenu{
                NewTaskView(top: top,toDoData: toDoData, newTask: newTask, main: main)
            }
        }
    }
    
    var items: some View {
        GeometryReader{ geo in
            ScrollView{
                VStack{
                    ForEach(toDoData.groupOfTasks){ group in
                        VStack {
                            Text("\(group.name)")
                                .font(.title)
                                .foregroundColor(Color.white)
                            ForEach(group.taskItems) { item in
                                ZStack {
                                    /// Here is the RESET and DELETE buttons behind the items
                                    HStack {
                                        Spacer()
                                        Button {
                                            toDoData.deactivate(givenItem: item, groupID: group.id, action: "item")
                                            toDoData.deactivate(givenItem: item, groupID: group.id, action: "position")
                                        } label: {
                                            Text("RESET")
                                                .padding(.trailing, 5)
                                        }
                                        Button {
                                            toDoData.taskItems.removeAll(where: {$0.id == item.id})
                                        } label: {
                                            Text("DELETE")
                                                .padding(.trailing)
                                        }
                                    }
                                    
                                    toDoData.toDoItem(item: item, groupID: group.id)
                                        .offset(x: item.deletingPosition)
                                        .frame(width: geo.size.width,height: geo.size.height / 10)
                                        .onLongPressGesture {
                                            withAnimation(Animation.easeIn){
                                                toDoData.holdItem(givenItem: item, groupID: group.id)
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
                                .frame(height: item.detailsActive ? 190 : 50)
                            }
                        }
                        .onAppear{
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation(Animation.spring()) {
                                    toDoData.sortArrayOfTaskItems(groupID: group.id)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    var noItems: some View {
        ZStack{
            
        }
    }
}

struct ToDoView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
