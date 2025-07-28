//
//  NoteManagerTests.swift
//  noteTests
//
//  Created by Kiro on 26/07/25.
//

import XCTest
@testable import note

final class NoteManagerTests: XCTestCase {
    var noteManager: NoteManager!
    var testCategory: note.Category!
    
    override func setUpWithError() throws {
        noteManager = NoteManager()
        testCategory = Category(name: "Test Category")
        noteManager.categories = [testCategory]
    }
    
    override func tearDownWithError() throws {
        noteManager = nil
        testCategory = nil
    }
    
    func testCreateNote() throws {
        let initialCount = noteManager.notes.count
        let newNote = noteManager.createNote(in: testCategory)
        
        XCTAssertEqual(noteManager.notes.count, initialCount + 1)
        XCTAssertEqual(newNote.categoryId, testCategory.id)
        XCTAssertEqual(newNote.title, "Untitled")
        XCTAssertEqual(newNote.body, "")
    }
    
    func testUpdateNote() throws {
        let note = noteManager.createNote(in: testCategory)
        let originalModifiedDate = note.modifiedAt
        
        // Wait a moment to ensure different timestamp
        Thread.sleep(forTimeInterval: 0.01)
        
        var updatedNote = note
        updatedNote.title = "Updated Title"
        updatedNote.body = "Updated Body"
        
        noteManager.updateNote(updatedNote)
        
        let savedNote = noteManager.notes.first { $0.id == note.id }
        XCTAssertNotNil(savedNote)
        XCTAssertEqual(savedNote?.title, "Updated Title")
        XCTAssertEqual(savedNote?.body, "Updated Body")
        XCTAssertGreaterThan(savedNote?.modifiedAt ?? Date.distantPast, originalModifiedDate)
    }
    
    func testDeleteNote() throws {
        let note = noteManager.createNote(in: testCategory)
        let initialCount = noteManager.notes.count
        
        noteManager.deleteNote(note)
        
        XCTAssertEqual(noteManager.notes.count, initialCount - 1)
        XCTAssertNil(noteManager.notes.first { $0.id == note.id })
    }
    
    func testNotesForCategory() throws {
        let category1 = Category(name: "Category 1")
        let category2 = Category(name: "Category 2")
        
        let note1 = noteManager.createNote(in: category1)
        let note2 = noteManager.createNote(in: category2)
        let note3 = noteManager.createNote(in: category1)
        
        let category1Notes = noteManager.notes(for: category1)
        let category2Notes = noteManager.notes(for: category2)
        
        XCTAssertEqual(category1Notes.count, 2)
        XCTAssertEqual(category2Notes.count, 1)
        XCTAssertTrue(category1Notes.contains { $0.id == note1.id })
        XCTAssertTrue(category1Notes.contains { $0.id == note3.id })
        XCTAssertTrue(category2Notes.contains { $0.id == note2.id })
    }
    
    func testNotePreview() throws {
        let shortBody = "Short text"
        let longBody = String(repeating: "This is a long text that should be truncated. ", count: 10)
        
        var note1 = Note(title: "Test", body: shortBody, categoryId: testCategory.id)
        var note2 = Note(title: "Test", body: longBody, categoryId: testCategory.id)
        
        XCTAssertEqual(note1.preview, shortBody)
        XCTAssertTrue(note2.preview.hasSuffix("..."))
        XCTAssertLessThan(note2.preview.count, longBody.count)
    }
    
    // MARK: - Category Management Tests
    
    func testCreateCategory() throws {
        let initialCount = noteManager.categories.count
        let newCategory = noteManager.createCategory(name: "Test Category", iconName: "star")
        
        XCTAssertEqual(noteManager.categories.count, initialCount + 1)
        XCTAssertEqual(newCategory.name, "Test Category")
        XCTAssertEqual(newCategory.iconName, "star")
    }
    
    func testCreateCategoryWithDuplicateName() throws {
        let category1 = noteManager.createCategory(name: "Duplicate", iconName: "folder")
        let category2 = noteManager.createCategory(name: "Duplicate", iconName: "star")
        
        XCTAssertNotEqual(category1.name, category2.name)
        XCTAssertTrue(category2.name.contains("Duplicate"))
        XCTAssertTrue(category2.name.contains("2") || category2.name.contains("3"))
    }
    
    func testCreateCategoryWithEmptyIcon() throws {
        let category = noteManager.createCategory(name: "No Icon", iconName: "")
        
        XCTAssertEqual(category.iconName, "folder") // Should default to folder
    }
    
    func testDeleteCategory() throws {
        let category1 = noteManager.createCategory(name: "Category 1", iconName: "folder")
        let category2 = noteManager.createCategory(name: "Category 2", iconName: "star")
        
        // Create notes in both categories
        let note1 = noteManager.createNote(in: category1)
        let note2 = noteManager.createNote(in: category2)
        
        let initialCategoryCount = noteManager.categories.count
        let initialNoteCount = noteManager.notes.count
        
        // Delete category1
        noteManager.deleteCategory(category1)
        
        // Category should be removed
        XCTAssertEqual(noteManager.categories.count, initialCategoryCount - 1)
        XCTAssertFalse(noteManager.categories.contains { $0.id == category1.id })
        
        // Notes should still exist but moved to another category
        XCTAssertEqual(noteManager.notes.count, initialNoteCount)
        
        // Note1 should be moved to a different category (not the deleted one)
        let updatedNote1 = noteManager.notes.first { $0.id == note1.id }
        XCTAssertNotNil(updatedNote1)
        XCTAssertNotEqual(updatedNote1?.categoryId, category1.id)
        
        // Note2 should remain in its original category
        let updatedNote2 = noteManager.notes.first { $0.id == note2.id }
        XCTAssertNotNil(updatedNote2)
        XCTAssertEqual(updatedNote2?.categoryId, category2.id)
    }
    
    func testDeleteCategoryMovesNotesToGeneral() throws {
        // Ensure we have a "General" category
        let generalCategory = noteManager.categories.first { $0.name == "General" } ?? 
                             noteManager.createCategory(name: "General", iconName: "folder")
        
        let testCategory = noteManager.createCategory(name: "Test Category", iconName: "star")
        let note = noteManager.createNote(in: testCategory)
        
        // Delete the test category
        noteManager.deleteCategory(testCategory)
        
        // Note should be moved to General category
        let updatedNote = noteManager.notes.first { $0.id == note.id }
        XCTAssertNotNil(updatedNote)
        XCTAssertEqual(updatedNote?.categoryId, generalCategory.id)
    }
}