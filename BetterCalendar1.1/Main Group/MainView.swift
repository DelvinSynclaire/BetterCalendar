//
//  MainView.swift
//  BetterCalendar1.1
//
//  Created by Delvin Cockroft on 2/17/23.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var top = TopBarData()
    @StateObject var toDoData: ToDoData
    @StateObject var main: MainData

    var body: some View {
        VStack {
            TopBarView(top: top, toDoData: toDoData, main: main)
            ToDoView(top: top, toDoData: toDoData, main: main)
            Spacer()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
