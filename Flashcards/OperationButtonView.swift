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
    var body: some View {
        NavigationLink(destination: FlashCardsView(operation: operation)) {
            RoundedRectangleContainer {
                VStack {
                    Image(systemName: operation.symbol)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)
                        .padding()
                    Text(operation.rawValue)
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                }
            }
        }
        .containerRelativeFrame(.horizontal)
    }
}
