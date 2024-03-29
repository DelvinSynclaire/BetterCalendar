//
//  TopBarView.swift
//  BetterCalendar1.1
//
//  Created by Delvin Cockroft on 2/17/23.
//

import SwiftUI

struct TopBarView: View {
    @StateObject var top : TopBarData
    @StateObject var toDoData: ToDoData
    @StateObject var main: MainData
    
    var body: some View {
        ZStack {
            HStack {
                backButton
                Spacer()
                addButton
            }
            .padding([.leading, .trailing])
            .frame(width: main.width / 1.1, height: main.height / 18)
        }
        .frame(width: main.width, height: main.height / 18)
        .background(main.colors.tertiaryColor)
    }
    
    var backButton: some View {
        Button{
            top.backButton()
        } label: {
            Image(systemName: "chevron.left")
                .resizable()
                .scaledToFit()
                .frame(width: 12)
                .foregroundColor(Color.white)
        }
    }
    var addButton: some View {
        Button{
            toDoData.deleteBlankItems()
            toDoData.activateNewTaskView()
        } label: {
            Image(systemName: "plus")
                .resizable()
                .scaledToFit()
                .frame(width: 20)
                .foregroundColor(Color.white)
        }
    }
}

struct TopBarView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

