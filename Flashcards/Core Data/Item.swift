//
//  Item.swift
//  Flashcards
//
//  Created by Cody McRoy on 9/16/23.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    var id: String
    var name: String
    var score: Double
    var category: String
    
    init(timestamp: Date) {
        self.timestamp = timestamp
        self.id = UUID().uuidString
        self.name = "NOT SURE"
        self.score = 0
        self.category = "unknown"
    }
}
