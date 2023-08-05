//
//  PlanMealsApp.swift
//  PlanMeals
//
//  Created by Ed Kraus on 8/1/23.
//

import SwiftUI
import SwiftData

@main
struct PlanMealsApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Item.self)
    }
}
