//
//  CalanderData.swift
//  BetterCalendar1.1
//
//  Created by Delvin Cockroft on 2/28/23.
//

import Foundation
import SwiftUI

// MARK: extension to the CalanderData class. This houses the functions
extension CalanderData {
    // get all the days in teh month to be used ina  custom grid
    func getDaySimple(for month: Date){
        /// establish the current  used calendar from the user's phone
        let cal = Calendar.current
        ///establish the date components of everyday in the current month using the  user's phone data and given month
        let monthRange = cal.range(of: .day, in: .month, for: month)!
        let comps = cal.dateComponents([.year, .month], from: month)
        var date = cal.date(from: comps)!
        
        /// empty array to house the day components of each day int he month then loop the those days and add them to the 'dates' array
        var dates: [Date] = []
        for _ in monthRange {
            dates.append(date)
            date = cal.date(byAdding: .day, value: 1, to: date)!
        }
        
        /// take those day components and loop through them
        for stuff in dates {
            /// take the month data and convert to string word
            let monthFormat = DateFormatter()
            monthFormat.dateFormat = "MMMM"
            let month = monthFormat.string(from: stuff)
            
            /// take the month data and convert to string number
            let monthNumFormat = DateFormatter()
            monthNumFormat.dateFormat = "MM"
            let monthNum = monthNumFormat.string(from: stuff)
            
            /// take the day data and convert to string word
            let dayNumFormat = DateFormatter()
            dayNumFormat.dateFormat = "d"
            let dayNum = dayNumFormat.string(from: stuff)
            
            /// take the day data and convert to string number
            let dayFormat = DateFormatter()
            dayFormat.dateFormat = "E"
            let day = dayFormat.string(from: stuff)
            
            /// add them to an empty array that houses the data for VIEW DISPLAY purposes
            customDates.append(CustomDate(monthName: month, monthNumber: monthNum, dayName: day, dayNumber: dayNum))
        }
        
        /// add empty dates in the VIEW DISPLAY array to act as a buffer and properly align the days in the grid
        for _ in 0...findDistanceFromMonday(givenDay: customDates[0].dayName) {
            customDates.insert(CustomDate(monthName: "", monthNumber: "", dayName: "", dayNumber: ""), at: 0)
        }
    }

    //get the distance from Monday to the first day in the month
    func findDistanceFromMonday(givenDay: String) -> Int {
        /// define the days in the week
        let week = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]
        /// define whether or not we have found the distance
        var done = false
        /// varibale to represent the distance
        var distance = 0
        
        /// loop through days of the week and add to distance until we have found the distance and then stop adding to distance
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
