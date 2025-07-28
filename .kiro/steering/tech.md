---
inclusion: always
---

# Technical Implementation Guidelines

## Technology Stack

- **SwiftUI + Swift 5.9+** for macOS 13.0+ target
- **MVVM + Services architecture** with dependency injection
- **File-based JSON persistence** using `Codable`

## Critical Architecture Rules

### MVVM Pattern (Strict)

- **Models**: `struct` with `Codable, Identifiable` - data only, no logic
- **Views**: Pure SwiftUI - observe services, never mutate data directly
- **Services**: `@ObservableObject` classes - all business logic and state
- **Binding**: `@StateObject` for ownership, `@ObservedObject` for injection

### Property Wrapper Usage

```swift
@State          // Local UI state only (toggles, text fields)
@StateObject    // Service ownership in root views
@ObservedObject // Service injection in child views
@Published      // Observable data in services
@AppStorage     // User preferences only
```

### Service Layer Requirements

- All business logic in Services (`NoteManager`, `ThemeManager`, etc.)
- Services communicate via `@Published` properties
- Use `ErrorHandler` service for centralized error handling
- Implement dependency injection for testability

## Code Patterns (Required)

### Data Models

```swift
struct Note: Codable, Identifiable {
    let id: UUID
    var title: String
    var content: String
    // Computed properties only - no methods
}
```

### Service Classes

```swift
class NoteManager: ObservableObject {
    @Published var notes: [Note] = []

    func saveNote(_ note: Note) -> Result<Void, NoteError> {
        // Use Result type for operations that can fail
    }
}
```

### Error Handling

- Use `Result<T, Error>` for failable operations
- Handle all errors through `ErrorHandler` service
- Never crash - provide fallback states

## Performance Requirements

### Text Input & Auto-Save

- Use `PerformanceOptimizer.debounce()` with 300ms delay
- Auto-save with debounced writes to prevent data loss
- Atomic file operations to prevent corruption

### UI Performance

- Use `LazyVGrid` for large collections, never `VStack`
- Cache expensive computations via `PerformanceOptimizer.cache()`
- Implement lazy loading for large datasets

## Code Quality Standards

### Required Practices

- Explicit type annotations for all public APIs
- `// MARK:` comments to organize code sections
- Unit tests for all service methods
- Follow Swift naming conventions strictly

### File Organization

- Models in `Models/` - data structures only
- Views in `Views/` - pure SwiftUI components
- Services in `Services/` - business logic and state
- Extensions in `Extensions/` - shared functionality

## Build Commands

```bash
# Build and test
xcodebuild -project note.xcodeproj -scheme note build
xcodebuild test -project note.xcodeproj -scheme note -destination 'platform=macOS'
```
