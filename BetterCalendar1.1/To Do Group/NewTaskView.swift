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
    
    @FocusState private var titleFieldIsFocus: Bool
    @FocusState private var locationFieldIsFocus: Bool

    @State private var titleIsTyping = false
    @State private var locationIsTyping = false
    
    var body: some View {
        ZStack {
            /// here is the black seperator for 'new task' view
            Color.black
                .opacity(newTask.backgroundSeperator.opacity)
                .ignoresSafeArea()
                .offset(y: -main.height / 10)
            /// here is the card that host the information for adding a new task
           newTaskCard
                .foregroundColor(main.colors.activeWords)
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
                    Spacer()
                    description
                    location
                    Spacer()
                    addButton
                }
                .padding()
            }
            .frame(height: main.height / 2)
        }
        .offset(y: newTask.backgroundCard.offsetY)
    }
    var background: some View {
        RoundedRectangle(cornerRadius: 25)
            .fill(main.colors.secondaryBackground)
    }
    
    var CreateNewTask: some View {
        HStack {
            Text("Create new task ")
                .font(.title2)
                .bold()
            Spacer()
            Button {
                top.accessAddMenu()
            } label: {
                ZStack {
                    Circle()
                        .fill(main.colors.inProgressColor)
                        .frame(width: 22)
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color.white)
                        .frame(width: 9)
                }
            }
        }
        .padding()
    }
    
    var title: some View {
        VStack {
            HStack {
                ZStack {
                    if titleIsTyping == false {
                        Text("Enter Name Here")
                            .foregroundColor(main.colors.inactiveWords)
                            .padding(.trailing, 25)
                    }
                    TextField("",text: $newTask.dynamicTask.name)
                        .foregroundColor(Color.white)
                        .padding(.leading)
                        .focused($titleFieldIsFocus)
                        .onSubmit {
                            titleIsTyping = true
                        }
                        .onChange(of: titleFieldIsFocus) { title in
                            if title == true {
                                titleIsTyping = true
                            }
                            if title == false {
                                titleIsTyping = false
                            }
                        }
                }
                .frame(width: main.width / 2, height: main.height / 25)
                Spacer()
            }
            RoundedRectangle(cornerRadius: 25)
                .fill(main.colors.activeWords)
                .frame(height: 2)
                .padding([.leading, .trailing])
        }
    }
    
    var location: some View {
        HStack {
            Image(systemName: "person")
                .resizable()
                .scaledToFit()
                .frame(width: 15)
            ZStack {
                if locationIsTyping == false {
                    Text("Add Location")
                        .foregroundColor(main.colors.inactiveWords)
                        .padding(.leading, 10)
                }
                TextField("", text: $newTask.dynamicTask.location)
                    .padding(.leading, 20)
                    .focused($locationFieldIsFocus)
                    .onSubmit {
                        locationIsTyping = true
                    }
                    .onChange(of: locationFieldIsFocus) { locate in
                        if locate == true {
                            locationIsTyping = true
                        }
                        if locate == false {
                            locationIsTyping = false
                        }
                    }
            }
            .frame(width: 150)
            Spacer()
        }
        .padding(.leading, 5)
    }
    
    var description: some View {
        Text("description")
    }
    
    var addButton: some View {
        HStack {
            Spacer()
            Button{
                toDoData.items.append(newTask.dynamicTask)
                top.accessAddMenu()
                print("New task added to List with ID : \(newTask.dynamicTask.id)")
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(main.colors.inProgressColor)
                        .frame(width: main.width / 6.5,height: main.height / 20)
                    HStack {
                        Text("ADD")
                            .bold()
                            .font(.subheadline)
                    }
                    .foregroundColor(Color.white)
                    .padding()
                }
                .padding()
            }
        }
    }
}

struct NewTaskView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
