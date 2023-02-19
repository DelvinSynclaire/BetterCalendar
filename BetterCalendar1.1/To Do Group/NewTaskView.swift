//
//  NewTaskView.swift
//  BetterCalendar1.1
//
//  Created by Delvin Cockroft on 2/17/23.
//

import SwiftUI

struct NewTaskView: View {
    @StateObject var top: TopBarData
    @StateObject var toDoData: ToDoData
    @StateObject var newTask: NewTaskData
    @StateObject var main: MainData
    
    var body: some View {
        ZStack {
            /// here is the black seperator for 'new task' view
            Color.black
                .opacity(newTask.backgroundSeperator.opacity)
                .ignoresSafeArea()
                .offset(y: -main.height / 10)
            /// here is the card that host the information for adding a new task
           newTaskCard
        }
        .frame(height: main.height)
        .onAppear{
            newTask.backgroundSeperatorAnimation(isActive: true)
            newTask.backgroundCardAnimation(isActive: true)
        }
        .onDisappear{
            newTask.backgroundSeperatorAnimation(isActive: false)
            newTask.backgroundCardAnimation(isActive: false)
        }
    }
    var newTaskCard: some View {
        VStack {
            Spacer()
            ZStack {
               background
                VStack {
                    CreateNewTask
                    title
                    taskType
                    description
                    Button {
                        toDoData.items.append(newTask.dynamicTask)
                        top.accessAddMenu()
                        print("New task added to List with ID : \(newTask.dynamicTask.id)")
                    } label: {
                        addButton
                    }
                }
            }
        }
        .offset(y: newTask.backgroundCard.offsetY)
    }
    var background: some View {
        RoundedRectangle(cornerRadius: 25)
            .fill(Color.white)
            .frame(height: main.height / 2)
    }
    
    var CreateNewTask: some View {
        HStack {
            Text("Create new task ")
            Spacer()
            Button {
                top.accessAddMenu()
            } label: {
                ZStack {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 25)
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color.black)
                        .frame(width: 12)
                }
            }
        }
        .padding()
    }
    
    var title: some View {
        VStack {
            HStack {
                Text("Title")
                Spacer()
            }
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.blue)
                .frame(height: main.height / 20)
        }
        .padding()
    }
    
    var taskType: some View {
        Text("task type")
    }
    
    var description: some View {
        Text("description")
    }
    
    var addButton: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.red)
                .frame(height: main.height / 20)
            HStack {
                Text("Add")
                Spacer()
                Image(systemName: "plus")
            }
            .foregroundColor(Color.white)
            .padding()
        }
        .padding()
    }
}

struct NewTaskView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
