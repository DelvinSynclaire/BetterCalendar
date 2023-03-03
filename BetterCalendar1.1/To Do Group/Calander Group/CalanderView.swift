//
//  CalanderView.swift
//  BetterCalendar1.1
//
//  Created by Delvin Cockroft on 2/27/23.
//

import SwiftUI

struct CalanderView: View {
    @StateObject var calData = CalanderData()
    @StateObject var main = MainData()
    
    @State var givenMonth = ""
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(main.colors.secondaryBackground)
                    .padding([.leading, .trailing])
                VStack {
                    calendarTitle
                    customCalanderHeader
                    customCalandar
                }
                .padding([.leading, .trailing], 50)
            }
            .frame(width: main.width, height: main.height / 2.3)
            .onAppear {
                main.width = geo.size.width
                main.height = geo.size.height
            }
        }
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
    
    var customCalandar: some View {
        LazyVGrid(columns: calData.columns) {
            ForEach(calData.customDates, id: \.self) { day in
                let dayNum = Int(day.dayNumber)
                VStack {
                    Text("\(day.dayNumber)")
                        .bold()
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
                        }
                    }
                )
                .onAppear {
                    givenMonth = day.monthName                    
                }
            }
        }
        .onAppear {
            calData.getDaySimple(for: .now)
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
}

class CalanderData: ObservableObject {
    //observed variables for the calendar
    @Published var timeComponents = Calendar.current.dateComponents([.hour, .minute, .day, .month, .era], from: Date())
    @Published var today = Date.now
    
    @Published var customDates: [CustomDate] = []
    
    @Published var collor = Color(#colorLiteral(red: 0.1248284355, green: 0.3755585849, blue: 0.584214747, alpha: 1))
    
    @Published var currentDay = CustomDate(monthName: "", monthNumber: "", dayName: "", dayNumber: "")
    
    //label for the days of the week
    let dayLabels = [
        DayLabel(label: "M"),DayLabel(label: "T"),DayLabel(label: "W"),
        DayLabel(label: "T"),DayLabel(label: "F"),DayLabel(label: "S"),
        DayLabel(label: "S"),
    ]
    
    // defined columns for the gri that the calendar is laid out on
    let columns = [
        GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),
        GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),
        GridItem(.flexible()),
    ]
}

// preview for the view
struct CalanderView_Previews: PreviewProvider {
    static var previews: some View {
        CalanderView()
    }
}
