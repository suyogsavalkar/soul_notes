// //
// //  FontSizeManager.swift
// //  note
// //
// //  Created by Kiro on 26/07/25.
// //

// import SwiftUI
// import Foundation

// /// Manages user font size preferences and cycling functionality
// class FontSizeManager: ObservableObject {
//     @Published var currentBodyFontSize: CGFloat = 16
    
//     private let fontSizes: [CGFloat] = [16, 18, 22, 24]
//     private let storageKey = "FontSizePreference"
    
//     init() {
//         loadFontPreference()
//     }
    
//     /// Cycles through predefined font sizes (16px → 18px → 22px → 24px → 16px)
//     func cycleFontSize() {
//         guard let currentIndex = fontSizes.firstIndex(of: currentBodyFontSize) else {
//             // If current size is not in the array, reset to first size
//             currentBodyFontSize = fontSizes[0]
//             saveFontPreference()
//             return
//         }
        
//         let nextIndex = (currentIndex + 1) % fontSizes.count
//         currentBodyFontSize = fontSizes[nextIndex]
//         saveFontPreference()
//     }
    
//     /// Saves font preference to local storage
//     func saveFontPreference() {
//         let preference = FontSizePreference(
//             bodyFontSize: currentBodyFontSize,
//             titleFontSize: 32, // Title size remains constant
//             lastUpdated: Date()
//         )
        
//         do {
//             let data = try JSONEncoder().encode(preference)
//             let url = getStorageURL()
//             try data.write(to: url)
//         } catch {
//             print("Failed to save font preference: \(error)")
//         }
//     }
    
//     /// Loads font preference from local storage
//     func loadFontPreference() {
//         do {
//             let url = getStorageURL()
//             let data = try Data(contentsOf: url)
//             let preference = try JSONDecoder().decode(FontSizePreference.self, from: data)
//             currentBodyFontSize = preference.bodyFontSize
//         } catch {
//             // Use default font size if loading fails
//             currentBodyFontSize = 16
//             print("Failed to load font preference, using default: \(error)")
//         }
//     }
    
//     /// Gets the storage URL for font preferences
//     private func getStorageURL() -> URL {
//         let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//         let notesAppPath = documentsPath.appendingPathComponent("NotesApp")
        
//         // Create directory if it doesn't exist
//         try? FileManager.default.createDirectory(at: notesAppPath, withIntermediateDirectories: true)
        
//         return notesAppPath.appendingPathComponent("font-settings.json")
//     }
    
//     /// Returns the current body font for use in views
//     var currentBodyFont: Font {
//         return Font.dmSans(size: currentBodyFontSize)
//     }
    
//     /// Returns the title font (always 32px)
//     var titleFont: Font {
//         return Font.dmSansMedium(size: 32)
//     }
// }

// /// Data model for font size preferences
// struct FontSizePreference: Codable {
//     var bodyFontSize: CGFloat = 16
//     var titleFontSize: CGFloat = 32
//     var lastUpdated: Date = Date()
// }//
// //  FontSizeManager.swift
// //  note
// //
// //  Created by Kiro on 26/07/25.
// //

// import SwiftUI
// import Combine

// class FontSizeManager: ObservableObject {
//     @Published var currentBodyFontSize: CGFloat = 16
//     @Published var currentTitleFontSize: CGFloat = 32
    
//     private let fontSizes: [CGFloat] = [16, 18, 22, 24]
//     private let storageKey = "FontSizePreference"
    
//     init() {
//         loadFontPreference()
//     }
    
//     // MARK: - Font Size Cycling
    
//     func cycleFontSize() {
//         guard let currentIndex = fontSizes.firstIndex(of: currentBodyFontSize) else {
//             // If current size is not in the array, reset to first size
//             currentBodyFontSize = fontSizes[0]
//             saveFontPreference()
//             return
//         }
        
//         let nextIndex = (currentIndex + 1) % fontSizes.count
//         currentBodyFontSize = fontSizes[nextIndex]
//         saveFontPreference()
//     }
    
//     // MARK: - Computed Font Properties
    
//     var bodyFont: Font {
//         return Font.dmSans(size: currentBodyFontSize)
//     }
    
//     var titleFont: Font {
//         return Font.dmSansMedium(size: currentTitleFontSize)
//     }
    
//     // MARK: - Persistence
    
//     func saveFontPreference() {
//         let preference = FontSizePreference(
//             bodyFontSize: currentBodyFontSize,
//             titleFontSize: currentTitleFontSize,
//             lastUpdated: Date()
//         )
        
//         do {
//             let data = try JSONEncoder().encode(preference)
//             let url = getDocumentsDirectory().appendingPathComponent("font-settings.json")
//             try data.write(to: url)
//         } catch {
//             print("Failed to save font preference: \(error)")
//             // Fallback: Try to save to a backup location
//             saveFontPreferenceBackup(preference)
//         }
//     }
    
//     private func saveFontPreferenceBackup(_ preference: FontSizePreference) {
//         do {
//             let data = try JSONEncoder().encode(preference)
//             let backupURL = getDocumentsDirectory().appendingPathComponent("font-settings-backup.json")
//             try data.write(to: backupURL)
//             print("Font preference saved to backup location")
//         } catch {
//             print("Failed to save font preference backup: \(error)")
//             // Ultimate fallback: Reset to defaults
//             currentBodyFontSize = 16
//             currentTitleFontSize = 32
//         }
//     }
    
//     func loadFontPreference() {
//         do {
//             let url = getDocumentsDirectory().appendingPathComponent("font-settings.json")
//             let data = try Data(contentsOf: url)
//             let preference = try JSONDecoder().decode(FontSizePreference.self, from: data)
            
//             // Validate that the loaded font size is in our supported sizes
//             if fontSizes.contains(preference.bodyFontSize) {
//                 currentBodyFontSize = preference.bodyFontSize
//             } else {
//                 currentBodyFontSize = 16 // Default fallback
//             }
            
//             currentTitleFontSize = preference.titleFontSize
//         } catch {
//             // Try to load from backup
//             if loadFontPreferenceBackup() {
//                 return
//             }
            
//             // File doesn't exist or is corrupted, use defaults
//             print("Failed to load font preference, using defaults: \(error)")
//             currentBodyFontSize = 16
//             currentTitleFontSize = 32
//             saveFontPreference() // Create the file with defaults
//         }
//     }
    
//     private func loadFontPreferenceBackup() -> Bool {
//         do {
//             let backupURL = getDocumentsDirectory().appendingPathComponent("font-settings-backup.json")
//             let data = try Data(contentsOf: backupURL)
//             let preference = try JSONDecoder().decode(FontSizePreference.self, from: data)
            
//             if fontSizes.contains(preference.bodyFontSize) {
//                 currentBodyFontSize = preference.bodyFontSize
//             } else {
//                 currentBodyFontSize = 16
//             }
            
//             currentTitleFontSize = preference.titleFontSize
//             print("Font preference loaded from backup")
            
//             // Try to restore main file
//             saveFontPreference()
//             return true
//         } catch {
//             return false
//         }
//     }
    
//     // MARK: - Helper Methods
    
//     private func getDocumentsDirectory() -> URL {
//         let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//         let documentsDirectory = paths[0].appendingPathComponent("NotesApp")
        
//         // Create directory if it doesn't exist
//         try? FileManager.default.createDirectory(at: documentsDirectory, withIntermediateDirectories: true)
        
//         return documentsDirectory
//     }
// }

// // MARK: - Data Model

// struct FontSizePreference: Codable {
//     var bodyFontSize: CGFloat = 16
//     var titleFontSize: CGFloat = 32
//     var lastUpdated: Date = Date()
// }

//
//  FontSizeManager.swift
//  note
//
//  Created by Kiro on 26/07/25.
//

import SwiftUI
import Foundation

/// Manages user font size preferences and cycling functionality
class FontSizeManager: ObservableObject {
    @Published var currentBodyFontSize: CGFloat = 16
    @Published var currentTitleFontSize: CGFloat = 32
    
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
            currentTitleFontSize = 32
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
            currentTitleFontSize = 32
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
        let documentsDirectory = paths[0].appendingPathComponent("NotesApp")
        
        // Create directory if it doesn't exist
        try? FileManager.default.createDirectory(at: documentsDirectory, withIntermediateDirectories: true)
        
        return documentsDirectory
    }
}

// MARK: - Data Model

struct FontSizePreference: Codable {
    var bodyFontSize: CGFloat = 16
    var titleFontSize: CGFloat = 32
    var lastUpdated: Date = Date()
}

// MARK: - Font Extensions

extension Font {
    static func dmSans(size: CGFloat) -> Font {
        return .system(size: size, design: .default)
    }
    
    static func dmSansMedium(size: CGFloat) -> Font {
        return .system(size: size, weight: .medium, design: .default)
    }
}