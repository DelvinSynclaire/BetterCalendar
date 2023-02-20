//
//  MainData.swift
//  BetterCalendar1.1
//
//  Created by Delvin Cockroft on 2/17/23.
//

import Foundation
import SwiftUI

class MainData: ObservableObject {
    @Published var width: CGFloat = 0
    @Published var height: CGFloat = 0
    
    /// All colors used in application
    @Published var colors = Colors(
        mainBackground: Color(#colorLiteral(red: 0.123674877, green: 0.1285197735, blue: 0.1338065565, alpha: 1)),secondaryBackground: Color(#colorLiteral(red: 0.1533831656, green: 0.162846595, blue: 0.1679299176, alpha: 1)),activeWords: Color(#colorLiteral(red: 0.8732266426, green: 0.8730550408, blue: 0.8804423213, alpha: 1)),inactiveWords: Color(#colorLiteral(red: 0.2903959155, green: 0.2901795805, blue: 0.2993755341, alpha: 1)), titleWords: Color(#colorLiteral(red: 0.8812856078, green: 0.864086926, blue: 0.9987894893, alpha: 1))
        , inProgressColor: Color(#colorLiteral(red: 0.5645379172, green: 0.6322651004, blue: 0.9355137944, alpha: 1)), completedColor: Color(#colorLiteral(red: 0.293399632, green: 0.5097660422, blue: 0.9355137944, alpha: 1)), onHoldColor: Color(#colorLiteral(red: 0.9355137944, green: 0.6701716762, blue: 0.4694428014, alpha: 1))
    )
}

struct Colors {
    /// background Colors
    let mainBackground: Color
    let secondaryBackground: Color

    /// colors for words
    let activeWords: Color
    let inactiveWords: Color
    let titleWords: Color
    
    /// Colors for the state of a task
    let inProgressColor: Color
    let completedColor: Color
    let onHoldColor: Color

}

struct DataForAnimation {
    var frameWidth: CGFloat
    var frameHeight: CGFloat
    var offsetX: CGFloat
    var offsetY: CGFloat
    var opacity: Double
}
