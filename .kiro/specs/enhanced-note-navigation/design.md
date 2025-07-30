# Design Document

## Overview

This design enhances the Solo note-taking app with three key UI improvements: extended note previews, global search functionality, and improved navigation controls. The design maintains the app's clean, minimal aesthetic while adding powerful discovery and navigation features.

## Architecture

### Component Structure
The enhancements will modify existing SwiftUI views and add new search functionality:

- **NotePreviewCard**: Extend preview line limit from 2 to 5 lines
- **SidebarView**: Add search functionality to the "General" category section
- **NoteManager**: Add search methods for cross-category note discovery
- **NoteEditorView**: Add close button with navigation back to category view
- **MainView**: Handle search state and navigation flow

### Data Flow
```
Search Input → NoteManager.searchNotes() → Filtered Results → NotesGridView → Note Selection → NoteEditorView
```

## Components and Interfaces

### 1. Enhanced Note Preview Cards

**NotePreviewCard Modifications:**
- Change `lineLimit(4)` to `lineLimit(5)` for preview text
- Maintain existing card dimensions and layout
- Preserve hover effects and visual consistency

**Preview Text Calculation:**
- Extend `Note.preview` property to support longer previews
- Increase character limit from 100 to approximately 150 characters
- Maintain ellipsis truncation for overflow content

### 2. Search Functionality

**Search Interface:**
```swift
struct SearchBar: View {
    @Binding var searchText: String
    let placeholder: String
    let onSearchChange: (String) -> Void
}
```

**Search Integration in SidebarView:**
- Add search bar above the categories list when "General" is selected
- Position search field prominently with proper spacing
- Use consistent styling with app theme

**NoteManager Search Methods:**
```swift
func searchNotes(query: String) -> [Note]
func searchNotesRealtime(query: String) -> [Note]
```

**Search Algorithm:**
- Search both `note.title` and `note.body` content
- Case-insensitive matching
- Real-time filtering as user types
- Return results from all categories
- Sort results by relevance (title matches first, then content matches)

### 3. Close Button Navigation

**Close Button Component:**
```swift
struct EditorCloseButton: View {
    let onClose: () -> Void
    @State private var isHovered: Bool = false
}
```

**Visual Design:**
- Small "xmark" SF Symbol icon
- Position in top-right area of editor controls
- Subtle red hover effect (#FF6B6B with opacity)
- Size: 16x16 points
- Padding: 8 points on all sides

**Navigation Logic:**
- Close current note editor
- Return to category view containing the note
- Preserve auto-save functionality before closing
- Update MainView state to show NotesGridView

## Data Models

### Search State Management
```swift
class SearchManager: ObservableObject {
    @Published var searchQuery: String = ""
    @Published var searchResults: [Note] = []
    @Published var isSearchActive: Bool = false
    
    func performSearch(query: String, in notes: [Note]) -> [Note]
    func clearSearch()
}
```

### Navigation State
```swift
enum NavigationState {
    case categoryView(Category)
    case noteEditor(Note)
    case searchResults([Note])
}
```

## Error Handling

### Search Error Scenarios
- Empty search queries: Show all notes in current category
- No search results: Display "No notes found" message
- Search performance issues: Implement debounced search with 300ms delay

### Navigation Error Scenarios
- Close button pressed with unsaved changes: Follow existing auto-save behavior
- Category not found when closing note: Default to "General" category
- Invalid note state: Return to welcome screen

## Testing Strategy

### Unit Tests
- `NotePreviewCard`: Verify 5-line truncation behavior
- `SearchManager`: Test search algorithm accuracy and performance
- `NoteManager`: Test search methods with various query types

### Integration Tests
- Search functionality across multiple categories
- Close button navigation flow
- Real-time search performance with large note collections

### UI Tests
- Search bar interaction and results display
- Close button hover effects and click behavior
- Note preview card layout with extended content

## Performance Considerations

### Search Optimization
- Implement debounced search to avoid excessive filtering
- Cache search results for repeated queries
- Limit search to first 1000 characters of note body
- Use efficient string matching algorithms

### Memory Management
- Lazy loading of search results in grid view
- Proper cleanup of search state when switching categories
- Efficient preview text calculation

### Rendering Performance
- Maintain existing lazy loading in NotesGridView
- Optimize close button hover animations
- Preserve card layout performance with longer previews

## Accessibility

### Search Accessibility
- Proper accessibility labels for search field
- Voice-over support for search results
- Keyboard navigation through search results

### Close Button Accessibility
- Clear accessibility label: "Close note"
- Accessibility hint: "Returns to category view"
- Keyboard shortcut support (Cmd+W)

### Preview Card Accessibility
- Updated accessibility values with longer preview text
- Maintain existing accessibility labels and hints