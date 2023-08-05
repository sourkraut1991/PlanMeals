//
//  Item.swift
//  PlanMeals
//
//  Created by Ed Kraus on 8/1/23.
//

import Foundation
import SwiftData

@Model
final class Item: Identifiable {
    var id: String
    var entre: String
    var note: String
    var meal: String
    
    init(id: String, entre: String, note: String, meal: String) {
        self.id = UUID().uuidString
        self.entre = entre
        self.note = note
        self.meal = meal
        
    }
    
}

