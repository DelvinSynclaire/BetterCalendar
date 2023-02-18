//
//  TopBarData.swift
//  BetterCalendar1.1
//
//  Created by Delvin Cockroft on 2/17/23.
//

import Foundation
import SwiftUI

// MAIN: Here is class of changing data points for the Top Bar and the functions associated
class TopBarData: ObservableObject {
    @Published var accessToAddMenu = false
    
    /// This function is to access the 'Add Menu' card : This function does not take any arguments : This function toggles a bool and then prints a statement
    func accessAddMenu() {
        accessToAddMenu.toggle()
        print("Access to Menu is toggled: More Info in 'TopBarData' file")
    }
    func backButton() {
        print("Returning to previous page")
    }
}
