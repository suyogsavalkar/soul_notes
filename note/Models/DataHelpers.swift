//
//  DataHelpers.swift
//  note
//
//  Created by Kiro on 26/07/25.
//

import Foundation

/// Helper extensions for data serialization and date handling
extension JSONEncoder {
    static let noteEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return encoder
    }()
}

extension JSONDecoder {
    static let noteDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
}

/// File manager extension for app-specific directory handling
extension FileManager {
    /// Returns the app's documents directory for storing notes
    var notesDirectory: URL {
        let documentsPath = urls(for: .documentDirectory, in: .userDomainMask).first!
        let notesPath = documentsPath.appendingPathComponent("NotesApp")
        
        // Create directory if it doesn't exist
        if !fileExists(atPath: notesPath.path) {
            try? createDirectory(at: notesPath, withIntermediateDirectories: true)
        }
        
        return notesPath
    }
    
    /// File URLs for data persistence
    var notesFileURL: URL {
        notesDirectory.appendingPathComponent("notes.json")
    }
    
    var categoriesFileURL: URL {
        notesDirectory.appendingPathComponent("categories.json")
    }
    
    var themeSettingsFileURL: URL {
        notesDirectory.appendingPathComponent("theme-settings.json")
    }
}