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
    @State private var showAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    
    @State var correctAnsweredFlashCards: Int = 0
    @State var incorrectAnsweredFlashCards: Int = 0
    
    @State private var showCustomNameEntryAlert: Bool = false

    @State private var playerName: String = ""
    
    
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
                            
                            Button("Check Answer") {
                                checkAnswer()
                            }
                            .frame(width: geometry.size.width * 0.6, height: 60) // Set dimensions as per your need
                            .background(Color.blue) // Change to your preferred color
                            .foregroundColor(.white)
                            .cornerRadius(10) // Change the radius for rounded corners
                            .padding()
                            
                            Spacer()
                            
                        }
                        
                    }
                    .frame(width: geometry.size.width * 0.8)
                    
                    Spacer()
                    
                }
                
                Spacer()
                
                
                
            }
            .onAppear {
                generateQuestion()
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
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
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(radius: 20)
                        
                        Spacer()
                    }
                }
            )

            
        }
        
    }
    
    
    func generateQuestion() {
        let num1 = Int.random(in: 1...10)
        let num2 = Int.random(in: 1...10)
        
        switch operation {
        case .addition:
            question = "\(num1) + \(num2)"
            correctAnswer = num1 + num2
        case .subtraction:
            question = "\(num1) - \(num2)"
            correctAnswer = num1 - num2
        case .multiplication:
            question = "\(num1) × \(num2)"
            correctAnswer = num1 * num2
        case .division:
            question = "\(num1) / \(num2)"
            correctAnswer = num1 / num2
        }
    }
    
    
    
    func checkAnswer() {
        if let userIntAnswer = Int(userAnswer), userIntAnswer == correctAnswer {
            correctAnsweredFlashCards += 1
            
            if correctAnsweredFlashCards == 5 {
                showCustomNameEntryAlert = true
            } else {
                alertTitle = "Correct!"
                alertMessage = "Good job! Moving to the next question."
                showAlert = true
            }
            generateQuestion()
            userAnswer = ""  // Clears the input
        } else {
            incorrectAnsweredFlashCards += 1
            
            alertTitle = "Incorrect!"
            alertMessage = "Try again."
            showAlert = true
            
            
            
            userAnswer = ""  // Clears the input
        }
    }


    
}
