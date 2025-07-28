---
inclusion: always
---

# Architecture & Structure Guidelines

## File Organization

### Directory Structure (MVVM + Services Pattern)

- `Models/` - Data structs with `Codable`, `Identifiable`
- `Views/` - Pure SwiftUI components, no business logic
- `Services/` - `@ObservableObject` classes for state management
- `Extensions/` - Type extensions for shared functionality
- `Utilities/` - Pure helper functions and classes
- `Resources/` - Static assets (fonts, images)

### Naming Conventions

- **Views**: `[Feature][Component]View.swift` (e.g., `NoteEditorView.swift`)
- **Models**: `[Entity].swift` (e.g., `Note.swift`, `Category.swift`)
- **Services**: `[Feature]Manager.swift` (e.g., `NoteManager.swift`, `ThemeManager.swift`)
- **Extensions**: `[Type]+[Feature].swift` (e.g., `Color+Theme.swift`)

## Architecture Rules

### MVVM Implementation

- **Models**: Immutable `struct` with computed properties only
- **Views**: Pure SwiftUI, observe services via `@StateObject`/`@ObservedObject`
- **Services**: Act as ViewModels using `@Published` properties
- **State**: Use `@State` only for local UI state (toggles, text input)

### Data Flow

- Services own and mutate data via `@Published` properties
- Views observe services, never directly mutate models
- Pass data down, events up through the view hierarchy
- Use `@StateObject` for service ownership, `@ObservedObject` for injection

### Error Handling

- All user-facing errors through centralized `ErrorHandler` service
- Use `Result<T, Error>` for operations that can fail
- Provide fallback states, never crash the app

## Development Patterns

### Adding New Features

1. Create model in `Models/` if new data structure needed
2. Add/extend service in `Services/` for business logic
3. Create views in `Views/` that observe the service
4. Add reusable components to `Extensions/`
5. Write corresponding tests in `noteTests/`

### Performance Requirements

- Use `PerformanceOptimizer.debounce()` for text input (300ms)
- Implement lazy loading with `LazyVGrid` for large collections
- Cache expensive computations via `PerformanceOptimizer.cache()`
- Auto-save with debounced writes to prevent data loss

### Code Quality

- All public APIs must have explicit type annotations
- Use `// MARK:` comments to organize code sections
- Follow dependency injection pattern for testability
- Write unit tests for all service methods
