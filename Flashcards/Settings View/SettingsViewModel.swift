// SettingsViewModel.swift

import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var additionSubtractionDifficulty: Int {
        didSet {
            saveDifficultyLevels()
        }
    }
    
    @Published var multiplicationDivisionDifficulty: Int {
        didSet {
            saveDifficultyLevels()
        }
    }
    
    init() {
        // Check if values are already stored in UserDefaults, if not, set default values
        if let savedAdditionSubtractionDifficulty = UserDefaults.standard.value(forKey: "additionSubtractionDifficulty") as? Int {
            self.additionSubtractionDifficulty = savedAdditionSubtractionDifficulty
        } else {
            self.additionSubtractionDifficulty = 10 // Set default value to beginner
        }
        
        if let savedMultiplicationDivisionDifficulty = UserDefaults.standard.value(forKey: "multiplicationDivisionDifficulty") as? Int {
            self.multiplicationDivisionDifficulty = savedMultiplicationDivisionDifficulty
        } else {
            self.multiplicationDivisionDifficulty = 5 // Set default value to beginner
        }
    }
    
    func saveDifficultyLevels() {
        // Save difficulty levels to UserDefaults
        UserDefaults.standard.set(self.additionSubtractionDifficulty, forKey: "additionSubtractionDifficulty")
        UserDefaults.standard.set(self.multiplicationDivisionDifficulty, forKey: "multiplicationDivisionDifficulty")
        
        UserDefaults.standard.synchronize()
    }
}
