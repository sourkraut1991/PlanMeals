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
    
    var body: some View {
        //Main View
        
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        VStack {
                            //View When clicking an item
                            Form {
                                Text(item.meal)
                                Text(item.note)
                            }
                        }
                    } label: {
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
                    
                    TextField("New Note", text: $note) // Text field for entering new category
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                    
                    Button("Add") {
                       addItem()
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
        item.entre = "Hello"
        
        do {
            // Save the context
            try modelContext.save()
        } catch {
            // Handle the error, e.g., print it or show an alert to the user.
            print("Error saving context: \(error)")
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
