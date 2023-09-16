//
//  FlashNoteCard.swift
//  Flashcards
//
//  Created by Cody McRoy on 9/16/23.
//

import SwiftUI

struct FlashNoteCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        Rectangle()
            .frame(height: 250)
            .background(.green.opacity(0.5).gradient)
            .foregroundColor(.clear)
            .overlay(content)
            .clipShape(.rect(cornerRadius: 25))
    }
        
}
