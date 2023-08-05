//
//  ContentView.swift
//  PlanMeals
//
//  Created by Ed Kraus on 8/1/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext // For SwiftData
    @Query private var items: [Item] // Database Model
    
    // State variables to hold user inputs
    @State private var entre = ""                // New entre item's name
    @State private var selectedCategory = ""        // Selected category for filtering
    @State private var meal = ""             // New category to be added
    @State private var isPresentingFormSheet = false // Check if the add form sheet is presented
    @State private var note = ""
    
    private func addItem() {
        withAnimation {
            let newItem = Item(id: "", entre: entre, note: note, meal: meal)
            modelContext.insert(newItem)
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
    private func updateItem(_ item: Item) {
        // Edit the item data
        item.id = ""
        item.entre = entre
        item.meal = meal
        item.note = note
        
        do {
            // Save the context
            try modelContext.save()
        } catch {
            // Handle the error, e.g., print it or show an alert to the user.
            print("Error saving context: \(error)")
        }
    }
    
    // State variable to keep track of the selected tab
    @State private var selectedTab: Tab = .home
    
    // Tab enum representing the different tabs in the TabView
    enum Tab {
        case home
        case explore
        case wishes
    }
    
    fileprivate func FirstView() -> NavigationView<TupleView<(some View, Text)>> {
        return //Main View
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        VStack {
                            //View When clicking an item
                            Form {
                                Section {
                                    Text(item.meal)
                                } header: {
                                    Text("Mean Time")
                                }
                                Section {
                                    TextField(text: $note) {
                                        Text(item.note)
                                        
                                    }
                                } header: {
                                    Text("Notes")
                                }
                            }
                        }
                        .toolbar {
                            ToolbarItem {
                                Button(action: {
                                    updateItem(Item.init(id: "", entre: entre, note: note, meal: meal))
                                }) {
                                    Text("Update")
                                }
                            }
                        }
                    } label: {
                        //Main page List
                        Text(item.entre)
                        
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .sheet(isPresented: $isPresentingFormSheet) {
                // Show the half sheet form here
                VStack(spacing: 16) {
                    Text("Create a new meal")
                    TextField("New Entre", text: $entre) // Text field for entering new entre name
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                    
                    TextField("Enter Meal", text: $meal) // Text field for entering new category
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                    
                    TextField("Extra comments or thoughts?", text: $note) // Text field for entering new category
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                    
                    Button("Add") {
                        addItem()
                        entre = ""
                        meal = ""
                        note = ""
                        isPresentingFormSheet = false // Dismiss the form sheet
                        
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: 60, minHeight: 30)
                    .background(Capsule().fill(Color.blue))
                    //                    .disabled(newEntre.isEmpty || newCategory.isEmpty) // Disable the button if fields are empty
                }
                .padding()
                .presentationDetents([.fraction(0.30)]) // Set the height of the half sheet
            }
            //Toolbar for main page
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: {
                        isPresentingFormSheet = true // Set the flag to present the form sheet
                    }) {
                        Image(systemName: "plus") // Display a "+" icon
                    }
                }
            }
            Text("Select an item")
        }
    }
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            // First Tab - Add Entre
            FirstView()
                .tag(Tab.home) // Assign the "home" tag to this tab
            
            // Second Tab - WeeklyView
            WeeklyView()
                .tag(Tab.explore) // Assign the "explore" tag to this tab
            
            // Third Tab - WishListView
            WishListView()
                .tag(Tab.wishes) // Assign the "wishes" tag to this tab
        }
        .overlay(
            HStack(spacing: 0) {
                // Custom tab bar items using the tabBarItem function
                tabBarItem(tab: .home, imageName: "house") // Home tab with house icon
                tabBarItem(tab: .explore, imageName: "calendar") // Explore tab with calendar icon
                tabBarItem(tab: .wishes, imageName: "square.and.pencil.circle") // Wishes tab with pencil circle icon
            }
            .frame(height: 50) // Set the height of the custom tab bar
            .background(
                Capsule()
                    .fill(Color(.systemBackground)) // Use system background color for the tab bar
                    .shadow(radius: 4) // Add shadow to the tab bar
            )
            .padding(.horizontal, 16) // Add horizontal padding to the tab bar
            .padding(.bottom, 16) // Add bottom padding to the tab bar
            , alignment: .bottom // Align the custom tab bar to the bottom of the screen
        )
    }
    
    
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
