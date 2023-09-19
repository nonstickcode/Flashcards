//
//  FlashCardsView.swift
//  Flashcards
//
//  Created by Cody McRoy on 9/16/23.
//

import SwiftUI
import SwiftData

struct FlashCardsView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    
    var operation: MathOperation
    @State var question: String = ""
    @State var correctAnswer: Int = 0
    @State var userAnswer: String = ""
    
    // Alert related state variables
    @State private var showCorrectAnswerOverlay: Bool = false
    @State private var showIncorrectAnswerOverlay: Bool = false
    
    @State private var showCustomNameEntryAlert: Bool = false
    
    @FocusState private var textFieldFocus: Bool
    
    @State private var playerName: String = ""
    @State private var score: Double = 0
    
    @State var correctAnsweredFlashCards: Int = 0  // score of player in round
    @State var incorrectAnsweredFlashCards: Int = 0 // score of player in round
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("\(operation.rawValue) Flashcards")
                    .font(.title)
                    .bold()
                    .padding(.top, 10)
                Text("Correct: \(correctAnsweredFlashCards)")
                    .foregroundColor(.green)
                Text("Incorrect: \(incorrectAnsweredFlashCards)")
                    .foregroundColor(.red)
                
                
                HStack {
                    Spacer()
                    FlashNoteCard {
                        VStack {
                            Text("\(question) = ?")
                                .font(.system(size: 42))
                                .foregroundColor(.white)
                                .bold()
                                .padding()
                            
                            TextField("Answer here", text: $userAnswer)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                                .frame(width: 150)
                                .padding(.horizontal)
                                .focused($textFieldFocus)
                            
                            Button("Check Answer") {
                                checkAnswer()
                            }
                            .frame(width: geometry.size.width * 0.6, height: 60)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding()
                            
                            Spacer()
                        }
                    }
                    .frame(width: geometry.size.width * 0.8)
                    .overlay(
                        Group {
                            
                            // CORRECT OVERLAY -------------------
                            
                            if showCorrectAnswerOverlay {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 25)
                                        .frame(width: geometry.size.width * 0.8, height: 250)
                                        .foregroundColor(Color.green.opacity(0.98))
                                    VStack {
                                        Text("Correct!")
                                            .font(.largeTitle)
                                            .bold()
                                            .foregroundColor(.white)
                                            .padding()
                                        
                                        Text("Great Job!")
                                            .font(.title)
                                            .bold()
                                            .foregroundColor(.white)
                                            .padding()
                                    }
                                }
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                        showCorrectAnswerOverlay = false
                                    }
                                }
                            }
                            
                            // -------------------------------------
                            
                            // INCORRECT OVERLAY -------------------
                            
                            if showIncorrectAnswerOverlay {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 25)
                                        .frame(width: geometry.size.width * 0.8, height: 250)
                                        .foregroundColor(Color.red.opacity(0.98))
                                    VStack {
                                        Text("Incorrect.")
                                            .font(.largeTitle)
                                            .bold()
                                            .foregroundColor(.white)
                                            .padding()
                                        
                                        Text("Try Again.")
                                            .font(.title)
                                            .bold()
                                            .foregroundColor(.white)
                                            .padding()
                                    }
                                }
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                        showIncorrectAnswerOverlay = false
                                    }
                                }
                            }
                            
                            // -------------------------------------
                            
                            
                        }
                    )
                    Spacer()
                }
                
            }
            .onAppear {
                generateQuestion()
                textFieldFocus = true
            }
            .overlay(
                Group {
                    if showCustomNameEntryAlert {
                        VStack {
                            Text("Congratulations!")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding(10)
                            Text("You've answered 5 questions correctly.")
                                .foregroundColor(.white)
                                .padding(5)
                            Text("Your score: \(score)")
                                .foregroundColor(.white)
                                .padding(5)
                            Text("Enter your name below:")
                                .foregroundColor(.white)
                                .padding(5)
                            
                            TextField("Name", text: $playerName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal, 20)
                                .padding(10)
                                .keyboardType(.alphabet)
                            Button("OK") {
                                // Your existing logic here, like saving the high score, goes here
                                   savePlayerScore()
                                   
                                   // Reset the game
                                   resetGame()
                                   
                                   showCustomNameEntryAlert = false
                                
                            }
                            .frame(width: geometry.size.width * 0.4, height: 50)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 20)
                            .bold()
                            .padding(10)
                            
                        }
                        .frame(width: geometry.size.width * 0.85, height: 375)
                        .background(Color.blue.gradient)
                        .cornerRadius(10)
                        .shadow(radius: 20)
                        .onAppear {
                            calculateScore()
                        }
                        
                        Spacer()
                    }
                    
                }
            )
        }
    }
    
    
    func generateQuestion() {
        var num1: Int
        var num2: Int
        
        switch operation {
        case .addition:
            num1 = Int.random(in: 1...10)
            num2 = Int.random(in: 1...10)
            question = "\(num1) + \(num2)"
            correctAnswer = num1 + num2
        case .subtraction:
            num1 = Int.random(in: 1...10)
            num2 = Int.random(in: 1...10)
            if num2 > num1 {
                swap(&num1, &num2)
            }
            question = "\(num1) - \(num2)"
            correctAnswer = num1 - num2
        case .multiplication:
            num1 = Int.random(in: 1...10)
            num2 = Int.random(in: 1...10)
            question = "\(num1) × \(num2)"
            correctAnswer = num1 * num2
        case .division:
            num2 = Int.random(in: 1...10)
            let multiplier = Int.random(in: 1...10)
            num1 = num2 * multiplier
            question = "\(num1) / \(num2)"
            correctAnswer = num1 / num2
        }
    }
    
    
    func checkAnswer() {
        if let userIntAnswer = Int(userAnswer), userIntAnswer == correctAnswer {
            correctAnsweredFlashCards += 1

            calculateScore()  // update score

            if correctAnsweredFlashCards == 5 {
                showCustomNameEntryAlert = true
            } else {
                showCorrectAnswerOverlay = true
            }
            generateQuestion()
            userAnswer = ""  // Clears the input
        } else {
            incorrectAnsweredFlashCards += 1
            
            calculateScore()  // update score
            
            showIncorrectAnswerOverlay = true
            userAnswer = ""  // Clears the input
        }
    }

    
    private func calculateScore() {
        let totalQuestions = correctAnsweredFlashCards + incorrectAnsweredFlashCards
        
        if totalQuestions == 0 {
            score = 0
            return
        }
        
        let correctPercentage = Double(correctAnsweredFlashCards) / Double(totalQuestions)
        let incorrectPercentage = Double(incorrectAnsweredFlashCards) / Double(totalQuestions)
        
        score = (correctPercentage * 100) - (incorrectPercentage * 50)
        
        // Ensure the score is within 0 and 100
        score = max(0, min(score, 100))
    }
    
    
    func savePlayerScore() {
        let newItem = Item(timestamp: Date())
        
        // Populate fields
        if playerName.isEmpty {
            newItem.name = "Unknown"
        } else {
            newItem.name = playerName
        }
        newItem.score = score
        
        // Insert into data store
        modelContext.insert(newItem)
    }

    
    func resetGame() {
        correctAnsweredFlashCards = 0
        incorrectAnsweredFlashCards = 0
        score = 0
        playerName = ""
        generateQuestion()
        userAnswer = ""
    }
    
    
}
