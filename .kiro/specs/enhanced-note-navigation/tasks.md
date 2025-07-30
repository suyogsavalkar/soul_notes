# Implementation Plan

- [x] 1. Extend note preview truncation from 2 to 5 lines

  - Modify NotePreviewCard.swift to change lineLimit from 4 to 5 for preview text
  - Update Note.swift preview property to increase character limit from 100 to 150
  - Test preview display with various content lengths
  - _Requirements: 1.1, 1.2, 1.3_

- [x] 2. Create search functionality infrastructure

  - [x] 2.1 Create SearchManager class for search state management

    - Implement SearchManager as ObservableObject with searchQuery, searchResults, and isSearchActive properties
    - Add performSearch method that searches both title and body content case-insensitively
    - Add clearSearch method to reset search state
    - _Requirements: 2.2, 2.3_

  - [x] 2.2 Add search methods to NoteManager
    - Implement searchNotes method that filters notes across all categories
    - Add real-time search capability with debounced input handling
    - Sort search results by relevance (title matches first, then content matches)
    - _Requirements: 2.2, 2.3_

- [x] 3. Create search bar component

  - [x] 3.1 Implement SearchBar SwiftUI view

    - Create reusable SearchBar component with binding for search text
    - Add proper styling consistent with app theme
    - Include search icon and clear button functionality
    - _Requirements: 2.1_

  - [x] 3.2 Integrate search bar into SidebarView
    - Add search bar above categories list when "General" category is selected
    - Connect search bar to SearchManager for real-time filtering
    - Implement proper spacing and layout integration
    - _Requirements: 2.1_

- [x] 4. Implement search results display

  - [x] 4.1 Modify NotesGridView to handle search results

    - Add support for displaying search results from multiple categories
    - Implement empty state message when no search results found
    - Maintain existing grid layout and performance optimizations
    - _Requirements: 2.3, 2.6_

  - [x] 4.2 Update MainView to manage search state
    - Integrate SearchManager as environment object
    - Handle navigation from search results to note editor
    - Implement search result selection logic
    - _Requirements: 2.4, 2.5_

- [x] 5. Create close button for note editor

  - [x] 5.1 Implement EditorCloseButton component

    - Create close button with "xmark" SF Symbol icon
    - Add hover state with subtle red color effect (#FF6B6B)
    - Size button appropriately (16x16 points with 8pt padding)
    - _Requirements: 3.1, 3.2_

  - [x] 5.2 Integrate close button into NoteEditorView
    - Add close button to top-right section of editor controls
    - Implement close action that returns to category view
    - Ensure proper auto-save behavior before closing
    - _Requirements: 3.1, 3.3, 3.4_

- [x] 6. Update navigation flow for close functionality

  - [x] 6.1 Modify MainView navigation logic

    - Add onClose callback to NoteEditorView
    - Implement logic to return to category view containing the closed note
    - Handle edge cases where category might not exist
    - _Requirements: 3.3, 3.5_

  - [x] 6.2 Test close button navigation flow
    - Verify close button returns to correct category view
    - Test with notes from different categories
    - Ensure unsaved changes are properly handled
    - _Requirements: 3.3, 3.4_

- [x] 7. Add comprehensive testing

  - [x] 7.1 Create unit tests for search functionality

    - Test SearchManager search algorithm with various query types
    - Test NoteManager search methods for accuracy and performance
    - Verify search results sorting and filtering logic
    - _Requirements: 2.2, 2.3_

  - [x] 7.2 Create integration tests for navigation
    - Test complete search-to-note-selection flow
    - Test close button navigation across different scenarios
    - Verify preview card display with extended content
    - _Requirements: 1.1, 2.4, 3.3_

- [x] 8. Performance optimization and final integration

  - [x] 8.1 Implement search performance optimizations

    - Add debounced search with 300ms delay to prevent excessive filtering
    - Optimize search algorithm for large note collections
    - Implement search result caching for repeated queries
    - _Requirements: 2.2, 2.3_

  - [x] 8.2 Final integration and testing
    - Test all features together in complete user workflow
    - Verify accessibility labels and keyboard navigation
    - Ensure consistent theming across all new components
    - _Requirements: 1.3, 2.1, 3.5_
