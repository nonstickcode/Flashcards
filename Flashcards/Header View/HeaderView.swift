//
//  HeaderView.swift
//  Flashcards
//
//  Created by Cody McRoy on 9/16/23.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        HStack {
            Text("Mathcards")
                .font(.largeTitle)
                .bold()
        }
    }
}

#Preview {
    HeaderView()
}
