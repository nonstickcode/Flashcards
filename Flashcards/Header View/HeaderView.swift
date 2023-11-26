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
            Spacer()
                .frame(width: 30, height: 30)
                .padding(.leading, 10)
            
            Text("Mathcards")
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity, alignment: .center) // Align text to the left

            Image(systemName: "gear")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .foregroundColor(.white)
                .padding(.trailing, 10) // Adjust the trailing padding
        }
        .padding() // Add padding to the HStack if needed
    }
}


#Preview {
    HeaderView()
}
