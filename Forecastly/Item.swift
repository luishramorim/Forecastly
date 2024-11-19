//
//  Item.swift
//  Forecastly
//
//  Created by Luis Amorim on 19/11/2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
