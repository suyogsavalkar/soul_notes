//
//  SearchManager.swift
//  note
//
//  Created by Kiro on 29/07/25.
//

import Foundation
import Combine

class SearchManager: ObservableObject {
    @Published var searchQuery: String = ""
    @Published var searchResults: [Note] = []
    @Published var isSearchActive: Bool = false
    
    private var searchDebouncer = PerformanceOptimizer.Debouncer(delay: 0.3)
    
    /// Performs search across all notes, searching both title and body content
    func performSearch(query: String, in notes: [Note]) -> [Note] {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedQuery.isEmpty else {
            return []
        }
        
        let lowercaseQuery = trimmedQuery.lowercased()
        
        // Filter notes that match the query in title or body
        let matchingNotes = notes.filter { note in
            let titleMatch = note.title.lowercased().contains(lowercaseQuery)
            let bodyMatch = note.body.lowercased().contains(lowercaseQuery)
            return titleMatch || bodyMatch
        }
        
        // Sort results by relevance: title matches first, then content matches
        let sortedResults = matchingNotes.sorted { note1, note2 in
            let title1Match = note1.title.lowercased().contains(lowercaseQuery)
            let title2Match = note2.title.lowercased().contains(lowercaseQuery)
            
            // If one has title match and other doesn't, prioritize title match
            if title1Match && !title2Match {
                return true
            } else if !title1Match && title2Match {
                return false
            }
            
            // If both have title matches or both don't, sort by modification date
            return note1.modifiedAt > note2.modifiedAt
        }
        
        return sortedResults
    }
    
    /// Performs real-time search with debouncing to improve performance
    func performRealtimeSearch(query: String, in notes: [Note], completion: @escaping ([Note]) -> Void) {
        searchDebouncer.debounce {
            let results = self.performSearch(query: query, in: notes)
            DispatchQueue.main.async {
                completion(results)
            }
        }
    }
    
    /// Clears the current search state
    func clearSearch() {
        searchQuery = ""
        searchResults = []
        isSearchActive = false
        searchDebouncer.cancel()
    }
    
    /// Updates search state with new query
    func updateSearch(query: String, in notes: [Note]) {
        searchQuery = query
        isSearchActive = !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        
        if isSearchActive {
            performRealtimeSearch(query: query, in: notes) { [weak self] results in
                self?.searchResults = results
            }
        } else {
            searchResults = []
        }
    }
}