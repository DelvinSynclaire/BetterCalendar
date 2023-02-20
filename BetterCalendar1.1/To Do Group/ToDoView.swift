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
            if toDoData.items.isEmpty{
                noItems
            } else {
                items
            }
            if top.accessToAddMenu{
                NewTaskView(top: top,toDoData: toDoData, newTask: newTask, main: main)
            }
        }
       
    }
    
    var items: some View {
        GeometryReader{ geo in
            ScrollView{
                VStack{
                    ForEach(toDoData.items){ item in
                        ZStack {
                            /// Here is the RESET and DELETE buttons behind the items
                            HStack {
                                Spacer()
                                Button {
                                    toDoData.deactivateItem(givenItem: item)
                                    toDoData.deactivateDeletingPosition(givenItem: item)
                                } label: {
                                    Text("RESET")
                                        .padding(.trailing, 5)
                                }
                                Button {
                                    toDoData.items.removeAll(where: {$0.id == item.id})
                                } label: {
                                    Text("DELETE")
                                        .padding(.trailing)
                                }
                            }
                            
                            toDoData.toDoItem(item: item)
                                .offset(x: item.deletingPosition)
                                .background(
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10)
                                            .offset(x: item.deletingPosition)
                                            .fill(main.colors.mainBackground)
                                            .padding([.trailing, .leading], 5)
                                            .frame(height: 50)
                                        if item.isActive < 1 {
                                            RoundedRectangle(cornerRadius: 10)
                                                .offset(x: item.deletingPosition)
                                                .fill(main.colors.secondaryBackground)
                                                .padding([.trailing, .leading], 5)
                                                .frame(height: 50)
                                        } else {
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(lineWidth: 2)
                                                .offset(x: item.deletingPosition)
                                                .fill(main.colors.secondaryBackground)
                                                .padding([.trailing, .leading], 5)
                                                .frame(height: 50)
                                        }
                                    }
                                )
                                .frame(width: geo.size.width,height: geo.size.height / 10)
                                .onTapGesture {
                                    withAnimation(Animation.easeIn){
                                        toDoData.activateItem(givenItem: item)
                                        if item.isActive == 2 {
                                            toDoData.deactivateItem(givenItem: item)
                                        }
                                    }
                                }
                                .onLongPressGesture {
                                    withAnimation(Animation.easeIn){
                                        toDoData.holdItem(givenItem: item)
                                    }
                                }
                                .gesture(
                                    DragGesture()
                                        .onEnded{ gesture in
                                            if gesture.translation.width < -50 {
                                                withAnimation(Animation.easeIn(duration: 0.2)) {
                                                    toDoData.activateDeletingPosition(givenItem: item)
                                                }
                                            } else  {
                                                withAnimation(Animation.spring()) {
                                                    toDoData.deactivateDeletingPosition(givenItem: item)
                                                }
                                            }
                                        }
                            )
                        }
                        .padding(.top)
                        .frame(height: main.height / 18)
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
