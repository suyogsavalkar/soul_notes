# Project Structure

## Root Level
- `Package.swift` - Swift Package Manager configuration
- `note.xcodeproj/` - Xcode project files and workspace
- `note/` - Main application source code
- `noteTests/` - Unit test files
- `noteUITests/` - UI test files

## Main Application Structure (`note/`)

### Core Application
- `noteApp.swift` - App entry point (@main struct SoulApp)
- `ContentView.swift` - Legacy content view (not actively used)
- `note.entitlements` - App entitlements and permissions
- `Info.plist` - App configuration and font registration

### Models (`note/Models/`)
Data structures and business logic models:
- `Note.swift` - Core note model with Identifiable, Codable
- `Category.swift` - Category model with default categories
- `DataHelpers.swift` - Data manipulation utilities

### Views (`note/Views/`)
SwiftUI view components organized by functionality:
- `MainView.swift` - Primary app container view
- `NoteEditorView.swift` - Main note editing interface
- `SidebarView.swift` - Category navigation sidebar
- `NotesGridView.swift` - Grid display of notes
- `NotePreviewCard.swift` - Individual note preview cards
- `WelcomeView.swift` - First-time user experience
- `CategoryCreationView.swift` - Category management interface
- `SFSymbolPicker.swift` - Icon selection for categories
- `FocusLogView.swift` - Focus session history
- `FocusStatsView.swift` - Focus productivity statistics
- `FocusTimerControl.swift` - Timer interface controls
- `NoteReflectionView.swift` - AI reflection interface
- `CleanEditorLayout.swift` - Editor layout wrapper
- `EditorTopBar.swift` - Editor toolbar
- `ImprovedBodyEditor.swift` - Enhanced text editor
- `NaturalTextEditor.swift` - Natural text input handling
- `StableTitleField.swift` - Stable title input field
- `TooltipModifier.swift` - Tooltip UI modifier

### Services (`note/Services/`)
Business logic and state management:
- `NoteManager.swift` - Note CRUD operations
- `ThemeManager.swift` - Theme and appearance management
- `FontSizeManager.swift` - Font size preferences
- `FocusTimerManager.swift` - Focus session management
- `FocusManager.swift` - Focus state coordination
- `SaveStateManager.swift` - Auto-save functionality
- `ErrorHandler.swift` - Global error handling
- `EditorErrorHandler.swift` - Editor-specific error handling
- `AchievementScreenshotManager.swift` - Achievement system

### Extensions (`note/Extensions/`)
Swift extensions for enhanced functionality:
- `Font+DMSans.swift` - Custom font definitions
- `Color+Theme.swift` - Theme color extensions
- `DesignConstants.swift` - UI constants and measurements

### Utilities (`note/Utilities/`)
Helper classes and utility functions:
- `FontLoader.swift` - Custom font loading
- `PerformanceOptimizer.swift` - Performance optimization utilities
- `WordCountCalculator.swift` - Text analysis utilities

### Resources (`note/Resources/`)
Static assets and resources:
- `Fonts/` - DM Sans font family files (Regular, Medium, Bold, etc.)
- Multiple font weights and sizes (18pt, 24pt, 36pt variants)

### Assets (`note/Assets.xcassets/`)
- `AppIcon.appiconset/` - Application icon assets
- `AccentColor.colorset/` - App accent color definition
- `Contents.json` - Asset catalog configuration

## Naming Conventions

### Files
- **Views**: Descriptive names ending with "View" (e.g., `NoteEditorView.swift`)
- **Models**: Singular nouns (e.g., `Note.swift`, `Category.swift`)
- **Services**: Descriptive names ending with "Manager" (e.g., `ThemeManager.swift`)
- **Extensions**: Base type + functionality (e.g., `Font+DMSans.swift`)

### Code Organization
- **One class/struct per file** - Each Swift file contains a single primary type
- **Related functionality grouped** - Helper types and extensions in same file as primary type
- **Preview providers** - Each view file includes #Preview for SwiftUI previews
- **MARK comments** - Used to organize code sections within files

## Test Structure
- `noteTests/` - Unit tests mirroring main app structure
- `noteUITests/` - UI automation tests
- Test files follow naming pattern: `[ComponentName]Tests.swift`