//
//  OGContentView.swift
//  Flashcards
//
//  Created by Cody McRoy on 9/16/23.
//

import SwiftUI
import SwiftData




struct OGContentView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    
    
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Name: \(item.name)")
                        Text("Score: \(item.score)")
                        Text("Created: \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                        Text("ID: \(item.id)")
                        
                    } label: {
                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                        
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }

    }
    
    
    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
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
    
    
    
}





#Preview {
    OGContentView()
}


