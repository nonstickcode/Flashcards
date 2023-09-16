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
    
    init(timestamp: Date) {
        self.timestamp = timestamp
        self.id = UUID().uuidString
        self.name = "NOT SURE"
        self.score = 0
    }
}
