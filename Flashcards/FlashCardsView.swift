//
//  FlashCardsView.swift
//  Flashcards
//
//  Created by Cody McRoy on 9/16/23.
//

import SwiftUI

struct FlashCardsView: View {
    
    
    var operation: MathOperation
    @State var question: String = ""
    @State var correctAnswer: Int = 0
    @State var userAnswer: String = ""
    
    // Alert related state variables
    @State private var showCorrectAnswerOverlay: Bool = false
    @State private var correctAnswerMessage: String = ""
    
    @State private var showIncorrectAnswerOverlay: Bool = false
    @State private var incorrectAnswerMessage: String = ""
    
    @State var correctAnsweredFlashCards: Int = 0
    @State var incorrectAnsweredFlashCards: Int = 0
    
    @State private var showCustomNameEntryAlert: Bool = false
    
    @State private var playerName: String = ""
    
    @FocusState private var textFieldFocus: Bool
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("\(operation.rawValue) Flashcards")
                    .font(.title)
                    .bold()
                    .padding(.top, 10)
                Text("Correct: \(correctAnsweredFlashCards)")
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                Text("Incorrect: \(incorrectAnsweredFlashCards)")
                    .foregroundColor(.red)
                
                
                HStack {
                    Spacer()
                    FlashNoteCard {
                        VStack {
                            Text("\(question) = ?")
                                .font(.system(size: 42))
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
                                        .foregroundColor(Color.green)
                                    
                                    Text(correctAnswerMessage)
                                        .font(.largeTitle)
                                        .bold()
                                        .foregroundColor(.white)
                                }
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
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
                                        .foregroundColor(Color.red)
                                    
                                    Text(incorrectAnswerMessage)
                                        .font(.largeTitle)
                                        .bold()
                                        .foregroundColor(.white)
                                }
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
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
                            Text("You've answered 5 questions correctly. Enter your name:")
                                .foregroundColor(.white)
                                .padding(10)
                            TextField("Name", text: $playerName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal, 20)
                                .padding(10)
                                .keyboardType(.alphabet)
                            Button("OK") {
                                
                                // add high score update function call------------------------------
                                
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
            
            if correctAnsweredFlashCards == 5 {
                showCustomNameEntryAlert = true
                correctAnsweredFlashCards = 0
                incorrectAnsweredFlashCards = 0
            } else {
                correctAnswerMessage = "Correct! Great job!"
                showCorrectAnswerOverlay = true
            }
            
            generateQuestion()
            userAnswer = ""  // Clears the input
        } else {
            incorrectAnsweredFlashCards += 1
            
            incorrectAnswerMessage = "Incorrect! Try again."
            showIncorrectAnswerOverlay = true
            
            userAnswer = ""  // Clears the input
        }
    }
}
