//
//  NewTaskView.swift
//  BetterCalendar1.1
//
//  Created by Delvin Cockroft on 2/17/23.
//

import SwiftUI

struct NewTaskView: View {
    @ObservedObject var top: TopBarData
    @ObservedObject var toDoData: ToDoData
    @ObservedObject var newTask: NewTaskData
    @ObservedObject var main: MainData
    @StateObject var calData = CalanderData()

    @FocusState private var titleFieldIsFocus: Bool
    @FocusState private var locationFieldIsFocus: Bool
    @FocusState private var descriptionFieldIsFocus: Bool

    @State private var titleIsTyping = false
    @State private var locationIsTyping = false
    @State private var descriptionIsTyping = false
    
    @State var givenMonth = ""
    
    @Binding var groupID: Int
    
    var body: some View {
        ZStack {
            /// here is the black seperator for 'new task' view
            Color.black
                .opacity(newTask.backgroundSeperator.opacity)
                .ignoresSafeArea()
            /// here is the card that host the information for adding a new task
           newTaskCard
                .foregroundColor(main.colors.activeWords)
                .padding([.leading, .trailing])
        }
        .frame(height: main.height)
        .onAppear{
            titleIsTyping = true
            titleFieldIsFocus = true
            newTask.backgroundSeperatorAnimation(isActive: true)
            newTask.backgroundCardAnimation(isActive: true)
        }
    }
    
    var newTaskCard: some View {
        VStack {
            Spacer()
            ZStack {
               background
                VStack {
                    calendar
                    CreateNewTask
                    title
                    Spacer()
                    time
                    location
                    description
                    Spacer()
                    addButton
                }
                .padding()
            }
            .frame(height: main.height / 2)
        }
      //  .offset(y: newTask.backgroundCard.offsetY)
        .position(x: main.width / 2.15, y: main.height / 6)
    }
    
    var background: some View {
        RoundedRectangle(cornerRadius: 25)
            .fill(main.colors.secondaryBackground)
    }
    
    var calendar: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(main.colors.secondaryBackground)
            VStack {
               calendarTitle
               customCalanderHeader
               customCalendar
            }
            .onAppear {
                calData.getDaySimple(for: .now)
            }
        }
        .frame(height: main.height / 3)
    }
    
    var calendarTitle: some View {
        HStack {
            Text("\(givenMonth)")
                .bold()
                .offset(x: 10)
                .font(.title)
                .foregroundColor(main.colors.activeWords)
            Spacer()
        }
    }
    
    var customCalanderHeader: some View {
        LazyVGrid(columns: calData.columns) {
            ForEach(calData.dayLabels) { label in
                VStack {
                    Text("\(label.label)")
                }
                .foregroundColor(main.colors.activeWords)
                .frame(width: 30, height: 30)
            }
        }
    }
    
    var customCalendar: some View {
        LazyVGrid(columns: calData.columns) {
            ForEach(calData.customDates, id: \.self) { day in
                let dayNum = Int(day.dayNumber)
                ZStack {
                    Text("\(day.dayNumber)")
                        .foregroundColor(Color.white)
                }
                .foregroundColor(calData.timeComponents.day! > dayNum ?? 1 ? main.colors.inactiveWords : main.colors.activeWords)
                .frame(height: 30)
                .background(
                    ZStack {
                        let someDate = Date.now
                        
                        if someDate.formatted(.dateTime.day()) == "\(day.dayNumber)"{
                            RoundedRectangle(cornerRadius: 15)
                                .fill(calData.collor)
                                .frame(width: 30, height: 30)
                                .onAppear {
                                    calData.currentDay.dayNumber = someDate.formatted(.dateTime.day())
                                    calData.currentDay.monthNumber = someDate.formatted(.dateTime.month(.defaultDigits))
                                }
                        }
                    }
                )
                .onAppear {
                    givenMonth = day.monthName
                }
                .onTapGesture {
                    calData.currentDay.monthNumber = day.monthNumber
                    calData.currentDay.dayNumber = day.dayNumber
                    
                    newTask.dynamicTask.dateTime.day = Int(day.dayNumber) ?? 0
                    newTask.dynamicTask.dateTime.month = Int(day.monthNumber) ?? 0
                }
            }
        }
    }
    
    var CreateNewTask: some View {
        HStack {
            Text("Create new task ")
                .font(.title2)
                .bold()
            Spacer()
            Button {
                newTask.backgroundSeperatorAnimation(isActive: false)
                newTask.backgroundCardAnimation(isActive: false)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    toDoData.activateNewTaskView()
                    newTask.resetDynamicTaskItem()
                }
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
                    if titleIsTyping == false && newTask.dynamicTask.name.isEmpty == true {
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
    
    var time: some View {
        HStack {
            
            Image(systemName: "clock")
                .resizable()
                .scaledToFit()
                .frame(width: 15)
            Text("\(calData.currentDay.monthNumber)/\(calData.currentDay.dayNumber)")
            ZStack {
                HStack {
                    Text("Add Time")
                        .foregroundColor(main.colors.inactiveWords)
                    Spacer()
                }
                .padding(.leading)
                .onTapGesture {
                    print("Time page is now opening")
                }
            }
            .frame(width: main.width / 2, height: 40)
            Spacer()
        }
        .padding(.leading, 5)
    }
    
    var location: some View {
        HStack {
            Image(systemName: "mappin.and.ellipse")
                .resizable()
                .scaledToFit()
                .frame(width: 15)
            ZStack {
                if locationIsTyping == false && newTask.dynamicTask.location.isEmpty == true {
                    HStack {
                        Text("Add Location")
                            .foregroundColor(main.colors.inactiveWords)
                        Spacer()
                    }
                    .padding(.leading)
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
            .frame(width: main.width / 2, height: 40)
            Spacer()
        }
        .padding(.leading, 5)
    }
    
    var description: some View {
            HStack {
                Image(systemName: "doc")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15)
                ZStack {
                    if descriptionIsTyping == false && newTask.dynamicTask.description.isEmpty == true{
                        HStack {
                            Text("Add Description")
                                .foregroundColor(main.colors.inactiveWords)
                            Spacer()
                        }
                        .padding(.leading)
                    }
                    TextField("", text: $newTask.dynamicTask.description)
                        .padding(.leading, 20)
                        .focused($descriptionFieldIsFocus)
                        .onSubmit {
                            descriptionIsTyping = true
                        }
                        .onChange(of: descriptionFieldIsFocus) { locate in
                            if locate == true {
                                descriptionIsTyping = true
                            }
                            if locate == false {
                                descriptionIsTyping = false
                            }
                        }
                }
                .frame(width: main.width / 2, height: 40)
                Spacer()
            }
            .padding(.leading, 5)
    }
    
    var addButton: some View {
        HStack {
            Spacer()
            Button{
                if newTask.dynamicTask.name.isEmpty {
                    print("You need a title to add this task to your list of tasks")
                    toDoData.activateNewTaskView()
                } else {
                    // toDoData.addTaskToGroup(groupID: groupID, givenTask: newTask.dynamicTask)
                    toDoData.activateNewTaskView()
                    toDoData.addTaskToDefaultTasks(givenTask: newTask.dynamicTask)
                }
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
