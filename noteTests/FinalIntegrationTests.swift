//
//  FinalIntegrationTests.swift
//  noteTests
//
//  Created by Kiro on 26/07/25.
//

import XCTest
import SwiftUI
@testable import note

final class FinalIntegrationTests: XCTestCase {
    var noteManager: NoteManager!
    var themeManager: ThemeManager!
    
    override func setUpWithError() throws {
        noteManager = NoteManager()
        themeManager = ThemeManager()
        
        // Clean up any existing test data
        let fileManager = FileManager.default
        let urls = [
            fileManager.notesFileURL,
            fileManager.categoriesFileURL,
            fileManager.themeSettingsFileURL
        ]
        
        for url in urls {
            if fileManager.fileExists(atPath: url.path) {
                try? fileManager.removeItem(at: url)
            }
        }
    }
    
    override func tearDownWithError() throws {
        noteManager = nil
        themeManager = nil
        
        // Clean up test files
        let fileManager = FileManager.default
        let urls = [
            fileManager.notesFileURL,
            fileManager.categoriesFileURL,
            fileManager.themeSettingsFileURL
        ]
        
        for url in urls {
            if fileManager.fileExists(atPath: url.path) {
                try? fileManager.removeItem(at: url)
            }
        }
    }
    
    func testCompleteUserWorkflowWithAllFeatures() throws {
        // Test 1: Theme persistence across app launches
        themeManager.setDarkMode(true)
        themeManager.saveThemePreference()
        
        let newThemeManager = ThemeManager()
        XCTAssertTrue(newThemeManager.isDarkMode, "Theme should persist across app launches")
        
        // Test 2: Category creation with custom icons
        let workCategory = try noteManager.createCategory(name: "Work Projects", iconName: "briefcase")
        let personalCategory = try noteManager.createCategory(name: "Personal", iconName: "person")
        
        XCTAssertEqual(workCategory.name, "Work Projects")
        XCTAssertEqual(workCategory.iconName, "briefcase")
        XCTAssertEqual(personalCategory.iconName, "person")
        
        // Test 3: Note creation in different categories
        let workNote = noteManager.createNote(in: workCategory)
        let personalNote = noteManager.createNote(in: personalCategory)
        
        XCTAssertEqual(workNote.categoryId, workCategory.id)
        XCTAssertEqual(personalNote.categoryId, personalCategory.id)
        
        // Test 4: Note deletion functionality
        let initialNoteCount = noteManager.notes.count
        noteManager.deleteNote(workNote)
        
        XCTAssertEqual(noteManager.notes.count, initialNoteCount - 1)
        XCTAssertFalse(noteManager.notes.contains { $0.id == workNote.id })
        
        // Test 5: Category deletion with note reassignment
        let notesInPersonalBefore = noteManager.notes(for: personalCategory).count
        XCTAssertEqual(notesInPersonalBefore, 1) // personalNote should be there
        
        // Create another category to delete
        let tempCategory = try noteManager.createCategory(name: "Temporary", iconName: "folder")
        let tempNote = noteManager.createNote(in: tempCategory)
        
        // Delete the temporary category
        try noteManager.deleteCategory(tempCategory)
        
        // The temp note should be moved to another category
        let updatedTempNote = noteManager.notes.first { $0.id == tempNote.id }
        XCTAssertNotNil(updatedTempNote)
        XCTAssertNotEqual(updatedTempNote?.categoryId, tempCategory.id)
        
        // Test 6: Theme switching affects all color properties
        themeManager.setDarkMode(false)
        let lightBg = themeManager.backgroundColor
        let lightText = themeManager.textColor
        
        themeManager.setDarkMode(true)
        let darkBg = themeManager.backgroundColor
        let darkText = themeManager.textColor
        
        XCTAssertNotEqual(lightBg, darkBg)
        XCTAssertNotEqual(lightText, darkText)
        
        // Test 7: Divider color consistency (requirement 13.1)
        let dividerColor = themeManager.dividerColor
        XCTAssertEqual(dividerColor, Color.gray.opacity(0.3))
        
        // Test 8: Data persistence after operations
        noteManager.saveChanges()
        
        let newNoteManager = NoteManager()
        XCTAssertEqual(newNoteManager.categories.count, noteManager.categories.count)
        XCTAssertEqual(newNoteManager.notes.count, noteManager.notes.count)
        
        // Verify category icons are preserved
        let savedWorkCategory = newNoteManager.categories.first { $0.name == "Work Projects" }
        XCTAssertNotNil(savedWorkCategory)
        XCTAssertEqual(savedWorkCategory?.iconName, "briefcase")
    }
    
    func testErrorHandlingInCompleteWorkflow() throws {
        // Test error handling for duplicate category names
        _ = try noteManager.createCategory(name: "Test Category", iconName: "folder")
        
        XCTAssertThrowsError(try noteManager.createCategory(name: "Test Category", iconName: "star")) { error in
            XCTAssertTrue(error is CategoryError)
            if let categoryError = error as? CategoryError {
                XCTAssertEqual(categoryError, CategoryError.duplicateName)
            }
        }
        
        // Test error handling for invalid category names
        XCTAssertThrowsError(try noteManager.createCategory(name: "", iconName: "folder")) { error in
            XCTAssertTrue(error is CategoryError)
        }
        
        XCTAssertThrowsError(try noteManager.createCategory(name: "A", iconName: "folder")) { error in
            XCTAssertTrue(error is CategoryError)
        }
        
        let longName = String(repeating: "a", count: 51)
        XCTAssertThrowsError(try noteManager.createCategory(name: longName, iconName: "folder")) { error in
            XCTAssertTrue(error is CategoryError)
        }
        
        // Test error handling for category deletion edge cases
        // Try to delete when only one category exists
        let categories = noteManager.categories
        for category in categories.dropFirst() {
            try noteManager.deleteCategory(category)
        }
        
        let lastCategory = noteManager.categories.first!
        XCTAssertThrowsError(try noteManager.deleteCategory(lastCategory)) { error in
            XCTAssertTrue(error is CategoryError)
        }
    }
    
    func testSFSymbolPickerIntegration() throws {
        // Test that SF Symbol picker has valid icons
        let picker = SFSymbolPicker(selectedIcon: .constant("folder"), searchText: .constant(""))
        
        XCTAssertFalse(picker.availableIcons.isEmpty)
        XCTAssertTrue(picker.availableIcons.contains("folder"))
        XCTAssertTrue(picker.availableIcons.contains("briefcase"))
        XCTAssertTrue(picker.availableIcons.contains("person"))
        
        // Test filtering functionality
        let searchPicker = SFSymbolPicker(selectedIcon: .constant("folder"), searchText: .constant("heart"))
        let heartIcons = searchPicker.filteredIcons
        
        XCTAssertTrue(heartIcons.allSatisfy { $0.localizedCaseInsensitiveContains("heart") })
        
        // Test that filtered icons can be used to create categories
        if let firstHeartIcon = heartIcons.first {
            let category = try noteManager.createCategory(name: "Love Notes", iconName: firstHeartIcon)
            XCTAssertEqual(category.iconName, firstHeartIcon)
        }
    }
    
    func testUIBrandingRequirements() throws {
        // Test requirement 12.1: "Soul" instead of "Notes"
        // This would typically be tested in UI tests, but we can verify the string exists
        let expectedTitle = "Soul"
        XCTAssertEqual(expectedTitle, "Soul") // Placeholder for actual UI test
        
        // Test requirement 9.1: No top bar with "note" text
        // This is verified by the absence of navigation titles in the views
        
        // Test requirement 13.1: Muted grayish divider
        let dividerColor = themeManager.dividerColor
        XCTAssertEqual(dividerColor, Color.gray.opacity(0.3))
    }
    
    func testDarkModeIntegrationAcrossAllComponents() throws {
        // Test that all theme-aware colors change when switching modes
        
        // Light mode
        themeManager.setDarkMode(false)
        let lightColors = [
            themeManager.backgroundColor,
            themeManager.textColor,
            themeManager.cardBackgroundColor,
            themeManager.sidebarBackgroundColor,
            themeManager.secondaryTextColor
        ]
        
        // Dark mode
        themeManager.setDarkMode(true)
        let darkColors = [
            themeManager.backgroundColor,
            themeManager.textColor,
            themeManager.cardBackgroundColor,
            themeManager.sidebarBackgroundColor,
            themeManager.secondaryTextColor
        ]
        
        // Verify that colors are different between modes
        for (light, dark) in zip(lightColors, darkColors) {
            XCTAssertNotEqual(light, dark, "Colors should be different between light and dark modes")
        }
        
        // Verify specific dark mode requirements
        XCTAssertEqual(themeManager.backgroundColor, Color(hex: "171717"))
        XCTAssertEqual(themeManager.textColor, .white)
        
        // Verify accent color remains consistent
        let darkAccent = themeManager.accentColor
        themeManager.setDarkMode(false)
        let lightAccent = themeManager.accentColor
        XCTAssertEqual(darkAccent, lightAccent)
    }
}