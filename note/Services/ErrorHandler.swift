//
//  ErrorHandler.swift
//  note
//
//  Created by Kiro on 26/07/25.
//

import Foundation
import SwiftUI

enum NoteError: LocalizedError {
    case fileNotFound(String)
    case corruptedData(String)
    case insufficientStorage
    case permissionDenied
    case networkUnavailable
    case unknownError(Error)
    
    var errorDescription: String? {
        switch self {
        case .fileNotFound(let filename):
            return "File '\(filename)' could not be found."
        case .corruptedData(let details):
            return "Data corruption detected: \(details)"
        case .insufficientStorage:
            return "Insufficient storage space available."
        case .permissionDenied:
            return "Permission denied to access the file system."
        case .networkUnavailable:
            return "Network connection is unavailable."
        case .unknownError(let error):
            return "An unexpected error occurred: \(error.localizedDescription)"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .fileNotFound:
            return "The file may have been moved or deleted. Try restarting the app."
        case .corruptedData:
            return "Try restarting the app. If the problem persists, some data may need to be reset."
        case .insufficientStorage:
            return "Free up some disk space and try again."
        case .permissionDenied:
            return "Check your system permissions and try again."
        case .networkUnavailable:
            return "Check your internet connection and try again."
        case .unknownError:
            return "Try restarting the app. If the problem persists, contact support."
        }
    }
}

class ErrorHandler: ObservableObject {
    @Published var currentError: NoteError?
    @Published var showingError = false
    
    func handle(_ error: Error, context: String = "") {
        let noteError: NoteError
        
        if let noteErr = error as? NoteError {
            noteError = noteErr
        } else if let nsError = error as NSError? {
            switch nsError.code {
            case NSFileReadNoSuchFileError:
                noteError = .fileNotFound(nsError.localizedDescription)
            case NSFileWriteFileExistsError, NSFileWriteNoPermissionError:
                noteError = .permissionDenied
            case NSFileWriteOutOfSpaceError:
                noteError = .insufficientStorage
            default:
                noteError = .unknownError(error)
            }
        } else {
            noteError = .unknownError(error)
        }
        
        DispatchQueue.main.async {
            self.currentError = noteError
            self.showingError = true
        }
        
        // Log error for debugging
        print("Error in \(context): \(noteError.localizedDescription)")
    }
    
    func clearError() {
        currentError = nil
        showingError = false
    }
}