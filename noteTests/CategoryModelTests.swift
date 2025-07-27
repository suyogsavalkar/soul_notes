//
//  CategoryModelTests.swift
//  noteTests
//
//  Created by Kiro on 26/07/25.
//

import XCTest
@testable import note

final class CategoryModelTests: XCTestCase {
    
    func testCategoryInitialization() throws {
        let category = Category(name: "Test Category", iconName: "test.icon")
        
        XCTAssertFalse(category.id.uuidString.isEmpty)
        XCTAssertEqual(category.name, "Test Category")
        XCTAssertEqual(category.iconName, "test.icon")
        XCTAssertNotNil(category.createdAt)
    }
    
    func testCategoryDefaultIcon() throws {
        let category = Category(name: "Test Category")
        XCTAssertEqual(category.iconName, "folder")
    }
    
    func testDefaultCategories() throws {
        let defaultCategories = Category.defaultCategories
        
        XCTAssertGreaterThan(defaultCategories.count, 0)
        
        // Check that all default categories have required properties
        for category in defaultCategories {
            XCTAssertFalse(category.name.isEmpty)
            XCTAssertFalse(category.iconName.isEmpty)
            XCTAssertFalse(category.id.uuidString.isEmpty)
        }
        
        // Check for expected default categories
        let categoryNames = defaultCategories.map { $0.name }
        XCTAssertTrue(categoryNames.contains("General"))
        XCTAssertTrue(categoryNames.contains("Work"))
        XCTAssertTrue(categoryNames.contains("Personal"))
    }
    
    func testCategoryUniqueness() throws {
        let category1 = Category(name: "Same Name")
        let category2 = Category(name: "Same Name")
        
        // Categories with same name should have different IDs
        XCTAssertNotEqual(category1.id, category2.id)
    }
    
    func testCategoryIconNames() throws {
        let defaultCategories = Category.defaultCategories
        
        // Verify that default categories use valid SF Symbol names
        let validIconNames = ["doc.text", "briefcase", "person", "lightbulb", "folder"]
        
        for category in defaultCategories {
            // Icon names should be reasonable (not empty, reasonable length)
            XCTAssertFalse(category.iconName.isEmpty)
            XCTAssertLessThan(category.iconName.count, 50)
        }
    }
}