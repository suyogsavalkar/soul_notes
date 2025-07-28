//
//  IntegrationTests.swift
//  noteTests
//
//  Created by Kiro on 26/07/25.
//

import XCTest
@testable import note

final class IntegrationTests: XCTestCase {
    var noteManager: NoteManager!
    var testCategory: note.Category!
    
    override func setUpWithError() throws {
        noteManager = NoteManager()
        
        // Ensure we have a test category
        if let existingCategory = noteManager.categories.first {
            testCategory = existingCategory
        } else {
            testCategory = Category(name: "Test Category")
            noteManager.categories.append(testCategory)
        }
    }
    
    override func tearDownWithError() throws {
        noteManager = nil
        testCategory = nil
    }
    
    func testCompleteNoteCreationAndEditingWorkflow() throws {
        let initialNoteCount = noteManager.notes.count
        
        // Step 1: Create a new note
        let newNote = noteManager.createNote(in: testCategory)
        XCTAssertEqual(noteManager.notes.count, initialNoteCount + 1)
        XCTAssertEqual(newNote.categoryId, testCategory.id)
        XCTAssertEqual(newNote.title, "Untitled")
        XCTAssertEqual(newNote.body, "")
        
        // Step 2: Edit the note
        var editedNote = newNote
        editedNote.title = "My Important Note"
        editedNote.body = "This is the content of my important note with some details."
        
        noteManager.updateNote(editedNote)
        
        // Step 3: Verify the note was updated
        let savedNote = noteManager.notes.first { $0.id == newNote.id }
        XCTAssertNotNil(savedNote)
        XCTAssertEqual(savedNote?.title, "My Important Note")
        XCTAssertEqual(savedNote?.body, "This is the content of my important note with some details.")
        XCTAssertGreaterThan(savedNote?.modifiedAt ?? Date.distantPast, newNote.modifiedAt)
        
        // Step 4: Test note preview generation
        XCTAssertFalse(savedNote?.preview.isEmpty ?? true)
        XCTAssertTrue(savedNote?.preview.contains("This is the content") ?? false)
        
        // Step 5: Test category filtering
        let categoryNotes = noteManager.notes(for: testCategory)
        XCTAssertTrue(categoryNotes.contains { $0.id == newNote.id })
        
        // Step 6: Delete the note
        noteManager.deleteNote(editedNote)
        XCTAssertEqual(noteManager.notes.count, initialNoteCount)
        XCTAssertNil(noteManager.notes.first { $0.id == newNote.id })
    }
    
    func testCategorySwitchingAndNoteFiltering() throws {
        // Create notes in different categories
        let category1 = Category(name: "Category 1")
        let category2 = Category(name: "Category 2")
        
        noteManager.categories.append(contentsOf: [category1, category2])
        
        let note1 = noteManager.createNote(in: category1)
        let note2 = noteManager.createNote(in: category2)
        let note3 = noteManager.createNote(in: category1)
        
        // Test filtering by category
        let category1Notes = noteManager.notes(for: category1)
        let category2Notes = noteManager.notes(for: category2)
        
        XCTAssertEqual(category1Notes.count, 2)
        XCTAssertEqual(category2Notes.count, 1)
        
        XCTAssertTrue(category1Notes.contains { $0.id == note1.id })
        XCTAssertTrue(category1Notes.contains { $0.id == note3.id })
        XCTAssertTrue(category2Notes.contains { $0.id == note2.id })
        
        XCTAssertFalse(category1Notes.contains { $0.id == note2.id })
        XCTAssertFalse(category2Notes.contains { $0.id == note1.id })
        
        // Clean up
        noteManager.deleteNote(note1)
        noteManager.deleteNote(note2)
        noteManager.deleteNote(note3)
    }
    
    func testAutoSaveBehavior() throws {
        let note = noteManager.createNote(in: testCategory)
        let originalModifiedDate = note.modifiedAt
        
        // Simulate auto-save scenario
        Thread.sleep(forTimeInterval: 0.01) // Ensure different timestamp
        
        var updatedNote = note
        updatedNote.title = "Auto-saved Title"
        updatedNote.body = "Auto-saved content"
        
        noteManager.updateNote(updatedNote)
        
        // Verify auto-save worked
        let savedNote = noteManager.notes.first { $0.id == note.id }
        XCTAssertNotNil(savedNote)
        XCTAssertEqual(savedNote?.title, "Auto-saved Title")
        XCTAssertEqual(savedNote?.body, "Auto-saved content")
        XCTAssertGreaterThan(savedNote?.modifiedAt ?? Date.distantPast, originalModifiedDate)
        
        // Clean up
        noteManager.deleteNote(updatedNote)
    }
    
    func testDataPersistenceWorkflow() throws {
        let initialNoteCount = noteManager.notes.count
        let initialCategoryCount = noteManager.categories.count
        
        // Create test data
        let testNote = noteManager.createNote(in: testCategory)
        var editedNote = testNote
        editedNote.title = "Persistence Test"
        editedNote.body = "This note should persist across app sessions"
        noteManager.updateNote(editedNote)
        
        // Force save
        noteManager.saveChanges()
        
        // Simulate app restart by creating new manager
        let newNoteManager = NoteManager()
        
        // Verify data was loaded
        XCTAssertEqual(newNoteManager.notes.count, initialNoteCount + 1)
        XCTAssertEqual(newNoteManager.categories.count, initialCategoryCount)
        
        let persistedNote = newNoteManager.notes.first { $0.id == testNote.id }
        XCTAssertNotNil(persistedNote)
        XCTAssertEqual(persistedNote?.title, "Persistence Test")
        XCTAssertEqual(persistedNote?.body, "This note should persist across app sessions")
        
        // Clean up
        newNoteManager.deleteNote(editedNote)
    }
    
    func testMultipleNotesInSameCategory() throws {
        let noteCount = 5
        var createdNotes: [Note] = []
        
        // Create multiple notes
        for i in 1...noteCount {
            let note = noteManager.createNote(in: testCategory)
            var editedNote = note
            editedNote.title = "Note \(i)"
            editedNote.body = "Content for note number \(i)"
            noteManager.updateNote(editedNote)
            createdNotes.append(editedNote)
        }
        
        // Verify all notes are in the category
        let categoryNotes = noteManager.notes(for: testCategory)
        XCTAssertGreaterThanOrEqual(categoryNotes.count, noteCount)
        
        for createdNote in createdNotes {
            XCTAssertTrue(categoryNotes.contains { $0.id == createdNote.id })
        }
        
        // Test that each note has unique content
        let titles = categoryNotes.compactMap { $0.title }
        let uniqueTitles = Set(titles)
        XCTAssertGreaterThanOrEqual(uniqueTitles.count, noteCount)
        
        // Clean up
        for note in createdNotes {
            noteManager.deleteNote(note)
        }
    }
}