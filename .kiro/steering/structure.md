---
inclusion: always
---

# Project Structure & Architecture Guidelines

## Directory Structure Rules

### Core Layers (MVVM + Services)

- **Models/**: Data structures only - use `struct` with `Codable`, `Identifiable`
- **Views/**: SwiftUI views following single responsibility principle
- **Services/**: Business logic with `@ObservableObject` for state management
- **Extensions/**: Type extensions for shared functionality
- **Utilities/**: Pure functions and helper classes
- **Resources/**: Static assets (fonts, images)

### File Placement Rules

- Place new views in `Views/` with descriptive names ending in "View"
- Data models go in `Models/` as structs with clear property types
- Business logic belongs in `Services/` as observable classes
- UI extensions go in `Extensions/` using Type+Feature naming
- Helper utilities go in `Utilities/` as standalone classes/structs

## Naming Conventions (Strictly Enforced)

### SwiftUI Views

- **Format**: `[Feature][Component]View.swift`
- **Examples**: `NoteEditorView`, `CategoryCreationView`, `SFSymbolPicker`
- **Rule**: Always end with "View" for UI components

### Data Models

- **Format**: `[Entity].swift` (singular noun)
- **Examples**: `Note.swift`, `Category.swift`
- **Rule**: Use `struct` with `Codable`, `Identifiable` protocols

### Services & Managers

- **Format**: `[Feature]Manager.swift` or `[Feature]Handler.swift`
- **Examples**: `NoteManager`, `ErrorHandler`, `ThemeManager`
- **Rule**: Use `class` with `@ObservableObject` for state management

### Extensions

- **Format**: `[Type]+[Feature].swift`
- **Examples**: `Color+Theme.swift`, `Font+DMSans.swift`
- **Rule**: Group related extensions by feature, not by type

## Architecture Patterns

### MVVM Implementation

- **Views**: Pure SwiftUI, no business logic
- **ViewModels**: Embedded in Services (NoteManager acts as ViewModel)
- **Models**: Simple data structures with computed properties only
- **Binding**: Use `@StateObject`, `@ObservedObject`, `@Published`

### Data Flow Rules

- Services own and mutate data via `@Published` properties
- Views observe services via `@StateObject` or `@ObservedObject`
- Models are immutable structs passed between layers
- Use `@State` only for local UI state (toggles, text fields)

### Error Handling Pattern

- All services use centralized `ErrorHandler` for user-facing errors
- Throw specific error types, handle gracefully in UI
- Never crash - always provide fallback states

## Code Organization Rules

### When Adding New Features

1. Create model in `Models/` if new data structure needed
2. Add business logic to existing service or create new one in `Services/`
3. Create views in `Views/` that observe the service
4. Add extensions in `Extensions/` for reusable UI components
5. Write tests in parallel structure under `noteTests/`

### File Dependencies

- Models: No dependencies (pure data)
- Views: Can import Models and Services only
- Services: Can import Models and other Services
- Extensions: Can import Models, avoid importing Services
- Utilities: No dependencies on app-specific code

### Performance Guidelines

- Use `PerformanceOptimizer` for caching and debouncing
- Lazy load large collections in views
- Debounce text input with 300ms delay
- Cache computed properties that are expensive
