//
//  FocusManager.swift
//  note
//
//  Created by Kiro on 28/07/25.
//

import SwiftUI
import Combine

enum EditorFocusField {
    case title
    case body
}

class FocusManager: ObservableObject {
    @Published var currentFocus: EditorFocusField?
    @Published var previousFocus: EditorFocusField?
    
    private var focusTransitionTimer: Timer?
    
    /// Sets focus to a specific field
    /// - Parameter field: The field to focus on
    func setFocus(to field: EditorFocusField) {
        previousFocus = currentFocus
        currentFocus = field
    }
    
    /// Moves focus to the next field in sequence
    func focusNext() {
        switch currentFocus {
        case .title:
            setFocus(to: .body)
        case .body:
            // Stay on body (last field)
            break
        case .none:
            setFocus(to: .title)
        }
    }
    
    /// Moves focus to the previous field in sequence
    func focusPrevious() {
        switch currentFocus {
        case .title:
            // Stay on title (first field)
            break
        case .body:
            setFocus(to: .title)
        case .none:
            setFocus(to: .title)
        }
    }
    
    /// Clears focus from all fields
    func clearFocus() {
        previousFocus = currentFocus
        currentFocus = nil
    }
    
    /// Returns focus to the previously focused field
    func restorePreviousFocus() {
        if let previous = previousFocus {
            currentFocus = previous
        }
    }
    
    /// Handles smooth focus transitions with a brief delay
    /// - Parameters:
    ///   - to: The field to transition focus to
    ///   - delay: The delay before transitioning (default: 0.1 seconds)
    func smoothTransition(to field: EditorFocusField, delay: TimeInterval = 0.1) {
        focusTransitionTimer?.invalidate()
        
        focusTransitionTimer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
            DispatchQueue.main.async {
                self.setFocus(to: field)
            }
        }
    }
    
    /// Checks if a specific field is currently focused
    /// - Parameter field: The field to check
    /// - Returns: True if the field is focused, false otherwise
    func isFocused(_ field: EditorFocusField) -> Bool {
        return currentFocus == field
    }
    
    /// Cleanup method to invalidate timers
    func cleanup() {
        focusTransitionTimer?.invalidate()
        focusTransitionTimer = nil
    }
    
    deinit {
        cleanup()
    }
}

// MARK: - Focus State Binding Helper

struct FocusStateBinding {
    let focusManager: FocusManager
    let field: EditorFocusField
    
    var wrappedValue: Bool {
        get {
            focusManager.isFocused(field)
        }
        nonmutating set {
            if newValue {
                focusManager.setFocus(to: field)
            } else if focusManager.isFocused(field) {
                focusManager.clearFocus()
            }
        }
    }
    
    var projectedValue: FocusStateBinding {
        return self
    }
}

// MARK: - Notification Extensions

extension Notification.Name {
    static let editorFocusRecovery = Notification.Name("editorFocusRecovery")
}

// MARK: - View Extensions for Focus Management

extension View {
    /// Applies focus management without visual indicators (clean design)
    /// - Parameters:
    ///   - focusManager: The focus manager instance
    ///   - field: The field this view represents
    ///   - themeManager: The theme manager for styling
    /// - Returns: View with focus management applied
    func managedFocus(
        _ focusManager: FocusManager,
        field: EditorFocusField,
        themeManager: ThemeManager
    ) -> some View {
        self
            // No visual focus indicators for clean design
    }
}