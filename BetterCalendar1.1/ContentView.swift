//
//  ContentView.swift
//  BetterCalendar1.1
//
//  Created by Delvin Cockroft on 2/15/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var  toDoData = ToDoData()
    var body: some View {
        MainView(toDoData: toDoData)
    }
}
struct MainView: View {
    @StateObject var toDoData: ToDoData
    var body: some View {
        if toDoData.items.isEmpty{
            noItems
        } else {
            items
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

class ToDoData: ObservableObject {
    @Published var items : [Item] = [
        Item(id: 0, name: "do this", urgency: "High", isActive: false),
        Item(id: 1, name: "do this", urgency: "High", isActive: false),
        Item(id: 2, name: "do this", urgency: "High", isActive: false)
    ]
    
    struct Item: Identifiable {
        var id: Int
        var name: String
        var urgency: String
        var isActive: Bool
    }
    
    func toDoItem(item: Item) -> some View{
        HStack{
            if item.isActive{
                RoundedRectangle(cornerRadius: 7)
                    .frame(width: 30, height: 30)
                    .overlay(
                        Image(systemName: "checkmark")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color.white)
                            .frame(width: 15)
                    )
            } else {
                RoundedRectangle(cornerRadius: 7)
                    .stroke(lineWidth: 2)
                    .frame(width: 30, height: 30)
            }
            Text("\(item.name)")
            Text("\(item.urgency)")
            Spacer()
        }
        .padding([.leading, .trailing])
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
