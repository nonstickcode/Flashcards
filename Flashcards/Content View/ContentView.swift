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
                                Button {
                                    showDataOverlay.toggle()
                                } label: {
                                    HStack {
                                        Text("Scoreboard")
                                        Image(systemName: "trophy")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(.white)
                                    }
                                    .frame(width: geometry.size.width * 0.5, height: 60)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .padding()
                                }
                            }
                            .padding(.top, 85)  // this keeps the scrollable content below the header at start
                            
                            
                            
                            
                            HStack {
                                Text("Practice Math Flashcards")
                                    .font(.headline)
                                    
                                
                            }
                            
                            
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(MathOperation.allCases, id: \.self) { operation in
                                        OperationButtonView(operation: operation, isPractice: true)
                                    }
                                }
                                .scrollTargetLayout()
                            }
                            .scrollTargetBehavior(.viewAligned)
                            .contentMargins(75, for: .scrollContent)
                            
                           

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

                            }
                            .scrollTargetBehavior(.viewAligned)
                            .contentMargins(75, for: .scrollContent)
                            

                            
                           
                            
                            
                        }
                    }
                    
                }
            }
            .navigationBarHidden(true)
            .navigationViewStyle(StackNavigationViewStyle())
            .overlay(
                Group {
                    if showDataOverlay {
                        
                        NavigationStack {
                            
                            List {
                                ForEach(sortedItems, id: \.id) { item in
                                    NavigationLink {
                                        VStack {
                                            Text("\(item.name)")
                                            Text("scored \(Int(item.score))%")
                                            Text("on \(item.category) test taken")
                                            Text("\(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
//                                                 Text("ID: \(item.id)")
                                        }
                                        
                                    } label: {
                                        Text("\(item.name) scored \(Int(item.score))%")
                                        
                                    }
                                }
                                .onDelete(perform: deleteItems)
                            }
                            .toolbar {
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    EditButton()
                                }
//                                ToolbarItem {
//                                    Button(action: addItem) {
//                                        Label("Add Item", systemImage: "plus")
//                                    }
//                                }
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




