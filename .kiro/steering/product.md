---
inclusion: always
---

# Product Guidelines

This is a macOS note-taking application built with SwiftUI that emphasizes clean design, performance, and user experience.

## Core Product Principles

- **Simplicity First**: Prioritize clean, intuitive interfaces over feature complexity
- **Performance**: All operations should feel instant with proper caching and debouncing
- **Consistency**: Maintain visual and interaction consistency across all views
- **Accessibility**: Follow macOS accessibility guidelines and support keyboard navigation

## Key Features & Behavior

- **Category Organization**: Notes are organized by user-created categories with SF Symbol icons
- **Grid Layout**: Notes display in responsive grid with preview cards showing title and snippet
- **Split View Navigation**: Sidebar for categories, main area for note grid/editor
- **Live Editing**: Changes save automatically with debounced persistence
- **Error Recovery**: Graceful handling of data corruption or file system issues

## Design Standards

- **Typography**: DM Sans font family exclusively (Regular, Medium, SemiBold weights)
- **Color Palette**: Pastel orange accent (#FF9F7A) with system-adaptive backgrounds
- **Spacing**: Consistent 16px base unit for padding and margins
- **Window Constraints**: Min 800x600, default 1200x800, content-driven resizing

## User Experience Requirements

- **Responsive Feedback**: Visual feedback for all user actions (hover states, selections)
- **Keyboard Support**: Full keyboard navigation and shortcuts
- **Data Safety**: Auto-save with conflict resolution, no data loss scenarios
- **Performance**: Sub-100ms response times for all UI interactions

## Technical Constraints

- **macOS Only**: Leverage macOS-specific features and design patterns
- **Local Storage**: File-based persistence, no cloud dependencies
- **Memory Efficiency**: Lazy loading for large note collections
- **SwiftUI Native**: Use SwiftUI patterns, avoid UIKit bridging unless necessary
