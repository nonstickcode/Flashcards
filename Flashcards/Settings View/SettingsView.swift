// SettingsView.swift

import SwiftUI

struct SettingsView: View {
    @ObservedObject var settingsViewModel: SettingsViewModel

    init(settingsViewModel: SettingsViewModel) {
        self.settingsViewModel = settingsViewModel
    }

    var body: some View {
        List {
            Section(header: Text("Addition and Subtraction Difficulty")) {
                Picker("Difficulty Level", selection: $settingsViewModel.additionSubtractionDifficulty) {
                    Text("Beginner").tag(10)
                    Text("Intermediate").tag(20)
                    Text("Advanced").tag(100)
                }
                .pickerStyle(SegmentedPickerStyle())
            }

            Section(header: Text("Multiplication and Division Difficulty")) {
                Picker("Difficulty Level", selection: $settingsViewModel.multiplicationDivisionDifficulty) {
                    Text("Beginner").tag(5)
                    Text("Advanced").tag(12)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: EmptyView())
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Settings")
                    .font(.title)
                    .bold()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(settingsViewModel: SettingsViewModel())
    }
}
