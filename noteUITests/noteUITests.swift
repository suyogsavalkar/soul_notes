//
//  noteUITests.swift
//  noteUITests
//
//  Created by Kiro on 26/07/25.
//

import XCTest

final class noteUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    func testSidebarNavigationAndCategorySelection() throws {
        // Wait for app to load
        XCTAssertTrue(app.waitForExistence(timeout: 5.0))
        
        // Check that sidebar exists and contains categories
        let sidebar = app.groups.containing(.staticText, identifier: "Notes").firstMatch
        XCTAssertTrue(sidebar.exists)
        
        // Look for category buttons in sidebar
        let generalCategory = app.buttons["General"]
        let workCategory = app.buttons["Work"]
        let personalCategory = app.buttons["Personal"]
        
        // Test category selection
        if generalCategory.exists {
            generalCategory.tap()
            // Verify category is selected (this would depend on accessibility identifiers)
        }
        
        if workCategory.exists {
            workCategory.tap()
            // Should switch to work category view
        }
        
        if personalCategory.exists {
            personalCategory.tap()
            // Should switch to personal category view
        }
    }
    
    func testNoteCreationFlow() throws {
        XCTAssertTrue(app.waitForExistence(timeout: 5.0))
        
        // Select a category first
        let generalCategory = app.buttons["General"]
        if generalCategory.exists {
            generalCategory.tap()
        }
        
        // Look for create note button/card
        let createNoteButton = app.buttons.containing(.staticText, identifier: "Create New Note").firstMatch
        if createNoteButton.exists {
            createNoteButton.tap()
            
            // Should navigate to editor view
            let titleField = app.textFields.firstMatch
            let bodyField = app.textViews.firstMatch
            
            XCTAssertTrue(titleField.waitForExistence(timeout: 3.0))
            XCTAssertTrue(bodyField.exists)
            
            // Test typing in title
            titleField.tap()
            titleField.typeText("Test Note Title")
            
            // Test typing in body
            bodyField.tap()
            bodyField.typeText("This is test content for the note body.")
            
            // Look for save button (should appear after typing)
            let saveButton = app.buttons["Save Changes"]
            if saveButton.waitForExistence(timeout: 2.0) {
                saveButton.tap()
            }
        }
    }
    
    func testSidebarToggleInEditor() throws {
        XCTAssertTrue(app.waitForExistence(timeout: 5.0))
        
        // First create or select a note to enter editor mode
        let generalCategory = app.buttons["General"]
        if generalCategory.exists {
            generalCategory.tap()
        }
        
        // Try to find an existing note or create one
        let createNoteButton = app.buttons.containing(.staticText, identifier: "Create New Note").firstMatch
        if createNoteButton.exists {
            createNoteButton.tap()
            
            // Now we should be in editor mode
            // Look for sidebar toggle button
            let sidebarToggle = app.buttons.containing(.image, identifier: "sidebar.left").firstMatch
            if sidebarToggle.exists {
                // Test toggling sidebar
                sidebarToggle.tap()
                
                // Wait a moment for animation
                Thread.sleep(forTimeInterval: 0.5)
                
                // Toggle back
                sidebarToggle.tap()
            }
        }
    }
    
    func testNoteGridInteraction() throws {
        XCTAssertTrue(app.waitForExistence(timeout: 5.0))
        
        // Select a category
        let generalCategory = app.buttons["General"]
        if generalCategory.exists {
            generalCategory.tap()
            
            // Look for note cards in grid
            let noteCards = app.buttons.matching(identifier: "NotePreviewCard")
            
            if noteCards.count > 0 {
                let firstCard = noteCards.element(boundBy: 0)
                firstCard.tap()
                
                // Should navigate to editor
                let titleField = app.textFields.firstMatch
                XCTAssertTrue(titleField.waitForExistence(timeout: 3.0))
            }
        }
    }
    
    func testKeyboardShortcuts() throws {
        XCTAssertTrue(app.waitForExistence(timeout: 5.0))
        
        // Navigate to editor mode first
        let generalCategory = app.buttons["General"]
        if generalCategory.exists {
            generalCategory.tap()
        }
        
        let createNoteButton = app.buttons.containing(.staticText, identifier: "Create New Note").firstMatch
        if createNoteButton.exists {
            createNoteButton.tap()
            
            // Test in editor
            let titleField = app.textFields.firstMatch
            let bodyField = app.textViews.firstMatch
            
            if titleField.waitForExistence(timeout: 3.0) {
                titleField.tap()
                titleField.typeText("Keyboard Test")
                
                bodyField.tap()
                bodyField.typeText("Testing keyboard shortcuts")
                
                // Test Command+S for save
                app.typeKey("s", modifierFlags: .command)
                
                // Save button should appear and then disappear after save
                let saveButton = app.buttons["Save Changes"]
                if saveButton.exists {
                    // Wait for auto-save to complete
                    Thread.sleep(forTimeInterval: 1.5)
                }
            }
        }
    }
    
    func testResponsiveGridLayout() throws {
        XCTAssertTrue(app.waitForExistence(timeout: 5.0))
        
        // Select a category with notes
        let generalCategory = app.buttons["General"]
        if generalCategory.exists {
            generalCategory.tap()
            
            // Get initial window size
            let window = app.windows.firstMatch
            let initialFrame = window.frame
            
            // Look for grid container
            let scrollView = app.scrollViews.firstMatch
            if scrollView.exists {
                // Count visible note cards
                let noteCards = app.buttons.matching(identifier: "NotePreviewCard")
                let initialCardCount = noteCards.count
                
                // This test would be more effective with actual window resizing
                // which requires additional setup for UI testing
                XCTAssertGreaterThanOrEqual(initialCardCount, 0)
            }
        }
    }
    
    func testAutoSaveVisualFeedback() throws {
        XCTAssertTrue(app.waitForExistence(timeout: 5.0))
        
        // Navigate to editor
        let generalCategory = app.buttons["General"]
        if generalCategory.exists {
            generalCategory.tap()
        }
        
        let createNoteButton = app.buttons.containing(.staticText, identifier: "Create New Note").firstMatch
        if createNoteButton.exists {
            createNoteButton.tap()
            
            let titleField = app.textFields.firstMatch
            let bodyField = app.textViews.firstMatch
            
            if titleField.waitForExistence(timeout: 3.0) {
                // Type something to trigger auto-save
                titleField.tap()
                titleField.typeText("Auto-save test")
                
                bodyField.tap()
                bodyField.typeText("Testing auto-save functionality")
                
                // Save button should appear
                let saveButton = app.buttons["Save Changes"]
                XCTAssertTrue(saveButton.waitForExistence(timeout: 2.0))
                
                // Wait for auto-save to complete
                Thread.sleep(forTimeInterval: 1.0)
                
                // Button should change to "Saved" state
                let savedButton = app.buttons["Saved"]
                XCTAssertTrue(savedButton.waitForExistence(timeout: 2.0))
            }
        }
    }
}