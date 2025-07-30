//
//  TitleEditorTests.swift
//  noteTests
//
//  Created by Kiro on 29/07/25.
//

import XCTest
import SwiftUI
@testable import note

final class TitleEditorTests: XCTestCase {
    
    func testTitleCharacterLimit() {
        // Test that titles are truncated at 35 characters
        let longTitle = "This is a very long title that exceeds the thirty-five character limit"
        let expectedTitle = String(longTitle.prefix(35))
        
        // Create a binding to test with
        var testTitle = longTitle
        let binding = Binding(
            get: { testTitle },
            set: { testTitle = $0 }
        )
        
        // The TitleEditor should truncate the title
        let titleEditor = TitleEditor(
            title: binding,
            onTextChange: { _, _ in },
            onImmediateSave: { _, _ in }
        )
        
        // Verify the title is truncated
        XCTAssertEqual(testTitle.count, 35)
        XCTAssertEqual(testTitle, expectedTitle)
    }
    
    func testTitleCharacterLimitEnforcement() {
        // Test that character limit is enforced during input
        var testTitle = ""
        let binding = Binding(
            get: { testTitle },
            set: { testTitle = $0 }
        )
        
        var changeCallCount = 0
        var saveCallCount = 0
        
        let titleEditor = TitleEditor(
            title: binding,
            onTextChange: { oldValue, newValue in
                changeCallCount += 1
                XCTAssertLessThanOrEqual(newValue.count, 35)
            },
            onImmediateSave: { oldValue, newValue in
                saveCallCount += 1
                XCTAssertLessThanOrEqual(newValue.count, 35)
            }
        )
        
        // Simulate typing a long title
        testTitle = "This is exactly thirty-five chars!!"
        
        // Verify the title is truncated to 35 characters
        XCTAssertEqual(testTitle.count, 35)
        XCTAssertEqual(testTitle, "This is exactly thirty-five chars!")
    }
    
    func testTitleAutoSave() {
        // Test that title changes trigger auto-save
        var testTitle = "Initial Title"
        let binding = Binding(
            get: { testTitle },
            set: { testTitle = $0 }
        )
        
        var immediateCallCount = 0
        var debouncedCallCount = 0
        var lastSavedValue = ""
        
        let titleEditor = TitleEditor(
            title: binding,
            onTextChange: { oldValue, newValue in
                debouncedCallCount += 1
            },
            onImmediateSave: { oldValue, newValue in
                immediateCallCount += 1
                lastSavedValue = newValue
            }
        )
        
        // Change the title
        testTitle = "Updated Title"
        
        // Verify immediate save was called
        XCTAssertEqual(immediateCallCount, 1)
        XCTAssertEqual(lastSavedValue, "Updated Title")
    }
    
    func testEmptyTitleHandling() {
        // Test that empty titles are handled correctly
        var testTitle = ""
        let binding = Binding(
            get: { testTitle },
            set: { testTitle = $0 }
        )
        
        let titleEditor = TitleEditor(
            title: binding,
            onTextChange: { _, _ in },
            onImmediateSave: { _, _ in }
        )
        
        // Empty title should be allowed
        XCTAssertEqual(testTitle, "")
        
        // Setting to empty should work
        testTitle = "Some Title"
        testTitle = ""
        XCTAssertEqual(testTitle, "")
    }
    
    func testTitleFocusManagement() {
        // Test that title editor can receive and manage focus
        var testTitle = "Test Title"
        let binding = Binding(
            get: { testTitle },
            set: { testTitle = $0 }
        )
        
        let titleEditor = TitleEditor(
            title: binding,
            onTextChange: { _, _ in },
            onImmediateSave: { _, _ in }
        )
        
        // Test focus state (this would be more comprehensive in a UI test)
        XCTAssertFalse(titleEditor.isCurrentlyFocused)
    }
}

final class EditorStateTests: XCTestCase {
    
    func testEditorStateWithTitle() {
        // Test that EditorState correctly handles title changes
        var editorState = EditorState()
        
        let originalTitle = "Original Title"
        let originalBody = "Original body content"
        let newTitle = "Updated Title"
        let newBody = "Updated body content"
        
        // Test with no changes
        editorState.update(
            title: originalTitle,
            body: originalBody,
            originalTitle: originalTitle,
            originalBody: originalBody
        )
        XCTAssertFalse(editorState.hasUnsavedChanges)
        
        // Test with title change only
        editorState.update(
            title: newTitle,
            body: originalBody,
            originalTitle: originalTitle,
            originalBody: originalBody
        )
        XCTAssertTrue(editorState.hasUnsavedChanges)
        
        // Test with body change only
        editorState.update(
            title: originalTitle,
            body: newBody,
            originalTitle: originalTitle,
            originalBody: originalBody
        )
        XCTAssertTrue(editorState.hasUnsavedChanges)
        
        // Test with both changes
        editorState.update(
            title: newTitle,
            body: newBody,
            originalTitle: originalTitle,
            originalBody: originalBody
        )
        XCTAssertTrue(editorState.hasUnsavedChanges)
        
        // Test mark as saved
        editorState.markAsSaved()
        XCTAssertFalse(editorState.hasUnsavedChanges)
        XCTAssertNotNil(editorState.lastSaveTime)
    }
    
    func testWordCountCalculation() {
        // Test that word count is calculated correctly regardless of title
        var editorState = EditorState()
        
        let title = "Test Title"
        let body = "This is a test body with multiple words"
        
        editorState.update(
            title: title,
            body: body,
            originalTitle: "",
            originalBody: ""
        )
        
        XCTAssertEqual(editorState.wordCount, 9) // "This is a test body with multiple words"
        XCTAssertTrue(editorState.hasUnsavedChanges)
    }
}

final class NoteModelTests: XCTestCase {
    
    func testNoteWithTitle() {
        // Test that Note model properly handles titles
        let categoryId = UUID()
        let note = Note(title: "Test Note", body: "Test content", categoryId: categoryId)
        
        XCTAssertEqual(note.title, "Test Note")
        XCTAssertEqual(note.body, "Test content")
        XCTAssertEqual(note.categoryId, categoryId)
        XCTAssertNotNil(note.id)
        XCTAssertNotNil(note.createdAt)
        XCTAssertNotNil(note.modifiedAt)
    }
    
    func testNoteDefaultTitle() {
        // Test that Note model uses default title when none provided
        let categoryId = UUID()
        let note = Note(categoryId: categoryId)
        
        XCTAssertEqual(note.title, "Untitled")
        XCTAssertEqual(note.body, "")
        XCTAssertEqual(note.categoryId, categoryId)
    }
    
    func testNoteModificationDate() {
        // Test that modification date is updated
        let categoryId = UUID()
        var note = Note(title: "Test", body: "Content", categoryId: categoryId)
        
        let originalModifiedAt = note.modifiedAt
        
        // Wait a brief moment to ensure time difference
        Thread.sleep(forTimeInterval: 0.01)
        
        note.updateModificationDate()
        
        XCTAssertGreaterThan(note.modifiedAt, originalModifiedAt)
    }
    
    func testNotePreview() {
        // Test that note preview works with titles
        let categoryId = UUID()
        let longBody = String(repeating: "This is a long body content. ", count: 10)
        let note = Note(title: "Test Title", body: longBody, categoryId: categoryId)
        
        XCTAssertLessThanOrEqual(note.preview.count, 150)
        XCTAssertTrue(note.preview.contains("This is a long body content."))
    }
}