//
//  ContentView.swift
//  Flashcards
//
//  Created by Cody McRoy on 9/16/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    @State private var showDataOverlay: Bool = false
    
    var sortedItems: [Item] {
        items.sorted {
            if $0.score == $1.score {
                return $0.timestamp > $1.timestamp
            } else {
                return $0.score > $1.score
            }
        }
    }

    
    
    
    var body: some View {
        
        
        
        GeometryReader { geometry in
            
            NavigationView {
                
                ZStack {
                    
                    
                    HeaderView()
                        .frame(width: geometry.size.width, height: 60)
                        .background(Color.teal.opacity(0.8))
                        .foregroundColor(.white)
                        .zIndex(1)
                        .position(x: geometry.size.width / 2, y: 30)  // Position the header at the top
                    
                    
                    VStack {
                        ScrollView(.vertical, showsIndicators: false) {
                            HStack {
                                Text("Practice Math Flashcards")
                                    .font(.headline)
                                    
                                
                            }
                            .padding(.top, 85)  // this keeps the scrollable content below the header at start
                            
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(MathOperation.allCases, id: \.self) { operation in
                                        OperationButtonView(operation: operation, isPractice: true)
                                    }
                                }
                                .scrollTargetLayout()
                            }
                            .scrollTargetBehavior(.viewAligned)
                            .contentMargins(100, for: .scrollContent)
                            
                           

                            HStack {
                                Text("Test Math Flashcards")
                                    .font(.headline)
                                
                            }
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(MathOperation.allCases, id: \.self) { operation in
                                        OperationButtonView(operation: operation, isPractice: false)
                                    }
                                }
                                .scrollTargetLayout()
//
                            }
                            .scrollTargetBehavior(.viewAligned)
                            .contentMargins(100, for: .scrollContent)
                            
                                                        

                            
                            Button("Print items") {
                                print(items)
                            }
                            .frame(width: geometry.size.width * 0.5, height: 60) // Set dimensions as per your need
                            .background(Color.blue) // Change to your preferred color
                            .foregroundColor(.white)
                            .cornerRadius(10) // Change the radius for rounded corners
                            .padding()
                            
                            Button("Add item") {
                                addItem()
                            }
                            .frame(width: geometry.size.width * 0.5, height: 60) // Set dimensions as per your need
                            .background(Color.blue) // Change to your preferred color
                            .foregroundColor(.white)
                            .cornerRadius(10) // Change the radius for rounded corners
                            .padding()
                            
                            Button("Show Data") {
                                showDataOverlay.toggle()
                            }
                            .frame(width: 200, height: 60)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding()
                            
                            
                        }
                    }
                    
                }
            }
            .navigationBarHidden(true)
            .overlay(
                Group {
                    if showDataOverlay {
                        
                        NavigationSplitView {
                            
                            List {
                                ForEach(sortedItems, id: \.id) { item in
                                    NavigationLink {
                                        VStack {
                                            Text("Name: \(item.name)")
                                            Text("Score: \(item.score)")
                                            Text("Created: \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                                            Text("ID: \(item.id)")
                                        }
                                        
                                    } label: {
                                        Text("\(item.name) scored \(item.score)")
                                        
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
                            Button(action: {
                                showDataOverlay = false
                            }) {
                                Text("Close")
                                    .frame(width: 100, height: 40)
                            }
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .padding()
                        } detail: {
                            Text("Select an item")
                        }
                        .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 1)
                        .background(Color.white)
                        .cornerRadius(15)
                        .border(.black, width: 2)
                    }
                }
            )
            
            
            
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
                    let item = sortedItems[index]
                    if let originalIndex = items.firstIndex(where: { $0.id == item.id }) {
                        modelContext.delete(items[originalIndex])
                    }
                }
            }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}




