//
//  SaveStateManager.swift
//  note
//
//  Created by Kiro on 28/07/25.
//

import Foundation
import Combine

enum SaveStatus {
    case saved
    case unsaved
    case saving
    case failed(Error)
}

class SaveStateManager: ObservableObject {
    @Published var saveStatus: SaveStatus = .saved
    @Published var lastSaveTime: Date?
    
    private let autoSaveDebouncer = PerformanceOptimizer.Debouncer(delay: 0.2)
    private var saveRetryCount = 0
    private let maxRetryAttempts = 3
    
    /// Schedules an auto-save operation with debouncing
    /// - Parameter saveOperation: The save operation to perform
    func scheduleAutoSave(_ saveOperation: @escaping () -> Void) {
        // Set status to unsaved immediately
        if case .saved = saveStatus {
            saveStatus = .unsaved
        }
        
        // Reduced debounce time for more responsive saving
        autoSaveDebouncer.debounce {
            Task { @MainActor in
                await self.performSave(saveOperation)
            }
        }
    }
    
    /// Performs an immediate save operation
    /// - Parameter saveOperation: The save operation to perform
    /// - Returns: True if save succeeded, false otherwise
    func performImmediateSave(_ saveOperation: @escaping () -> Void) async -> Bool {
        autoSaveDebouncer.cancel() // Cancel any pending auto-save
        return await performSave(saveOperation)
    }
    
    /// Internal method to perform the actual save operation
    /// - Parameter saveOperation: The save operation to perform
    /// - Returns: True if save succeeded, false otherwise
    @MainActor
    private func performSave(_ saveOperation: @escaping () -> Void) async -> Bool {
        saveStatus = .saving
        
        do {
            // Perform the save operation
            saveOperation()
            
            // Mark as saved
            saveStatus = .saved
            lastSaveTime = Date()
            saveRetryCount = 0
            
            // Show saved status briefly, then hide save button
            try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
            
            // Keep the saved status but don't show the button
            if case .saved = saveStatus {
                // Status remains saved, UI will hide the button
            }
            
            return true
            
        } catch {
            saveStatus = .failed(error)
            
            // Attempt retry if under max attempts
            if saveRetryCount < maxRetryAttempts {
                saveRetryCount += 1
                
                // Wait before retry
                try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
                
                // Retry the save
                return await performSave(saveOperation)
            } else {
                // Max retries reached, keep failed status
                print("Save failed after \(maxRetryAttempts) attempts: \(error)")
                return false
            }
        }
    }
    
    /// Marks content as having unsaved changes
    func markAsUnsaved() {
        if case .saved = saveStatus {
            saveStatus = .unsaved
        }
    }
    
    /// Resets the save state (useful when switching notes)
    func reset() {
        autoSaveDebouncer.cancel()
        saveStatus = .saved
        lastSaveTime = nil
        saveRetryCount = 0
    }
    
    /// Returns user-friendly save status text
    var saveStatusText: String {
        switch saveStatus {
        case .saved:
            return "Saved"
        case .unsaved:
            return "Save Changes"
        case .saving:
            return "Saving..."
        case .failed:
            return "Save Failed"
        }
    }
    
    /// Returns whether the save button should be visible
    var shouldShowSaveButton: Bool {
        switch saveStatus {
        case .saved:
            return false
        case .unsaved, .saving, .failed:
            return true
        }
    }
    
    /// Returns the appropriate color for the save button
    var saveButtonColor: SaveButtonColor {
        switch saveStatus {
        case .saved:
            return .success
        case .unsaved:
            return .primary
        case .saving:
            return .loading
        case .failed:
            return .error
        }
    }
}

enum SaveButtonColor {
    case primary
    case success
    case loading
    case error
}