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
                                Text("Math Flashcards")
                                    .foregroundColor(.black)
                                    .font(.headline)
                                Spacer()
                            }
                            .padding(.top, 85)  // this keeps the scrollable content below the header at start
                            .padding(.leading, 20)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(MathOperation.allCases, id: \.self) { operation in
                                        OperationButtonView(operation: operation)
                                    }
                                }
                                .scrollTargetLayout()
                            }
                            .scrollTargetBehavior(.viewAligned)
                            .contentMargins(20, for: .scrollContent)
                            
                            
                            HStack {
                                Text("Other Stuff")
                                    .foregroundColor(.black)
                                    .font(.headline)
                                Spacer()
                            }
                            .padding(.top, 85)  // this keeps the scrollable content below the header at start
                            .padding(.leading, 20)
                            
                            
                            
                            
                            
                            
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(MathOperation.allCases, id: \.self) { operation in
                                        OperationButtonView(operation: operation)
                                    }
                                }
                                .scrollTargetLayout()
                            }
                            .scrollTargetBehavior(.viewAligned)
                            .contentMargins(20, for: .scrollContent)
                            
                            
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
                        VStack {
                            List {
                                ForEach(items) { item in
                                    Text("Name: \(item.name)")
                                    Text("Score: \(item.score)")
                                    Text("Created: \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                                    Text("ID: \(item.id)")
                                    Rectangle()
                                }
                                
                            }
                            Button("Close") {
                                showDataOverlay = false
                            }
                            .frame(width: 100, height: 40)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .padding()
                        }
                        .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.9)
                        .background(Color.white)
                        .cornerRadius(15)
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
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}




