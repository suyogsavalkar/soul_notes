//
//  DataHelpersTests.swift
//  noteTests
//
//  Created by Kiro on 26/07/25.
//

import XCTest
@testable import note

final class DataHelpersTests: XCTestCase {
    
    func testJSONEncodingDecoding() throws {
        let originalNote = Note(
            title: "Test Note",
            body: "This is a test note with some content.",
            categoryId: UUID()
        )
        
        // Test encoding
        let encodedData = try JSONEncoder.noteEncoder.encode(originalNote)
        XCTAssertFalse(encodedData.isEmpty)
        
        // Test decoding
        let decodedNote = try JSONDecoder.noteDecoder.decode(Note.self, from: encodedData)
        
        XCTAssertEqual(decodedNote.id, originalNote.id)
        XCTAssertEqual(decodedNote.title, originalNote.title)
        XCTAssertEqual(decodedNote.body, originalNote.body)
        XCTAssertEqual(decodedNote.categoryId, originalNote.categoryId)
    }
    
    func testCategoryEncodingDecoding() throws {
        let originalCategory = Category(name: "Test Category", iconName: "folder")
        
        // Test encoding
        let encodedData = try JSONEncoder.noteEncoder.encode(originalCategory)
        XCTAssertFalse(encodedData.isEmpty)
        
        // Test decoding
        let decodedCategory = try JSONDecoder.noteDecoder.decode(Category.self, from: encodedData)
        
        XCTAssertEqual(decodedCategory.id, originalCategory.id)
        XCTAssertEqual(decodedCategory.name, originalCategory.name)
        XCTAssertEqual(decodedCategory.iconName, originalCategory.iconName)
    }
    
    func testFileManagerExtensions() throws {
        let fileManager = FileManager.default
        
        // Test notes directory creation
        let notesDir = fileManager.notesDirectory
        XCTAssertTrue(fileManager.fileExists(atPath: notesDir.path))
        
        // Test file URLs
        let notesURL = fileManager.notesFileURL
        let categoriesURL = fileManager.categoriesFileURL
        
        XCTAssertTrue(notesURL.path.hasSuffix("notes.json"))
        XCTAssertTrue(categoriesURL.path.hasSuffix("categories.json"))
    }
    
    func testArrayEncodingDecoding() throws {
        let notes = [
            Note(title: "Note 1", body: "Content 1", categoryId: UUID()),
            Note(title: "Note 2", body: "Content 2", categoryId: UUID())
        ]
        
        let categories = Category.defaultCategories
        
        // Test notes array
        let notesData = try JSONEncoder.noteEncoder.encode(notes)
        let decodedNotes = try JSONDecoder.noteDecoder.decode([Note].self, from: notesData)
        XCTAssertEqual(decodedNotes.count, notes.count)
        
        // Test categories array
        let categoriesData = try JSONEncoder.noteEncoder.encode(categories)
        let decodedCategories = try JSONDecoder.noteDecoder.decode([Category].self, from: categoriesData)
        XCTAssertEqual(decodedCategories.count, categories.count)
    }
}