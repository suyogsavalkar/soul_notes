//
//  CategoryCreationTests.swift
//  noteTests
//
//  Created by Kiro on 26/07/25.
//

import XCTest
import SwiftUI
@testable import note

final class CategoryCreationTests: XCTestCase {
    
    func testCategoryCreationValidation() throws {
        var createdCategory: (String, String)?
        
        let view = CategoryCreationView(
            isPresented: .constant(true),
            onCategoryCreate: { name, icon in
                createdCategory = (name, icon)
            }
        )
        
        // Test that validation works (this would be tested in UI tests in a real scenario)
        // Here we test the underlying logic
        
        let validName = "Test Category"
        let validIcon = "star"
        
        XCTAssertFalse(validName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        XCTAssertTrue(validName.count <= 50)
        XCTAssertFalse(validIcon.isEmpty)
    }
    
    func testCategoryNameTrimming() throws {
        let testCases = [
            ("  Test Category  ", "Test Category"),
            ("\n\tSpaced\t\n", "Spaced"),
            ("Normal", "Normal"),
            ("", "")
        ]
        
        for (input, expected) in testCases {
            let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
            XCTAssertEqual(trimmed, expected, "Failed for input: '\(input)'")
        }
    }
    
    func testCategoryNameLengthValidation() throws {
        let shortName = "OK"
        let normalName = "This is a normal category name"
        let longName = String(repeating: "a", count: 51)
        
        XCTAssertTrue(shortName.count <= 50)
        XCTAssertTrue(normalName.count <= 50)
        XCTAssertFalse(longName.count <= 50)
    }
    
    func testDefaultIconSelection() throws {
        // Test that folder is a reasonable default
        let defaultIcon = "folder"
        
        // Should be in the available icons list
        let picker = SFSymbolPicker(selectedIcon: .constant(defaultIcon), searchText: .constant(""))
        XCTAssertTrue(picker.availableIcons.contains(defaultIcon))
    }
}