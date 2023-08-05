//
//  WeeklyView.swift
//  PlanMeals
//
//  Created by Ed Kraus on 8/5/23.
//

import SwiftUI
import SwiftData

struct WeeklyView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @Query private var menu: [Items]
    @State private var meals: [(String, String)] = []
    func shuffleMeals() {
        let days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        let restaurantNames = items.map { $0.entre }
        let shuffledNames = restaurantNames.shuffled()
        meals = Array(zip(days, shuffledNames))
    }
    @State private var entre = ""                // New entre item's name
    @State private var day = ""
    private func addItems() {
        withAnimation {
            let newMenu = Items(id: "", entre: entre, day: day)
            modelContext.insert(newMenu)
        }
    }
    let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    
    var body: some View {
        NavigationStack {
            VStack {
                
                
                List(meals, id: \.0) { (day, entree) in
                    VStack(alignment: .leading) {
                        Text(day)
                            .bold()
                            .font(.title2)
                        Text(entree)
                            .font(.caption)
                    }
                }
                .refreshable {
                    shuffleMeals()
                    print("shuffling...")
                }
            }
            
            .toolbar {
                ToolbarItemGroup {
                    Text("Pull down to Refresh")
                        .padding(.trailing, 20)
                    Button("Save") {
                       addItems()
                    }
                    
                    
                }
                
            }
        }
        .onAppear {
            
        }
    }
    }
    
    
    
    
    
    #Preview {
        WeeklyView()
    }
