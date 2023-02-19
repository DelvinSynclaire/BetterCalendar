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
                        toDoData.toDoItem(item: item)
                            .frame(width: geo.size.width,height: geo.size.height / 10)
                            .onTapGesture {
                                withAnimation(Animation.easeIn){
                                    toDoData.items[item.id].isActive.toggle()
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
