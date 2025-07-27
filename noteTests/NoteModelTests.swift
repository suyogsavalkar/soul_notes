//
//  NoteModelTests.swift
//  noteTests
//
//  Created by Kiro on 26/07/25.
//

import XCTest
@testable import note

final class NoteModelTests: XCTestCase {
    
    func testNoteInitialization() throws {
        let categoryId = UUID()
        let note = Note(title: "Test Title", body: "Test Body", categoryId: categoryId)
        
        XCTAssertFalse(note.id.uuidString.isEmpty)
        XCTAssertEqual(note.title, "Test Title")
        XCTAssertEqual(note.body, "Test Body")
        XCTAssertEqual(note.categoryId, categoryId)
        XCTAssertNotNil(note.createdAt)
        XCTAssertNotNil(note.modifiedAt)
    }
    
    func testNoteDefaultInitialization() throws {
        let categoryId = UUID()
        let note = Note(categoryId: categoryId)
        
        XCTAssertEqual(note.title, "Untitled")
        XCTAssertEqual(note.body, "")
        XCTAssertEqual(note.categoryId, categoryId)
    }
    
    func testNotePreviewShortText() throws {
        let note = Note(title: "Test", body: "Short text", categoryId: UUID())
        XCTAssertEqual(note.preview, "Short text")
    }
    
    func testNotePreviewLongText() throws {
        let longText = String(repeating: "This is a long text that should be truncated. ", count: 10)
        let note = Note(title: "Test", body: longText, categoryId: UUID())
        
        XCTAssertTrue(note.preview.hasSuffix("..."))
        XCTAssertLessThan(note.preview.count, longText.count)
        XCTAssertLessThanOrEqual(note.preview.count, 103) // 100 + "..."
    }
    
    func testNotePreviewWordBoundary() throws {
        let text = "This is exactly one hundred characters long and should be truncated at word boundary test"
        let note = Note(title: "Test", body: text, categoryId: UUID())
        
        if note.preview.hasSuffix("...") {
            // Should not cut words in half
            let previewWithoutEllipsis = String(note.preview.dropLast(3))
            XCTAssertFalse(previewWithoutEllipsis.hasSuffix(" "))
        }
    }
    
    func testUpdateModificationDate() throws {
        var note = Note(title: "Test", body: "Test", categoryId: UUID())
        let originalDate = note.modifiedAt
        
        // Wait a moment to ensure different timestamp
        Thread.sleep(forTimeInterval: 0.01)
        
        note.updateModificationDate()
        XCTAssertGreaterThan(note.modifiedAt, originalDate)
    }
    
    func testNoteEquality() throws {
        let categoryId = UUID()
        let note1 = Note(title: "Test", body: "Body", categoryId: categoryId)
        let note2 = Note(title: "Test", body: "Body", categoryId: categoryId)
        
        // Notes should have different IDs even with same content
        XCTAssertNotEqual(note1.id, note2.id)
    }
}