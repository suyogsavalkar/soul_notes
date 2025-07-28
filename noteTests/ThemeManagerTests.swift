//
//  ThemeManagerTests.swift
//  noteTests
//
//  Created by Kiro on 26/07/25.
//

import XCTest
import SwiftUI
@testable import note

final class ThemeManagerTests: XCTestCase {
    var themeManager: ThemeManager!
    
    override func setUpWithError() throws {
        themeManager = ThemeManager()
    }
    
    override func tearDownWithError() throws {
        themeManager = nil
        
        // Clean up test files
        let fileManager = FileManager.default
        let themeURL = fileManager.themeSettingsFileURL
        if fileManager.fileExists(atPath: themeURL.path) {
            try? fileManager.removeItem(at: themeURL)
        }
    }
    
    func testInitialThemeState() throws {
        // Theme should start in light mode by default
        XCTAssertFalse(themeManager.isDarkMode)
    }
    
    func testToggleTheme() throws {
        let initialState = themeManager.isDarkMode
        
        themeManager.toggleTheme()
        
        XCTAssertNotEqual(themeManager.isDarkMode, initialState)
    }
    
    func testSetDarkMode() throws {
        themeManager.setDarkMode(true)
        XCTAssertTrue(themeManager.isDarkMode)
        
        themeManager.setDarkMode(false)
        XCTAssertFalse(themeManager.isDarkMode)
    }
    
    func testThemeColors() throws {
        // Test light mode colors
        themeManager.setDarkMode(false)
        XCTAssertEqual(themeManager.backgroundColor, .white)
        XCTAssertEqual(themeManager.textColor, .black)
        
        // Test dark mode colors
        themeManager.setDarkMode(true)
        XCTAssertEqual(themeManager.backgroundColor, Color(hex: "171717"))
        XCTAssertEqual(themeManager.textColor, .white)
        
        // Accent color should be consistent across themes
        let accentColor = Color(red: 1.0, green: 0.8, blue: 0.6)
        XCTAssertEqual(themeManager.accentColor, accentColor)
    }
    
    func testThemePersistence() throws {
        // Set dark mode and save
        themeManager.setDarkMode(true)
        themeManager.saveThemePreference()
        
        // Create new theme manager instance
        let newThemeManager = ThemeManager()
        
        // Should load the saved preference
        XCTAssertTrue(newThemeManager.isDarkMode)
    }
    
    func testThemePreferenceModel() throws {
        let preference = ThemePreference(isDarkMode: true, lastUpdated: Date())
        
        // Test encoding
        let encoder = JSONEncoder.noteEncoder
        let data = try encoder.encode(preference)
        XCTAssertNotNil(data)
        
        // Test decoding
        let decoder = JSONDecoder.noteDecoder
        let decodedPreference = try decoder.decode(ThemePreference.self, from: data)
        
        XCTAssertEqual(preference.isDarkMode, decodedPreference.isDarkMode)
        XCTAssertEqual(preference.lastUpdated.timeIntervalSince1970, 
                      decodedPreference.lastUpdated.timeIntervalSince1970, 
                      accuracy: 1.0)
    }
    
    func testErrorHandlingForCorruptedFile() throws {
        let fileManager = FileManager.default
        let themeURL = fileManager.themeSettingsFileURL
        
        // Write invalid JSON to theme file
        let invalidData = "invalid json".data(using: .utf8)!
        try invalidData.write(to: themeURL)
        
        // Create new theme manager - should fallback to light mode
        let newThemeManager = ThemeManager()
        XCTAssertFalse(newThemeManager.isDarkMode)
    }
    
    func testDividerColorConsistency() throws {
        // Divider should be muted grayish as per requirements
        let expectedDividerColor = Color.gray.opacity(0.3)
        XCTAssertEqual(themeManager.dividerColor, expectedDividerColor)
        
        // Should be consistent across themes
        themeManager.setDarkMode(true)
        XCTAssertEqual(themeManager.dividerColor, expectedDividerColor)
        
        themeManager.setDarkMode(false)
        XCTAssertEqual(themeManager.dividerColor, expectedDividerColor)
    }
}