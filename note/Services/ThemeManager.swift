//
//  ThemeManager.swift
//  note
//
//  Created by Kiro on 26/07/25.
//

import Foundation
import SwiftUI
import Combine

class ThemeManager: ObservableObject {
    @Published var isDarkMode: Bool = false
    
    private let fileManager = FileManager.default
    private let errorHandler = ErrorHandler()
    
    init() {
        loadThemePreference()
    }
    
    // MARK: - Theme Properties
    
    var backgroundColor: Color {
        isDarkMode ? Color(hex: "171717") : .white
    }
    
    var textColor: Color {
        isDarkMode ? .white : .black
    }
    
    var accentColor: Color {
        Color(red: 1.0, green: 0.8, blue: 0.6) // Pastel orange
    }
    
    var secondaryTextColor: Color {
        isDarkMode ? Color.white.opacity(0.7) : Color.black.opacity(0.6)
    }
    
    var cardBackgroundColor: Color {
        isDarkMode ? Color(hex: "1F1F1F") : Color.white
    }
    
    var sidebarBackgroundColor: Color {
        isDarkMode ? Color(hex: "141414") : Color(hex: "F8F9FA")
    }
    
    var dividerColor: Color {
        Color.gray.opacity(0.3) // Muted grayish divider as per requirements
    }
    
    var cardBorderColor: Color {
        isDarkMode ? Color.white.opacity(0.1) : Color.black.opacity(0.1)
    }
    
    var sidebarSelectedColor: Color {
        isDarkMode ? Color.white.opacity(0.1) : accentColor.opacity(0.1)
    }
    
    // MARK: - Theme Management
    
    func toggleTheme() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isDarkMode.toggle()
        }
        saveThemePreference()
    }
    
    func setDarkMode(_ enabled: Bool) {
        withAnimation(.easeInOut(duration: 0.3)) {
            isDarkMode = enabled
        }
        saveThemePreference()
    }
    
    // MARK: - Persistence
    
    func saveThemePreference() {
        let preference = ThemePreference(isDarkMode: isDarkMode, lastUpdated: Date())
        
        do {
            let data = try JSONEncoder.noteEncoder.encode(preference)
            try data.write(to: fileManager.themeSettingsFileURL)
        } catch {
            errorHandler.handle(error, context: "saving theme preference")
            
            // Attempt to create directory if it doesn't exist
            let directory = fileManager.themeSettingsFileURL.deletingLastPathComponent()
            if !fileManager.fileExists(atPath: directory.path) {
                do {
                    try fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
                    // Retry saving after creating directory
                    let retryData = try JSONEncoder.noteEncoder.encode(preference)
                    try retryData.write(to: fileManager.themeSettingsFileURL)
                } catch {
                    print("Failed to create theme settings directory or save preference: \(error)")
                }
            }
        }
    }
    
    func loadThemePreference() {
        let themeURL = fileManager.themeSettingsFileURL
        
        guard fileManager.fileExists(atPath: themeURL.path) else {
            // Default to light mode
            isDarkMode = false
            return
        }
        
        do {
            let data = try Data(contentsOf: themeURL)
            let preference = try JSONDecoder.noteDecoder.decode(ThemePreference.self, from: data)
            isDarkMode = preference.isDarkMode
        } catch {
            errorHandler.handle(error, context: "loading theme preference")
            // Fallback to light mode
            isDarkMode = false
        }
    }
}

// MARK: - Theme Preference Model

struct ThemePreference: Codable {
    var isDarkMode: Bool = false
    var lastUpdated: Date = Date()
}

