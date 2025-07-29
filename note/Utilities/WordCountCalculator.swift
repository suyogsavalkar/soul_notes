//
//  WordCountCalculator.swift
//  note
//
//  Created by Kiro on 28/07/25.
//

import Foundation

struct WordCountCalculator {
    
    /// Calculates the word count for a given text string
    /// - Parameter text: The text to count words in
    /// - Returns: The number of words in the text
    static func countWords(in text: String) -> Int {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Return 0 for empty text
        if trimmedText.isEmpty {
            return 0
        }
        
        // Use NSString's built-in word enumeration for accurate counting
        var wordCount = 0
        
        trimmedText.enumerateSubstrings(
            in: trimmedText.startIndex..<trimmedText.endIndex,
            options: [.byWords, .localized]
        ) { (substring, _, _, _) in
            if substring != nil {
                wordCount += 1
            }
        }
        
        return wordCount
    }
    
    /// Calculates combined word count from title and body
    /// - Parameters:
    ///   - title: The note title
    ///   - body: The note body content
    /// - Returns: Combined word count from both title and body
    static func combinedWordCount(title: String, body: String) -> Int {
        let titleWords = countWords(in: title)
        let bodyWords = countWords(in: body)
        return titleWords + bodyWords
    }
    
    /// Determines if the "Reflect with AI" button should be enabled based on word count
    /// - Parameters:
    ///   - title: The note title
    ///   - body: The note body content
    /// - Returns: True if word count is 150 or more, false otherwise
    static func isReflectButtonEnabled(title: String, body: String) -> Bool {
        return combinedWordCount(title: title, body: body) >= 150
    }
}

// MARK: - EditorState

struct EditorState {
    var hasUnsavedChanges: Bool = false
    var wordCount: Int = 0
    var isReflectButtonEnabled: Bool = false
    var lastSaveTime: Date?
    
    /// Updates the editor state based on current note content
    /// - Parameters:
    ///   - title: Current note title
    ///   - body: Current note body
    ///   - originalTitle: Original note title for comparison
    ///   - originalBody: Original note body for comparison
    mutating func update(title: String, body: String, originalTitle: String, originalBody: String) {
        // Update word count
        wordCount = WordCountCalculator.combinedWordCount(title: title, body: body)
        
        // Update reflect button state
        isReflectButtonEnabled = WordCountCalculator.isReflectButtonEnabled(title: title, body: body)
        
        // Update unsaved changes state
        hasUnsavedChanges = title != originalTitle || body != originalBody
    }
    
    /// Marks the state as saved
    mutating func markAsSaved() {
        hasUnsavedChanges = false
        lastSaveTime = Date()
    }
}