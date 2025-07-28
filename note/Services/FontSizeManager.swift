import SwiftUI
import Foundation

/// Manages user font size preferences and cycling functionality
class FontSizeManager: ObservableObject {
    @Published var currentBodyFontSize: CGFloat = 16
    @Published var currentTitleFontSize: CGFloat = 36
    
    private let fontSizes: [CGFloat] = [16, 18, 22, 24]
    private let storageKey = "FontSizePreference"
    
    init() {
        loadFontPreference()
    }
    
    // MARK: - Font Size Cycling
    
    /// Cycles through predefined font sizes (16px → 18px → 22px → 24px → 16px)
    func cycleFontSize() {
        guard let currentIndex = fontSizes.firstIndex(of: currentBodyFontSize) else {
            // If current size is not in the array, reset to first size
            currentBodyFontSize = fontSizes[0]
            saveFontPreference()
            return
        }
        
        let nextIndex = (currentIndex + 1) % fontSizes.count
        currentBodyFontSize = fontSizes[nextIndex]
        saveFontPreference()
    }
    
    // MARK: - Computed Font Properties
    
    var bodyFont: Font {
        return Font.dmSans(size: currentBodyFontSize)
    }
    
    var titleFont: Font {
        return Font.dmSansMedium(size: currentTitleFontSize)
    }
    
    var titleFontSemibold: Font {
        return Font.dmSansBold(size: currentTitleFontSize)
    }
    
    // MARK: - Persistence
    
    func saveFontPreference() {
        let preference = FontSizePreference(
            bodyFontSize: currentBodyFontSize,
            titleFontSize: currentTitleFontSize,
            lastUpdated: Date()
        )
        
        do {
            let data = try JSONEncoder().encode(preference)
            let url = getDocumentsDirectory().appendingPathComponent("font-settings.json")
            try data.write(to: url)
        } catch {
            print("Failed to save font preference: \(error)")
            // Fallback: Try to save to a backup location
            saveFontPreferenceBackup(preference)
        }
    }
    
    private func saveFontPreferenceBackup(_ preference: FontSizePreference) {
        do {
            let data = try JSONEncoder().encode(preference)
            let backupURL = getDocumentsDirectory().appendingPathComponent("font-settings-backup.json")
            try data.write(to: backupURL)
            print("Font preference saved to backup location")
        } catch {
            print("Failed to save font preference backup: \(error)")
            // Ultimate fallback: Reset to defaults
            currentBodyFontSize = 16
            currentTitleFontSize = 36
        }
    }
    
    func loadFontPreference() {
        do {
            let url = getDocumentsDirectory().appendingPathComponent("font-settings.json")
            let data = try Data(contentsOf: url)
            let preference = try JSONDecoder().decode(FontSizePreference.self, from: data)
            
            // Validate that the loaded font size is in our supported sizes
            if fontSizes.contains(preference.bodyFontSize) {
                currentBodyFontSize = preference.bodyFontSize
            } else {
                currentBodyFontSize = 16 // Default fallback
            }
            
            currentTitleFontSize = preference.titleFontSize
        } catch {
            // Try to load from backup
            if loadFontPreferenceBackup() {
                return
            }
            
            // File doesn't exist or is corrupted, use defaults
            print("Failed to load font preference, using defaults: \(error)")
            currentBodyFontSize = 16
            currentTitleFontSize = 36
            saveFontPreference() // Create the file with defaults
        }
    }
    
    private func loadFontPreferenceBackup() -> Bool {
        do {
            let backupURL = getDocumentsDirectory().appendingPathComponent("font-settings-backup.json")
            let data = try Data(contentsOf: backupURL)
            let preference = try JSONDecoder().decode(FontSizePreference.self, from: data)
            
            if fontSizes.contains(preference.bodyFontSize) {
                currentBodyFontSize = preference.bodyFontSize
            } else {
                currentBodyFontSize = 16
            }
            
            currentTitleFontSize = preference.titleFontSize
            print("Font preference loaded from backup")
            
            // Try to restore main file
            saveFontPreference()
            return true
        } catch {
            return false
        }
    }
    
    // MARK: - Helper Methods
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0].appendingPathComponent("Soul")
        
        // Create directory if it doesn't exist
        try? FileManager.default.createDirectory(at: documentsDirectory, withIntermediateDirectories: true)
        
        return documentsDirectory
    }
}

// MARK: - Data Model

struct FontSizePreference: Codable {
    var bodyFontSize: CGFloat = 16
    var titleFontSize: CGFloat = 36
    var lastUpdated: Date = Date()
}

