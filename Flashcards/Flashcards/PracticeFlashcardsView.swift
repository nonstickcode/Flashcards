//
//  PracticeFlashcardsView.swift
//  Flashcards
//
//  Created by Cody McRoy on 9/19/23.
//

import SwiftUI
import SwiftData

struct PracticeFlashcardsView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    
    var operation: MathOperation
    @State var question: String = ""
    @State var correctAnswer: Int = 0
    @State var userAnswer: String = ""
    
    
    @State private var showAnswer: Bool = false
    @State private var flashcardsShown: Int = 0
    
    @State private var answerContainerWidth: CGFloat = 0
    
    
    var body: some View {
        GeometryReader { geometry in
            
            VStack {
                Text("\(operation.rawValue)")
                    .font(.title)
                    .bold()
                    .padding(.top, 10)
                Text("Flashcards shown this session \(flashcardsShown)")
                    .foregroundColor(.blue)
                
                
                HStack {
                    Spacer()
                    FlashNoteCard {
                        
                        VStack {
                            Spacer()
                            HStack {
                                
                                Spacer()
                                
                                Text("\(question) = ")
                                    .font(.system(size: 42))
                                    .foregroundColor(.white)
                                    .bold()
                                    .padding([.top, .bottom])
                                    .padding(.trailing, -5)
                                //                                    .border(Color.black, width: 2)
                                
                                Text(showAnswer ? "\(correctAnswer)" : "?")
                                    .font(.system(size: 42))
                                    .foregroundColor(.white)
                                    .bold()
                                    .padding([.top, .bottom])
                                    .padding(.leading, -5)
                                    .frame(width: answerContainerWidth)
                                //                                    .border(Color.black, width: 2)
                                
                                Spacer()
                                
                            }
                            
                            Button(action: {
                                if showAnswer {
                                    generateQuestion()
                                    showAnswer = false
                                } else {
                                    showAnswer.toggle()
                                    flashcardsShown += 1
                                }
                            }) {
                                Text(showAnswer ? "Next Problem" : "Show Answer")
                                    .frame(width: geometry.size.width * 0.6, height: 60)
                                    .background(showAnswer ? Color.green : Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .padding()
                            }
                            
                            Spacer()
                        }
                        
                    }
                    .frame(width: geometry.size.width * 0.8)
                    
                    Spacer()
                }
                
            }
            .onAppear {
                generateQuestion()
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
        
        answerContainerWidth = getWidthForAnswer(correctAnswer)
        
    }
    
    private func getWidthForAnswer(_ answer: Int) -> CGFloat {
        // Calculate the width based on the number of digits in the answer
        let answerString = "\(answer)"
        let font = UIFont.systemFont(ofSize: 42) // Use the appropriate font
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = (answerString as NSString).size(withAttributes: fontAttributes)
        
        return size.width
    }
    
    
}

