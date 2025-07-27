//
//  Category.swift
//  note
//
//  Created by Kiro on 26/07/25.
//

import Foundation
import SwiftUI

struct Category: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var iconName: String
    var createdAt: Date
    
    init(name: String, iconName: String = "folder") {
        self.id = UUID()
        self.name = name
        self.iconName = iconName
        self.createdAt = Date()
    }
    
    /// Default categories that are created when the app first launches
    static let defaultCategories: [Category] = [
        Category(name: "General", iconName: "folder"),
        Category(name: "Work", iconName: "briefcase"),
        Category(name: "Personal", iconName: "person"),
        Category(name: "Ideas", iconName: "lightbulb")
    ]
}