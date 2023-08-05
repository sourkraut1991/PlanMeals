//
//  PlanMealsApp.swift
//  PlanMeals
//
//  Created by Ed Kraus on 8/1/23.
//

import SwiftUI
import SwiftData
import WishKit

@main
struct PlanMealsApp: App {
    init() {
        WishKit.configure(with: "48F301E6-9B7D-46C5-90A4-401F19643817")
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Items.self, Item.self])
       
    }
}
