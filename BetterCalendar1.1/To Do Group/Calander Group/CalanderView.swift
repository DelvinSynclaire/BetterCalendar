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

    let dayLabels = [
        DayLabel(label: "M"),DayLabel(label: "T"),DayLabel(label: "W"),
        DayLabel(label: "T"),DayLabel(label: "F"),DayLabel(label: "S"),
        DayLabel(label: "S"),
    ]
    let columns = [
        GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),
        GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
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
        LazyVGrid(columns: columns) {
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
        LazyVGrid(columns: columns) {
            ForEach(dayLabels) { label in
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
    @Published var timeComponents = Calendar.current.dateComponents([.hour, .minute, .day, .month, .era], from: Date())
    @Published var today = Date.now
    
    @Published var customDates: [CustomDate] = []
    
    @Published var collor = Color(#colorLiteral(red: 0.1248284355, green: 0.3755585849, blue: 0.584214747, alpha: 1))
}

struct CalanderView_Previews: PreviewProvider {
    static var previews: some View {
        CalanderView()
    }
}


extension CalanderData {
    func getDaySimple(for month: Date){
        let cal = Calendar.current
        let monthRange = cal.range(of: .day, in: .month, for: month)!
        let comps = cal.dateComponents([.year, .month], from: month)
        var date = cal.date(from: comps)!
        
        var dates: [Date] = []
        for _ in monthRange {
            dates.append(date)
            date = cal.date(byAdding: .day, value: 1, to: date)!
        }
        
        
        for stuff in dates {
            let monthFormat = DateFormatter()
            monthFormat.dateFormat = "MMMM"
            let month = monthFormat.string(from: stuff)
            
            let monthNumFormat = DateFormatter()
            monthNumFormat.dateFormat = "MM"
            let monthNum = monthNumFormat.string(from: stuff)
            
            let dayNumFormat = DateFormatter()
            dayNumFormat.dateFormat = "d"
            let dayNum = dayNumFormat.string(from: stuff)
            
            let dayFormat = DateFormatter()
            dayFormat.dateFormat = "E"
            let day = dayFormat.string(from: stuff)
            
            customDates.append(CustomDate(monthName: month, monthNumber: monthNum, dayName: day, dayNumber: dayNum))
        }
        
        for _ in 0...findDistanceFromMonday(givenDay: customDates[0].dayName) {
            customDates.insert(CustomDate(monthName: "", monthNumber: "", dayName: "", dayNumber: ""), at: 0)
        }
    }

    func findDistanceFromMonday(givenDay: String) -> Int {
        let week = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]
        var done = false
        var distance = 0
        
        for i in week {
            if givenDay != i && done == false {
                distance += 1
            } else {
                done = true
            }
        }
        
        return distance
    }
}


struct CustomDate: Identifiable,Hashable {
    var id = UUID()
    var monthName: String
    var monthNumber: String
    var dayName: String
    var dayNumber: String
}

struct DayLabel: Identifiable {
    var id = UUID()
    var label: String
}
