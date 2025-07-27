---
inclusion: always
---

# Technology Stack & Development Guidelines

## Core Technologies

- **SwiftUI** - Primary UI framework for all views and components
- **Swift 5.9+** - Programming language with modern concurrency support
- **macOS 13.0+** - Target platform with native system integration
- **Xcode 15+** - Required development environment

## Architecture Requirements

### MVVM Pattern Implementation

- **Models**: Use `struct` with `Codable` and `Identifiable` protocols
- **Views**: Pure SwiftUI components, no business logic
- **Services**: Act as ViewModels using `@ObservableObject` and `@Published`
- **Data Binding**: Use `@StateObject` for ownership, `@ObservedObject` for injection

### Service Layer Pattern

- All business logic resides in Services (e.g., `NoteManager`, `ThemeManager`)
- Services communicate via `@Published` properties and Combine publishers
- Use dependency injection for testability
- Centralize error handling through `ErrorHandler` service

### Data Persistence

- File-based JSON storage using `FileManager` and `Codable`
- Auto-save with debounced writes (300ms delay)
- Atomic file operations to prevent data corruption
- Graceful fallback for corrupted data files

## Code Style Rules

### SwiftUI Conventions

```swift
// ✅ Correct: Explicit types for public APIs
@Published var notes: [Note] = []

// ✅ Correct: Struct for data models
struct Note: Codable, Identifiable {
    let id: UUID
    var title: String
    var content: String
}

// ✅ Correct: Observable service class
class NoteManager: ObservableObject {
    @Published var notes: [Note] = []
}
```

### Property Wrapper Usage

- `@State` - Local UI state only (toggles, text input)
- `@StateObject` - Service ownership in root views
- `@ObservedObject` - Service injection in child views
- `@Published` - Observable data in services
- `@AppStorage` - User preferences and settings

### Error Handling Pattern

```swift
// ✅ Use Result type for operations that can fail
func saveNote(_ note: Note) -> Result<Void, NoteError> {
    // Implementation
}

// ✅ Handle errors gracefully in UI
.onReceive(noteManager.errorPublisher) { error in
    errorHandler.handle(error)
}
```

## Performance Guidelines

- Use `PerformanceOptimizer.debounce()` for text input (300ms)
- Implement lazy loading for large collections
- Cache expensive computations using `PerformanceOptimizer.cache()`
- Prefer `LazyVGrid` over `VStack` for large datasets

## Development Commands

### Build & Test

```bash
# Build project
xcodebuild -project note.xcodeproj -scheme note build

# Run all tests
xcodebuild test -project note.xcodeproj -scheme note -destination 'platform=macOS'

# Run specific test suite
xcodebuild test -project note.xcodeproj -scheme note -only-testing:noteTests
```

### Code Quality

- All public APIs must have explicit type annotations
- Use `// MARK:` comments to organize code sections
- Follow Swift naming conventions strictly
- Write unit tests for all service methods
