//
//  ContentView.swift
//  BetterCalendar1.1
//
//  Created by Delvin Cockroft on 2/15/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var  toDoData = ToDoData()
    @ObservedObject var main = MainData()
    var body: some View {
        GeometryReader { geo in
            ZStack {
                main.colors.mainBackground
                    .ignoresSafeArea()
                MainView(toDoData: toDoData, main: main)
                    .onAppear {
                        main.width = geo.size.width
                        main.height = geo.size.height
                }
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
