# Technology Stack

## Build System & Platform
- **Swift Package Manager** - Primary build system (Package.swift)
- **Swift 5.9+** - Language version requirement
- **macOS 13.0+** - Minimum deployment target
- **Xcode Project** - Development environment with .xcodeproj structure

## Frameworks & Libraries
- **SwiftUI** - Primary UI framework for all views and components
- **Foundation** - Core system services and data types
- **Combine** - Reactive programming for state management (ThemeManager uses @Published)

## Architecture Patterns
- **MVVM** - Model-View-ViewModel pattern with ObservableObject classes
- **Environment Objects** - Shared state management (ThemeManager, FontSizeManager, FocusTimerManager)
- **State Management** - @State, @Binding, @StateObject for local component state
- **Service Layer** - Dedicated service classes for business logic (NoteManager, ErrorHandler, etc.)

## Custom Typography
- **DM Sans Font Family** - Custom font loaded from Resources/Fonts/
- Font variants: Regular, Medium, SemiBold, Bold
- Configured in Info.plist with UIAppFonts and ATSApplicationFontsPath

## Data Persistence
- **JSON Encoding/Decoding** - Custom encoders/decoders for Note and Category models
- **FileManager** - Local file system storage for notes and preferences
- **UserDefaults equivalent** - Theme preferences stored as JSON files

## Common Development Commands

### Building
```bash
# Build the project
swift build

# Run the executable
swift run
```

### Xcode Development
```bash
# Open project in Xcode
open note.xcodeproj

# Build and run from command line
xcodebuild -project note.xcodeproj -scheme note build
```

### Testing
```bash
# Run unit tests
swift test

# Run specific test target
xcodebuild test -project note.xcodeproj -scheme note -destination 'platform=macOS'
```

## Key Dependencies
- No external package dependencies - uses only system frameworks
- Custom font files bundled in Resources/Fonts/
- SF Symbols for iconography throughout the app