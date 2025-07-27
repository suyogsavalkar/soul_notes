//
//  SFSymbolPickerTests.swift
//  noteTests
//
//  Created by Kiro on 26/07/25.
//

import XCTest
import SwiftUI
@testable import note

final class SFSymbolPickerTests: XCTestCase {
    
    func testAvailableIconsNotEmpty() throws {
        let picker = SFSymbolPicker(selectedIcon: .constant("folder"), searchText: .constant(""))
        
        XCTAssertFalse(picker.availableIcons.isEmpty)
        XCTAssertTrue(picker.availableIcons.count > 50) // Should have a good selection
    }
    
    func testIconFiltering() throws {
        let picker = SFSymbolPicker(selectedIcon: .constant("folder"), searchText: .constant(""))
        
        // Test empty search returns all icons
        let allIcons = picker.filteredIcons
        XCTAssertEqual(allIcons.count, picker.availableIcons.count)
        
        // Test specific search
        let searchPicker = SFSymbolPicker(selectedIcon: .constant("folder"), searchText: .constant("heart"))
        let heartIcons = searchPicker.filteredIcons
        
        XCTAssertTrue(heartIcons.count < allIcons.count)
        XCTAssertTrue(heartIcons.allSatisfy { $0.localizedCaseInsensitiveContains("heart") })
    }
    
    func testIconFilteringCaseInsensitive() throws {
        let picker = SFSymbolPicker(selectedIcon: .constant("folder"), searchText: .constant("HEART"))
        let heartIcons = picker.filteredIcons
        
        XCTAssertTrue(heartIcons.count > 0)
        XCTAssertTrue(heartIcons.allSatisfy { $0.localizedCaseInsensitiveContains("heart") })
    }
    
    func testCommonIconsAvailable() throws {
        let picker = SFSymbolPicker(selectedIcon: .constant("folder"), searchText: .constant(""))
        let icons = picker.availableIcons
        
        // Test that common icons are available
        let expectedIcons = ["folder", "briefcase", "person", "heart", "star", "house", "car"]
        
        for expectedIcon in expectedIcons {
            XCTAssertTrue(icons.contains(expectedIcon), "Missing expected icon: \(expectedIcon)")
        }
    }
    
    func testIconCategoriesRepresented() throws {
        let picker = SFSymbolPicker(selectedIcon: .constant("folder"), searchText: .constant(""))
        let icons = picker.availableIcons
        
        // Test that different categories are represented
        XCTAssertTrue(icons.contains { $0.contains("folder") || $0.contains("doc") }) // General
        XCTAssertTrue(icons.contains { $0.contains("briefcase") || $0.contains("building") }) // Work
        XCTAssertTrue(icons.contains { $0.contains("person") || $0.contains("heart") }) // Personal
        XCTAssertTrue(icons.contains { $0.contains("car") || $0.contains("airplane") }) // Travel
        XCTAssertTrue(icons.contains { $0.contains("music") || $0.contains("camera") }) // Entertainment
    }
}