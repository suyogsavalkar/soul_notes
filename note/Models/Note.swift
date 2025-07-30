//
//  Note.swift
//  note
//
//  Created by Kiro on 26/07/25.
//

import Foundation

struct Note: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var body: String
    var categoryId: UUID
    var createdAt: Date
    var modifiedAt: Date
    
    init(title: String = "Untitled", body: String = "", categoryId: UUID) {
        self.id = UUID()
        self.title = title
        self.body = body
        self.categoryId = categoryId
        self.createdAt = Date()
        self.modifiedAt = Date()
    }
    
    /// Returns truncated body text for grid preview (max 150 characters)
    var preview: String {
        return PerformanceOptimizer.efficientTruncate(body, maxLength: 150)
    }
    
    /// Updates the modification date when note content changes
    mutating func updateModificationDate() {
        self.modifiedAt = Date()
    }
}