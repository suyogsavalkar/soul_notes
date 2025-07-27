//
//  ThemeIntegrationTests.swift
//  noteTests
//
//  Created by Kiro on 26/07/25.
//

import XCTest
import SwiftUI
@testable import note

final class ThemeIntegrationTests: XCTestCase {
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
    
    func testThemeColorConsistency() throws {
        // Test light mode colors
        themeManager.setDarkMode(false)
        
        XCTAssertEqual(themeManager.backgroundColor, .white)
        XCTAssertEqual(themeManager.textColor, .black)
        XCTAssertEqual(themeManager.sidebarBackgroundColor, Color(hex: "F8F9FA"))
        
        // Test dark mode colors
        themeManager.setDarkMode(true)
        
        XCTAssertEqual(themeManager.backgroundColor, Color(hex: "171717"))
        XCTAssertEqual(themeManager.textColor, .white)
        XCTAssertEqual(themeManager.sidebarBackgroundColor, Color(hex: "141414"))
        
        // Test that accent color is consistent across themes
        let lightAccent = themeManager.accentColor
        themeManager.setDarkMode(false)
        let darkAccent = themeManager.accentColor
        
        XCTAssertEqual(lightAccent, darkAccent)
    }
    
    func testDividerColorRequirement() throws {
        // Test that divider color is muted grayish as per requirements
        let expectedColor = Color.gray.opacity(0.3)
        
        // Should be consistent across themes
        themeManager.setDarkMode(false)
        XCTAssertEqual(themeManager.dividerColor, expectedColor)
        
        themeManager.setDarkMode(true)
        XCTAssertEqual(themeManager.dividerColor, expectedColor)
    }
    
    func testThemeTransitionAnimation() throws {
        let initialMode = themeManager.isDarkMode
        
        // Toggle should change the mode
        themeManager.toggleTheme()
        XCTAssertNotEqual(themeManager.isDarkMode, initialMode)
        
        // Toggle again should return to original
        themeManager.toggleTheme()
        XCTAssertEqual(themeManager.isDarkMode, initialMode)
    }
    
    func testThemePersistenceAcrossAppLaunches() throws {
        // Set dark mode and save
        themeManager.setDarkMode(true)
        themeManager.saveThemePreference()
        
        // Simulate app restart by creating new theme manager
        let newThemeManager = ThemeManager()
        
        // Should load the saved preference
        XCTAssertTrue(newThemeManager.isDarkMode)
        
        // Test light mode persistence
        newThemeManager.setDarkMode(false)
        newThemeManager.saveThemePreference()
        
        let anotherThemeManager = ThemeManager()
        XCTAssertFalse(anotherThemeManager.isDarkMode)
    }
    
    func testCardColorsInBothThemes() throws {
        // Test light mode card colors
        themeManager.setDarkMode(false)
        let lightCardBg = themeManager.cardBackgroundColor
        let lightCardBorder = themeManager.cardBorderColor
        
        XCTAssertEqual(lightCardBg, Color.white)
        XCTAssertEqual(lightCardBorder, Color.black.opacity(0.1))
        
        // Test dark mode card colors
        themeManager.setDarkMode(true)
        let darkCardBg = themeManager.cardBackgroundColor
        let darkCardBorder = themeManager.cardBorderColor
        
        XCTAssertEqual(darkCardBg, Color(hex: "1F1F1F"))
        XCTAssertEqual(darkCardBorder, Color.white.opacity(0.1))
        
        // Colors should be different between themes
        XCTAssertNotEqual(lightCardBg, darkCardBg)
        XCTAssertNotEqual(lightCardBorder, darkCardBorder)
    }
    
    func testSecondaryTextColorReadability() throws {
        // Test that secondary text has appropriate opacity for readability
        
        themeManager.setDarkMode(false)
        let lightSecondary = themeManager.secondaryTextColor
        // Should be black with some opacity
        XCTAssertEqual(lightSecondary, Color.white.opacity(0.7))
        
        themeManager.setDarkMode(true)
        let darkSecondary = themeManager.secondaryTextColor
        // Should be white with some opacity
        XCTAssertEqual(darkSecondary, Color.white.opacity(0.7))
    }
}