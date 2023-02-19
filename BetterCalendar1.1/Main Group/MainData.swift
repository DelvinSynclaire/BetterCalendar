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
}

struct DataForAnimation {
    var frameWidth: CGFloat
    var frameHeight: CGFloat
    var offsetX: CGFloat
    var offsetY: CGFloat
    var opacity: Double
}
