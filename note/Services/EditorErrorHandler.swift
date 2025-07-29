//
//  EditorErrorHandler.swift
//  note
//
//  Created by Kiro on 28/07/25.
//

import Foundation
import SwiftUI
import Combine

// MARK: - Editor Error Types

enum EditorError: LocalizedError, Hashable {
    case saveFailure(underlying: Error)
    case textValidationFailure(reason: String)
    case focusManagementFailure
    case contentCorruption
    case autoSaveTimeout
    
    // MARK: - Hashable Conformance
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .saveFailure(let underlying):
            hasher.combine("saveFailure")
            hasher.combine(underlying.localizedDescription)
        case .textValidationFailure(let reason):
            hasher.combine("textValidationFailure")
            hasher.combine(reason)
        case .focusManagementFailure:
            hasher.combine("focusManagementFailure")
        case .contentCorruption:
            hasher.combine("contentCorruption")
        case .autoSaveTimeout:
            hasher.combine("autoSaveTimeout")
        }
    }
    
    static func == (lhs: EditorError, rhs: EditorError) -> Bool {
        switch (lhs, rhs) {
        case (.saveFailure(let lhsError), .saveFailure(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        case (.textValidationFailure(let lhsReason), .textValidationFailure(let rhsReason)):
            return lhsReason == rhsReason
        case (.focusManagementFailure, .focusManagementFailure),
             (.contentCorruption, .contentCorruption),
             (.autoSaveTimeout, .autoSaveTimeout):
            return true
        default:
            return false
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .saveFailure(let underlying):
            return "Failed to save note: \(underlying.localizedDescription)"
        case .textValidationFailure(let reason):
            return "Text validation failed: \(reason)"
        case .focusManagementFailure:
            return "Focus management error occurred"
        case .contentCorruption:
            return "Note content appears to be corrupted"
        case .autoSaveTimeout:
            return "Auto-save operation timed out"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .saveFailure:
            return "Please try saving again. If the problem persists, check your disk space and permissions."
        case .textValidationFailure:
            return "Please check your text content and try again."
        case .focusManagementFailure:
            return "Try clicking in the text area to restore focus."
        case .contentCorruption:
            return "Please copy your text to a safe location and restart the application."
        case .autoSaveTimeout:
            return "Auto-save is taking longer than expected. You can try saving manually."
        }
    }
}

// MARK: - Error Recovery Strategy

enum ErrorRecoveryStrategy {
    case retry(maxAttempts: Int)
    case fallback(action: () -> Void)
    case userIntervention(message: String)
    case ignore
}

// MARK: - Editor Error Handler

class EditorErrorHandler: ObservableObject {
    @Published var currentError: EditorError?
    @Published var isShowingError = false
    @Published var errorMessage = ""
    @Published var recoverySuggestion = ""
    
    private var errorRecoveryAttempts: [EditorError: Int] = [:]
    private let maxRetryAttempts = 3
    
    /// Handles an editor error with appropriate recovery strategy
    /// - Parameters:
    ///   - error: The error that occurred
    ///   - strategy: The recovery strategy to use (optional)
    func handleError(_ error: EditorError, strategy: ErrorRecoveryStrategy? = nil) {
        currentError = error
        errorMessage = error.localizedDescription
        recoverySuggestion = error.recoverySuggestion ?? ""
        
        let recoveryStrategy = strategy ?? defaultStrategy(for: error)
        
        switch recoveryStrategy {
        case .retry(let maxAttempts):
            handleRetryStrategy(for: error, maxAttempts: maxAttempts)
        case .fallback(let action):
            action()
        case .userIntervention:
            showErrorToUser()
        case .ignore:
            // Log error but don't show to user
            print("Editor error (ignored): \(error)")
        }
    }
    
    /// Validates text input and handles validation errors
    /// - Parameters:
    ///   - text: The text to validate
    ///   - field: The field being validated
    /// - Returns: True if validation passes, false otherwise
    func validateTextInput(_ text: String, field: String) -> Bool {
        // Check for extremely long text that might cause performance issues
        if text.count > 100_000 {
            handleError(.textValidationFailure(reason: "\(field) is too long (max 100,000 characters)"))
            return false
        }
        
        // Check for potential corruption indicators
        if text.contains("\0") {
            handleError(.contentCorruption)
            return false
        }
        
        return true
    }
    
    /// Safely performs a save operation with error handling
    /// - Parameter saveOperation: The save operation to perform
    /// - Returns: True if save succeeded, false otherwise
    func safeSave(_ saveOperation: @escaping () throws -> Void) async -> Bool {
        do {
            try saveOperation()
            clearError()
            return true
        } catch {
            handleError(.saveFailure(underlying: error))
            return false
        }
    }
    
    /// Recovers from focus management errors
    func recoverFocus() {
        // Clear any focus-related errors
        if case .focusManagementFailure = currentError {
            clearError()
        }
        
        // Post notification to reset focus state
        NotificationCenter.default.post(name: .editorFocusRecovery, object: nil)
    }
    
    /// Creates a backup of current content before risky operations
    /// - Parameters:
    ///   - title: Current note title
    ///   - body: Current note body
    func createContentBackup(title: String, body: String) {
        let backup = ContentBackup(
            title: title,
            body: body,
            timestamp: Date()
        )
        
        // Store in UserDefaults as emergency backup
        if let data = try? JSONEncoder().encode(backup) {
            UserDefaults.standard.set(data, forKey: "emergency_content_backup")
        }
    }
    
    /// Restores content from backup if available
    /// - Returns: Restored content backup, if available
    func restoreContentBackup() -> ContentBackup? {
        guard let data = UserDefaults.standard.data(forKey: "emergency_content_backup"),
              let backup = try? JSONDecoder().decode(ContentBackup.self, from: data) else {
            return nil
        }
        
        // Only restore if backup is recent (within last hour)
        if Date().timeIntervalSince(backup.timestamp) < 3600 {
            return backup
        }
        
        return nil
    }
    
    /// Clears the current error state
    func clearError() {
        currentError = nil
        isShowingError = false
        errorMessage = ""
        recoverySuggestion = ""
    }
    
    /// Dismisses the error dialog
    func dismissError() {
        isShowingError = false
    }
    
    // MARK: - Private Methods
    
    private func defaultStrategy(for error: EditorError) -> ErrorRecoveryStrategy {
        switch error {
        case .saveFailure:
            return .retry(maxAttempts: maxRetryAttempts)
        case .textValidationFailure:
            return .userIntervention(message: error.localizedDescription)
        case .focusManagementFailure:
            return .fallback(action: recoverFocus)
        case .contentCorruption:
            return .userIntervention(message: error.localizedDescription)
        case .autoSaveTimeout:
            return .userIntervention(message: error.localizedDescription)
        }
    }
    
    private func handleRetryStrategy(for error: EditorError, maxAttempts: Int) {
        let currentAttempts = errorRecoveryAttempts[error] ?? 0
        
        if currentAttempts < maxAttempts {
            errorRecoveryAttempts[error] = currentAttempts + 1
            // Retry logic would be handled by the calling code
        } else {
            // Max attempts reached, show error to user
            showErrorToUser()
        }
    }
    
    private func showErrorToUser() {
        isShowingError = true
    }
}

// MARK: - Content Backup Model

struct ContentBackup: Codable {
    let title: String
    let body: String
    let timestamp: Date
}



// MARK: - Error Alert View

struct EditorErrorAlert: View {
    @ObservedObject var errorHandler: EditorErrorHandler
    
    var body: some View {
        EmptyView()
            .alert("Editor Error", isPresented: $errorHandler.isShowingError) {
                Button("OK") {
                    errorHandler.dismissError()
                }
                
                if !errorHandler.recoverySuggestion.isEmpty {
                    Button("Retry") {
                        errorHandler.dismissError()
                        // Retry logic would be handled by parent view
                    }
                }
            } message: {
                VStack(alignment: .leading, spacing: 8) {
                    Text(errorHandler.errorMessage)
                    
                    if !errorHandler.recoverySuggestion.isEmpty {
                        Text(errorHandler.recoverySuggestion)
                            .font(.caption)
                    }
                }
            }
    }
}