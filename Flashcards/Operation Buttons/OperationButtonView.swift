//
//  OperationButtonView.swift
//  Flashcards
//
//  Created by Cody McRoy on 9/16/23.
//

import SwiftUI

enum MathOperation: String, CaseIterable {
    case addition = "Addition"
    case subtraction = "Subtraction"
    case multiplication = "Multiplication"
    case division = "Division"
    
    var symbol: String {
        switch self {
        case .addition: return "plus.square"
        case .subtraction: return "minus.square"
        case .multiplication: return "multiply.square"
        case .division: return "divide.square"
        }
    }
}


struct OperationButtonView: View {
    let operation: MathOperation
    
    let isPractice: Bool
    
    
    var body: some View {
        NavigationLink(destination: isPractice ? AnyView(PracticeFlashcardsView(operation: operation)) : AnyView(TestFlashcardsView(operation: operation))) {
            RoundedRectangleContainer {
                VStack {
                    Image(systemName: operation.symbol)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)
                        
                    Text(isPractice ? "Practice" : "Test")
                        .foregroundColor(.white)
                        .font(.subheadline)
                        
                    Text(isPractice ? "\(operation.rawValue)" : "\(operation.rawValue)")
                        .foregroundColor(.white)
                        .font(.subheadline)
                        
                }
            }
        }
        .containerRelativeFrame(.horizontal)
    }
}
