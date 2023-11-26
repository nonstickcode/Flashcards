//
//  HeaderView.swift
//  Flashcards
//
//  Created by Cody McRoy on 9/16/23.
//

import SwiftUI

struct HeaderView: View {
    @StateObject private var settingsViewModel = SettingsViewModel()

    var body: some View {
        HStack {
            Spacer()
                .frame(width: 30, height: 30)
                .padding(.leading, 10)

            Text("Mathcards")
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity, alignment: .center)

            NavigationLink(destination: SettingsView(settingsViewModel: settingsViewModel)) {
                Image(systemName: "gear")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
                    .padding(.trailing, 10)
            }
        }
        .padding()
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}

