//
//  TestFlashcardsView.swift
//  Flashcards
//
//  Created by Cody McRoy on 9/16/23.
//

import SwiftUI
import SwiftData


struct AnswerOverlayView: View {
    let text1: String
    let text2: String
    let color: Color
    let overlayWidth: CGFloat
    let overlayHeight: CGFloat
    
    init(text1: String, text2: String, color: Color, overlayWidth: CGFloat, overlayHeight: CGFloat) {
        self.text1 = text1
        self.text2 = text2
        self.color = color
        self.overlayWidth = overlayWidth
        self.overlayHeight = overlayHeight
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(color.opacity(0.98))
                .frame(width: overlayWidth, height: overlayHeight)
            VStack {
                Text(text1)
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .padding()
                
                Text(text2)
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                    .padding()
            }
        }
    }
}




struct TestFlashcardsView: View {
    
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
    
    @State var correctAnsweredFlashCards: Int = 0
    @State var incorrectAnsweredFlashCards: Int = 0
    
    @State private var rectangleWidth: CGFloat = 1
    @State private var rectangleHeight: CGFloat = 1
    
    
    
    
    
    var body: some View {
        GeometryReader { geometry in
            
            let isLandscape = geometry.size.width > 500 // landscape or larger like tablet
            let thisCardFontSize: CGFloat = isLandscape ? 60 : 50
            
            
            
            VStack {
                Spacer()
                
                if isLandscape {
                    
                    
                    VStack {
                        
                        
                        
                        HStack {
                            
                            
                            VStack {
                                ForEach(0..<5) { num in
                                    Button(action: {
                                        self.userAnswer += "\(num)"
                                    }) {
                                        Spacer()
                                        Rectangle()
                                            .frame(width: 70, height: 51)
                                            .foregroundColor(.clear)
                                            .background(.gray.gradient)
                                            .cornerRadius(10)
                                            .overlay(
                                                
                                                Text("\(num)")
                                                    .frame(width: 64, height: 45)
                                                    .background(Color.white.gradient)
                                                    .foregroundColor(.black)
                                                    .bold()
                                                    .cornerRadius(8)
                                            )
                                        Spacer()
                                    }
                                    .padding(0)
                                }
                                
                            }
                            
                            FlashNoteCard {
                                VStack {
                                    HStack {
                                        Spacer()
                                       
                                        HStack{
                                            Text("\(correctAnsweredFlashCards)")
                                                .foregroundColor(.green)
                                                .padding(.leading, 25)
                                            Text(" / ")
                                                .foregroundColor(.white)
                                            Text("\(incorrectAnsweredFlashCards)")
                                                .foregroundColor(.red)
                                                .padding(.trailing, 25)
                                        }
                                        .border(Color.gray, width: 2)
                                        Spacer()
                                    }
                                    
                                    
                                    
                                    Text("\(question) = ?")
                                        .font(.system(size: thisCardFontSize))
                                        .foregroundColor(.white)
                                        .bold()
                                    
                                    
                                    
                                    
                                    HStack {
                                        Spacer()
                                        TextField("Answer here", text: $userAnswer)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                            .frame(width: 150)
                                        
                                        
                                        Spacer()
                                            .frame(width: 20)
                                        
                                        Button(action: {
                                            self.userAnswer = ""
                                        }) {
                                            
                                            Image(systemName: "clear")
                                                .resizable()
                                                .frame(width: 32, height: 32)
                                                .foregroundColor(.red)
                                            
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                        
                                        Spacer()
                                    }
                                    .padding(.bottom, 25)
                                    
                                    
                                    
                                    Button(action: {
                                        checkAnswer()
                                    }) {
                                        Text("Check Answer")
                                            .frame(width: geometry.size.width * 0.6, height: 60)
                                            .background(Color.blue)
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                        
                                    }
                                    
                                    
                                }
                            }
                            .frame(width: rectangleWidth, height: rectangleHeight)
                            .overlay(
                                Group {
                                    if showCorrectAnswerOverlay {
                                        AnswerOverlayView(text1: "Correct!", text2: "Good Job", color: .green, overlayWidth: rectangleWidth, overlayHeight: rectangleHeight)
                                            .onAppear {
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                                    showCorrectAnswerOverlay = false
                                                }
                                            }
                                    } else if showIncorrectAnswerOverlay {
                                        AnswerOverlayView(text1: "Incorrect", text2: "Try Again", color: .red, overlayWidth: rectangleWidth, overlayHeight: rectangleHeight)
                                            .onAppear {
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                                    showIncorrectAnswerOverlay = false
                                                }
                                            }
                                    }
                                }
                            )
                            
                            
                            
                            VStack {
                                ForEach(5..<10) { num in
                                    Button(action: {
                                        self.userAnswer += "\(num)"
                                    }) {
                                        Spacer()
                                        Rectangle()
                                            .frame(width: 70, height: 51)
                                            .foregroundColor(.clear)
                                            .background(.gray.gradient)
                                            .cornerRadius(10)
                                            .overlay(
                                                
                                                Text("\(num)")
                                                    .frame(width: 64, height: 45)
                                                    .background(Color.white.gradient)
                                                    .foregroundColor(.black)
                                                    .bold()
                                                    .cornerRadius(8)
                                            )
                                        Spacer()
                                    }
                                    .padding(0)
                                }
                            }
                        }
                    }
                    .onAppear(){
                        rectangleWidth = isLandscape ? geometry.size.width * 0.75 : geometry.size.width * 0.95
                        rectangleHeight = isLandscape ? 300 : 300
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
                                    Button(action: {
                                        savePlayerScore()
                                        resetGame()
                                        showCustomNameEntryAlert = false
                                    }) {
                                        Text("OK")
                                            .frame(width: geometry.size.width * 0.4, height: 50)
                                    }
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
                    
                    
                } else {
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack {
                            Text("\(operation.rawValue)")
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
                                            .font(.system(size: thisCardFontSize))
                                            .foregroundColor(.white)
                                            .bold()
                                            .padding()
                                        
                                        TextField("Answer here", text: $userAnswer)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                            .keyboardType(.numberPad)
                                            .frame(width: 150)
                                            .padding()
                                            .focused($textFieldFocus)
                                        
                                        Button(action: {
                                            checkAnswer()
                                        }) {
                                            Text("Check Answer")
                                                .frame(width: geometry.size.width * 0.6, height: 60)
                                                .background(Color.blue)
                                                .foregroundColor(.white)
                                                .cornerRadius(10)
                                                .padding()
                                        }
                                        
                                        Spacer()
                                    }
                                }
                                .frame(width: rectangleWidth, height: rectangleHeight)
                                .overlay(
                                    Group {
                                        if showCorrectAnswerOverlay {
                                            AnswerOverlayView(text1: "Correct!", text2: "Good Job", color: .green, overlayWidth: rectangleWidth, overlayHeight: rectangleHeight)
                                                .onAppear {
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                                        showCorrectAnswerOverlay = false
                                                    }
                                                }
                                        } else if showIncorrectAnswerOverlay {
                                            AnswerOverlayView(text1: "Incorrect", text2: "Try Again", color: .red, overlayWidth: rectangleWidth, overlayHeight: rectangleHeight)
                                                .onAppear {
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                                        showIncorrectAnswerOverlay = false
                                                    }
                                                }
                                        }
                                    }
                                )
                                
                                Spacer()
                            }
                            
                        }
                        .onAppear {
                            textFieldFocus = true
                            
                            rectangleWidth = isLandscape ? geometry.size.width * 0.75 : geometry.size.width * 0.95
                            rectangleHeight = isLandscape ? 340 : 300
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
                                        Button(action: {
                                            savePlayerScore()
                                            resetGame()
                                            showCustomNameEntryAlert = false
                                        }) {
                                            Text("OK")
                                                .frame(width: geometry.size.width * 0.4, height: 50)
                                        }
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
                Spacer()
            }
            .onAppear(){
                generateQuestion()
                
                rectangleWidth = isLandscape ? geometry.size.width * 0.75 : geometry.size.width * 0.95
                rectangleHeight = isLandscape ? 300 : 300
            }
        }
    }
    
    
    private func generateQuestion() {
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
