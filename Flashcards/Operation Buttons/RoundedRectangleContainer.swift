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
            .frame(height: 150)
            .containerRelativeFrame(.horizontal)
            .background(.pink.gradient)
            .foregroundColor(.clear)
            .overlay(content)
            .clipShape(.rect(cornerRadius: 25))
            .padding(.top, -80)
            .padding(.bottom, -40)
            
    }
        
}
