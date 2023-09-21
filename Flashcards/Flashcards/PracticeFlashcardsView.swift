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
    
    
    @State private var arrowOffset: CGFloat = 0
    
    
    var body: some View {
        GeometryReader { geometry in
            
            let isLandscape = geometry.size.width > geometry.size.height
            let thisCardFontSize: CGFloat = isLandscape ? 60 : 50
            
            VStack {
                Spacer()
                if isLandscape {
                    Text("Flashcard count: \(flashcardsShown)")
                        .foregroundColor(.blue)
                        
                } else {
                    Text("\(operation.rawValue)")
                        .font(.title)
                        .bold()
                        .padding(.top, 10)
                    Text("Flashcard count: \(flashcardsShown)")
                        .foregroundColor(.blue)
                }
                HStack {
                    Spacer()
                    FlashNoteCard {
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Text("\(question) = ")
                                    .font(.system(size: thisCardFontSize))
                                    .foregroundColor(.white)
                                    .bold()
                                    .padding([.top, .bottom], isLandscape ? 20 : 10)
                                    .padding(.trailing, -5)
                                    
                                
                                Text(showAnswer ? "\(correctAnswer)" : "?")
                                    .font(.system(size: thisCardFontSize))
                                    .foregroundColor(.white)
                                    .bold()
                                    .padding([.top, .bottom], isLandscape ? 20 : 10)
                                    .padding(.leading, -5)
                                    .frame(width: answerContainerWidth)
                                
                                Spacer()
                            }
                            .padding(.bottom)
                            
                            Button(action: {
                                if showAnswer {
                                    generateQuestion(withFontSize: thisCardFontSize)
                                    showAnswer = false
                                } else {
                                    showAnswer.toggle()
                                    flashcardsShown += 1
                                }
                            }) {
                                HStack {
                                    if showAnswer {
                                        Text("NEXT")
                                            .frame(height: 60)
                                            .foregroundColor(.white)
                                            .bold()
                                        
                                        Image(systemName: "arrow.forward")
                                            .foregroundColor(.white)
                                            .bold()
                                            .offset(x: arrowOffset)
                                            .onAppear {
                                                withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                                                    arrowOffset = 10
                                                }
                                            }
                                            .onDisappear {
                                                arrowOffset = 0
                                            }
                                        
                                    } else {
                                        Text("Show Answer")
                                            .frame(height: 60)
                                            .foregroundColor(.white)
                                    }
                                }
                                .frame(width: geometry.size.width * 0.6)
                                .background(showAnswer ? Color.green : Color.blue)
                                .cornerRadius(10)
                                .padding()
                            }
                            
                            
                            Spacer()
                        }
                        
                        
                    }
                    .frame(width: geometry.size.width * 0.95, height: geometry.size.height * (isLandscape ? 0.9 : 0.5))
                    
                    Spacer()
                }
                Spacer()
                
            }
            .onAppear {
                generateQuestion(withFontSize: thisCardFontSize)
            }
        }
    }
    
    
    private func generateQuestion(withFontSize thisCardFontSize: CGFloat) {
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
        
        answerContainerWidth = getWidthForAnswer(correctAnswer, thisCardFontSize: thisCardFontSize)
        
        
    }
    
    private func getWidthForAnswer(_ answer: Int, thisCardFontSize: CGFloat) -> CGFloat {
        // Calculate the width based on the number of digits in the answer
        let answerString = "\(answer)"
        let font = UIFont.systemFont(ofSize: thisCardFontSize)
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = (answerString as NSString).size(withAttributes: fontAttributes)
        
        return size.width
    }
    
    
}

