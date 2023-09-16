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
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
