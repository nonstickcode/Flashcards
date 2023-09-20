//
//  RoundedRectangleContainer.swift
//  Flashcards
//
//  Created by Cody McRoy on 9/16/23.
//

import SwiftUI

struct RoundedRectangleContainer<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        Rectangle()
            .frame(height: 200)
            .containerRelativeFrame(.horizontal)
            .background(.green.gradient)
            .foregroundColor(.clear)
            .overlay(content)
            .clipShape(.rect(cornerRadius: 25))
            .padding(.top, -50)
            .padding(.bottom, -40)
            
    }
        
}
