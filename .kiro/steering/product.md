---
inclusion: always
---

# Product Guidelines

This is a macOS note-taking application built with SwiftUI that emphasizes clean design, performance, and user experience.

## Core Product Principles

- **Simplicity First**: Prioritize clean, intuitive interfaces over feature complexity
- **Performance**: All operations should feel instant with proper caching and debouncing (300ms debounce for text input)
- **Consistency**: Maintain visual and interaction consistency across all views
- **Accessibility**: Follow macOS accessibility guidelines and support keyboard navigation

## Key Features & Implementation Rules

### Category System

- Notes organized by user-created categories with SF Symbol icons
- Use `SFSymbolPicker` for icon selection
- Categories stored as `Category` model with `Codable` persistence

### Layout & Navigation

- **Grid Layout**: Use `LazyVGrid` for note display with `NotePreviewCard` components
- **Split View**: `SidebarView` for categories, main area for `NotesGridView`/`NoteEditorView`
- **Responsive Design**: Adapt to window resizing with minimum 800x600 constraints

### Data Persistence

- **Auto-save**: Debounced saves (300ms) via `NoteManager.saveNote()`
- **File-based**: JSON storage using `FileManager` and `Codable`
- **Error Recovery**: Use `ErrorHandler` service for graceful failure handling

## Design System (Strict Requirements)

### Typography

- **Font Family**: DM Sans exclusively via `Font+DMSans` extension
- **Weights**: Regular (.regular), Medium (.medium), SemiBold (.semibold)
- **Usage**: Use `FontSizeManager` for dynamic sizing

### Colors

- **Accent**: Pastel orange `#FF9F7A` via `Color.Theme.accent`
- **Backgrounds**: System-adaptive via `Color.Theme` extension
- **Consistency**: Always use theme colors, never hardcoded values

### Spacing & Layout

- **Base Unit**: 16px for consistent padding/margins
- **Grid Spacing**: Use `DesignConstants` for standardized values
- **Window**: Default 1200x800, minimum 800x600

## Code Implementation Rules

### SwiftUI Patterns

- **Views**: Pure UI components, no business logic
- **State Management**: Use `@StateObject` for service ownership, `@ObservedObject` for injection
- **Services**: `NoteManager`, `ThemeManager`, etc. as `@ObservableObject` classes
- **Performance**: Use `PerformanceOptimizer.debounce()` for text input

### Error Handling

- All user-facing errors through `ErrorHandler` service
- Never crash - provide fallback states and recovery options
- Use `Result<T, Error>` for operations that can fail

### Data Safety

- Atomic file operations to prevent corruption
- Auto-backup before destructive operations
- Graceful degradation when data files are corrupted

## User Experience Standards

### Interaction Feedback

- Hover states for all interactive elements
- Visual feedback for selections and state changes
- Loading states for any operation > 100ms

### Keyboard Navigation

- Full keyboard support for all features
- Standard macOS shortcuts (Cmd+N, Cmd+S, etc.)
- Tab navigation through UI elements

### Performance Targets

- UI response time: < 100ms for all interactions
- Text input debouncing: 300ms
- Large collections: Use lazy loading with `LazyVGrid`
