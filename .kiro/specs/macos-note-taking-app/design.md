# Design Document

## Overview

This design document outlines the architecture and implementation approach for a macOS note-taking application built with SwiftUI. The app follows a sidebar-based navigation pattern with a grid view for note previews and a focused editing interface. The design emphasizes local data persistence, responsive layout, and a clean visual hierarchy using the specified design system.

## Architecture

### Application Structure

The app follows the MVVM (Model-View-ViewModel) architecture pattern, which is well-suited for SwiftUI applications:

- **Models**: Data structures for Note, Category, and related entities
- **Views**: SwiftUI views for different screens and components
- **ViewModels**: ObservableObject classes that manage state and business logic
- **Services**: Data persistence and file management utilities

### Core Components

1. **Main App Structure**: Uses `WindowGroup` with a single main window
2. **Navigation**: `NavigationSplitView` for sidebar and main content areas
3. **Data Layer**: Core Data or JSON-based local storage for note persistence
4. **State Management**: Combine framework with `@StateObject` and `@ObservableObject`

## Components and Interfaces

### 1. Main Application View (`MainView`)

**Purpose**: Root view that orchestrates the entire application layout

**Key Features**:
- Implements `NavigationSplitView` with sidebar and detail views
- Manages global app state and navigation
- Handles sidebar visibility toggle

**Interface**:
```swift
struct MainView: View {
    @StateObject private var noteManager: NoteManager
    @State private var selectedCategory: Category?
    @State private var selectedNote: Note?
    @State private var showingSidebar: Bool = true
}
```

### 2. Sidebar View (`SidebarView`)

**Purpose**: Displays categorized navigation for note organization

**Key Features**:
- Lists all available categories with custom SF Symbol icons
- Highlights selected category
- Supports category selection and navigation
- Includes "Add new Space" button with category creation flow
- Features dark mode toggle at the bottom
- Shows "Soul" as the main section title instead of "Notes"
- No divider lines below "Soul" or above "Add new space" for cleaner design
- Displays focus statistics below "Add new space" option
- Shows focus time and distractions avoided with clickable navigation to logs

**Interface**:
```swift
struct SidebarView: View {
    @Binding var selectedCategory: Category?
    let categories: [Category]
    let onCategorySelect: (Category) -> Void
    let onCategoryAdd: (String, String) -> Void
    let onCategoryDelete: (Category) -> Void
    let onFocusStatsClick: () -> Void
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var focusTimerManager: FocusTimerManager
}
```

### 3. Notes Grid View (`NotesGridView`)

**Purpose**: Displays notes in a responsive grid layout with previews

**Key Features**:
- Adaptive grid layout using `LazyVGrid` with square cards
- Note preview cards with title and body truncation
- Responsive design that adapts to window size
- Notes ordered by date updated (most recent first)
- Smaller, more compact card design for better density

**Interface**:
```swift
struct NotesGridView: View {
    let notes: [Note]
    let onNoteSelect: (Note) -> Void
    @State private var gridColumns: [GridItem]
    
    var sortedNotes: [Note] {
        notes.sorted { $0.modifiedAt > $1.modifiedAt }
    }
}
```

### 4. Note Preview Card (`NotePreviewCard`)

**Purpose**: Individual note preview component for grid display

**Key Features**:
- Displays note title (truncated if necessary)
- Shows preview of note body content
- Square-shaped cards with reduced size for compact grid layout
- Includes delete functionality with trash icon in bottom right (moved from bottom left)
- Date display in bottom left corner
- Supports theme-aware styling for light/dark modes

**Interface**:
```swift
struct NotePreviewCard: View {
    let note: Note
    let onTap: () -> Void
    let onDelete: () -> Void
    @EnvironmentObject var themeManager: ThemeManager
}
```

### 5. Note Editor View (`NoteEditorView`)

**Purpose**: Full-screen note editing interface

**Key Features**:
- Title field with 32px font size (updated from 24px)
- Body text editor with dynamic font size (16px default, user-adjustable)
- Centered content with appropriate padding
- Auto-save detection and save button
- Font size control integration
- Focus timer integration with typing detection
- Single-line title with overflow prevention

**Interface**:
```swift
struct NoteEditorView: View {
    @Binding var note: Note
    @State private var hasUnsavedChanges: Bool = false
    @State private var lastTypingTime: Date = Date()
    let onSave: () -> Void
    let onToggleSidebar: () -> Void
    @EnvironmentObject var fontSizeManager: FontSizeManager
    @EnvironmentObject var focusTimerManager: FocusTimerManager
}
```

### 6. Note Manager (`NoteManager`)

**Purpose**: Central data management and business logic

**Key Features**:
- CRUD operations for notes and categories
- Local data persistence
- Change detection for auto-save functionality
- Category management with custom icons

**Interface**:
```swift
class NoteManager: ObservableObject {
    @Published var notes: [Note] = []
    @Published var categories: [Category] = []
    
    func createNote(in category: Category) -> Note
    func updateNote(_ note: Note)
    func deleteNote(_ note: Note)
    func createCategory(name: String, iconName: String) -> Category
    func deleteCategory(_ category: Category)
    func saveChanges()
    func loadData()
}
```

### 7. Theme Manager (`ThemeManager`)

**Purpose**: Manages application-wide theme state and preferences

**Key Features**:
- Dark/light mode toggle functionality
- Theme persistence across app launches
- Centralized color and styling management

**Interface**:
```swift
class ThemeManager: ObservableObject {
    @Published var isDarkMode: Bool = false
    
    var backgroundColor: Color { isDarkMode ? Color(hex: "171717") : .white }
    var textColor: Color { isDarkMode ? .white : .black }
    var accentColor: Color { Color(red: 1.0, green: 0.8, blue: 0.6) }
    
    func toggleTheme()
    func saveThemePreference()
    func loadThemePreference()
}
```

### 8. Category Creation View (`CategoryCreationView`)

**Purpose**: Modal interface for creating new categories with icon selection

**Key Features**:
- Text field for category name input
- SF Symbol icon picker with search functionality
- Grid-based icon selection interface
- Real-time icon search filtering

**Interface**:
```swift
struct CategoryCreationView: View {
    @Binding var isPresented: Bool
    let onCategoryCreate: (String, String) -> Void
    @State private var categoryName: String = ""
    @State private var selectedIcon: String = "folder"
    @State private var searchText: String = ""
}
```

### 9. SF Symbol Picker (`SFSymbolPicker`)

**Purpose**: Searchable grid interface for selecting SF Symbol icons

**Key Features**:
- Comprehensive SF Symbol library display
- Real-time search filtering
- Grid-based selection interface
- Preview of selected icon

**Interface**:
```swift
struct SFSymbolPicker: View {
    @Binding var selectedIcon: String
    @Binding var searchText: String
    let availableIcons: [String]
    
    var filteredIcons: [String] {
        // Filter icons based on search text
    }
}
```

### 10. Font Size Manager (`FontSizeManager`)

**Purpose**: Manages user font size preferences and cycling functionality

**Key Features**:
- Font size preference persistence
- Cycling through predefined font sizes (16px → 18px → 22px → 24px → 16px)
- Global font size application across all notes

**Interface**:
```swift
class FontSizeManager: ObservableObject {
    @Published var currentBodyFontSize: CGFloat = 16
    private let fontSizes: [CGFloat] = [16, 18, 22, 24]
    
    func cycleFontSize()
    func saveFontPreference()
    func loadFontPreference()
}
```

### 11. Focus Timer Manager (`FocusTimerManager`)

**Purpose**: Manages focus timer functionality, session tracking, and distraction logging

**Key Features**:
- Timer countdown with 5 and 10 minute options
- App focus detection and alerts
- Typing activity monitoring
- Session and distraction logging with persistence

**Interface**:
```swift
class FocusTimerManager: ObservableObject {
    @Published var isTimerRunning: Bool = false
    @Published var remainingTime: TimeInterval = 600 // 10 minutes default
    @Published var selectedDuration: TimeInterval = 600
    @Published var focusStats: FocusStats = FocusStats()
    
    func startTimer(duration: TimeInterval)
    func stopTimer()
    func pauseTimer()
    func handleFocusLoss()
    func handleTypingPause()
    func logDistraction(reason: String?)
    func logSessionEnd()
    func calculateStats() -> FocusStats
}
```

### 12. Focus Statistics View (`FocusStatsView`)

**Purpose**: Displays focus session statistics and navigation to detailed logs

**Key Features**:
- Summary display of total focus time and distractions avoided
- Navigation to detailed focus log
- Integration with sidebar layout

**Interface**:
```swift
struct FocusStatsView: View {
    let focusStats: FocusStats
    let onTapStats: () -> Void
    @EnvironmentObject var themeManager: ThemeManager
}
```

### 13. Focus Log View (`FocusLogView`)

**Purpose**: Simplified single-window view for distraction statistics and logging

**Key Features**:
- Comprehensive distraction statistics display with bold numbers
- Total, weekly, and monthly distraction counts
- Chronological list of distractions with date, time, and reason
- Achievement sharing functionality with hover interactions
- Properly sized window for comfortable viewing

**Interface**:
```swift
struct FocusLogView: View {
    let distractionStats: DistractionStats
    let distractionLogs: [DistractionLogEntry]
    @State private var hoveredStat: StatType? = nil
    @EnvironmentObject var themeManager: ThemeManager
    
    func shareAchievement(for statType: StatType)
    func generateAchievementImage(for statType: StatType) -> NSImage
}
```

### 14. Welcome View Enhancement (`WelcomeView`)

**Purpose**: Enhanced create note card that maintains visual consistency

**Key Features**:
- Square card dimensions matching regular note cards
- Consistent styling and padding with note preview cards
- Clear visual hierarchy with "+" icon and descriptive text
- Proper grid alignment without compression

**Interface**:
```swift
struct WelcomeView: View {
    let onCreateNote: () -> Void
    @EnvironmentObject var themeManager: ThemeManager
    
    var cardDimensions: CGSize {
        // Matches NotePreviewCard dimensions exactly
    }
}
```

### 15. Note Reflection Modal (`NoteReflectionView`)

**Purpose**: Modal dialog for AI-assisted note reflection and analysis

**Key Features**:
- Large modal dialog with note content display
- Scrollable text area for long note content
- Copy to clipboard functionality for note content
- Direct ChatGPT integration with browser opening
- Proper modal sizing and responsive layout

**Interface**:
```swift
struct NoteReflectionView: View {
    let noteTitle: String
    let noteContent: String
    @Binding var isPresented: Bool
    @EnvironmentObject var themeManager: ThemeManager
    
    func copyToClipboard()
    func openChatGPT()
}
```

### 16. Distraction Log Export Manager (`DistractionExportManager`)

**Purpose**: Handles export of distraction logs for AI analysis

**Key Features**:
- Text file generation with formatted distraction data
- Date, time, and reason formatting for readability
- File download to user's Downloads folder with proper permissions
- Success feedback and ChatGPT navigation integration

**Interface**:
```swift
class DistractionExportManager: ObservableObject {
    func exportDistractionLogs(_ logs: [DistractionLogEntry]) -> Result<URL, Error>
    func formatLogEntry(_ entry: DistractionLogEntry) -> String
    func showExportSuccess()
}
```

## Data Models

### Note Model

```swift
struct Note: Identifiable, Codable {
    let id: UUID
    var title: String
    var body: String
    var categoryId: UUID
    var createdAt: Date
    var modifiedAt: Date
    
    var preview: String {
        // Returns truncated body text for grid preview
    }
}
```

### Category Model

```swift
struct Category: Identifiable, Codable {
    let id: UUID
    var name: String
    var iconName: String  // SF Symbol name
    var color: Color
    var createdAt: Date
    
    static let defaultCategories: [Category] = [
        Category(name: "General", iconName: "folder", color: .orange),
        Category(name: "Work", iconName: "briefcase", color: .blue),
        Category(name: "Personal", iconName: "person", color: .green)
    ]
}
```

### Theme Preference Model

```swift
struct ThemePreference: Codable {
    var isDarkMode: Bool = false
    var lastUpdated: Date = Date()
}
```

### Font Size Preference Model

```swift
struct FontSizePreference: Codable {
    var bodyFontSize: CGFloat = 16
    var titleFontSize: CGFloat = 32
    var lastUpdated: Date = Date()
}
```

### Focus Session Models

```swift
struct DistractionLogEntry: Identifiable, Codable {
    let id: UUID
    let timestamp: Date
    let distractionType: DistractionType
    let reason: String
    let wasAvoided: Bool
}

enum DistractionType: String, Codable, CaseIterable {
    case tabChange = "tab_change"
    case customReason = "custom_reason"
    case focusLoss = "focus_loss"
}

struct DistractionStats: Codable {
    var totalDistractionsAvoided: Int = 0
    var weeklyDistractionsAvoided: Int = 0
    var monthlyDistractionsAvoided: Int = 0
    var lastUpdated: Date = Date()
    
    mutating func updateWeeklyCount() {
        // Calculate distractions avoided in last 7 days
    }
    
    mutating func updateMonthlyCount() {
        // Calculate distractions avoided in last 30 days
    }
}

enum StatType: CaseIterable {
    case total, weekly, monthly
    
    var displayName: String {
        switch self {
        case .total: return "Total distractions avoided"
        case .weekly: return "Distractions avoided in last 7 days"
        case .monthly: return "Distractions avoided in last 30 days"
        }
    }
}
```
```

### Local Storage Structure

Notes will be stored in the user's Documents directory in a structured format:

```
~/Documents/Solo/
├── notes.json          // All notes data
├── categories.json     // Categories configuration with custom icons
├── theme-settings.json // Theme preferences (dark/light mode)
├── font-settings.json  // Font size preferences
├── focus-logs.json     // Focus session logs and events
├── focus-stats.json    // Aggregated focus statistics
└── app-settings.json   // Other app preferences
```

### Export and Download Structure

Exported files will be saved to appropriate system directories:

```
~/Downloads/
├── solo-distraction-logs-[timestamp].txt  // Exported distraction logs
└── solo-achievement-[type]-[timestamp].png // Achievement sharing images
```

## Error Handling

### File System Operations

- **File Read Errors**: Graceful fallback to empty state with user notification
- **File Write Errors**: Retry mechanism with user feedback
- **Disk Space Issues**: Warning notifications with cleanup suggestions

### Data Validation

- **Invalid JSON**: Data recovery attempts with backup restoration
- **Corrupted Notes**: Individual note recovery with content preservation
- **Missing Categories**: Automatic default category creation

### User Experience

- **Auto-save Failures**: Persistent retry with visual feedback
- **Large Note Content**: Performance optimization with text chunking
- **Memory Issues**: Lazy loading and content pagination

### New Feature Error Handling

- **Note Deletion**: Confirmation dialogs to prevent accidental deletion
- **Category Deletion**: Handle notes in deleted categories by moving to default category
- **Theme Switching**: Graceful fallback if theme preferences fail to load
- **Icon Selection**: Fallback to default folder icon if selected SF Symbol is unavailable
- **Category Creation**: Validation for duplicate names and empty fields
- **Font Size Persistence**: Fallback to default 16px if font preferences fail to load
- **Focus Timer**: Handle system sleep/wake cycles and app termination during active sessions
- **Focus Logging**: Graceful handling of log file corruption with backup restoration
- **App Focus Detection**: Fallback mechanisms if NSApplication focus notifications fail
- **Timer Alerts**: Error handling for macOS alert system failures

### Critical UI Fix Error Handling

- **Title Positioning**: Fallback layout constraints if title field positioning fails
- **Cursor Placement**: Default to end-of-text if click position detection fails
- **File Permissions**: Graceful handling of Downloads folder permission issues
- **Modal Presentation**: Error handling for modal dialog presentation failures
- **Clipboard Operations**: Fallback behavior if clipboard access is denied
- **Browser Opening**: Error handling if default browser cannot be opened
- **Logo Integration**: Fallback to default icon if custom logo files are missing

### Issue-Specific Error Handling

- **Create Note Card**: Fallback dimensions if layout calculations fail
- **Title Character Limit**: Graceful truncation if limit enforcement fails
- **Cursor Positioning**: Fallback to end-of-text if click position detection fails
- **Sidebar Metrics**: Default positioning if layout constraints fail
- **Window-Aware Alerts**: Fallback to app window if current window detection fails
- **Distraction Recording**: Data validation for log entries and statistics
- **Achievement Sharing**: Error handling for image generation and file system operations
- **Timer Adjustments**: Validation for timer duration changes and state management

## Testing Strategy

### Unit Tests

1. **Note Manager Tests**
   - CRUD operations validation
   - Data persistence verification
   - Change detection accuracy

2. **Data Model Tests**
   - JSON serialization/deserialization
   - Data validation rules
   - Preview text generation

3. **File System Tests**
   - Local storage operations
   - Error handling scenarios
   - Data migration testing

### Integration Tests

1. **View Integration**
   - Navigation flow testing
   - State synchronization verification
   - UI responsiveness validation

2. **Data Flow Tests**
   - End-to-end note creation/editing
   - Category switching functionality
   - Auto-save behavior verification

### UI Tests

1. **User Interaction Tests**
   - Sidebar navigation
   - Note selection and editing
   - Grid view responsiveness

2. **Visual Regression Tests**
   - Font and color consistency
   - Layout adaptation testing
   - Animation smoothness verification

## Design System Implementation

### Typography

- **Primary Font**: DM Sans (imported via custom font files)
- **Title Size**: 24px for note titles
- **Body Size**: 12px for note content
- **UI Elements**: System default sizes with DM Sans family

### Color Palette

```swift
extension Color {
    // Light mode colors
    static let lightBackground = Color.white
    static let lightText = Color.black
    
    // Dark mode colors  
    static let darkBackground = Color(hex: "171717") // Matte black
    static let darkText = Color.white
    
    // Shared colors
    static let noteAccent = Color(red: 1.0, green: 0.8, blue: 0.6) // Pastel orange
    static let subtleDivider = Color.gray.opacity(0.3) // Muted grayish divider
    
    // Theme-aware computed properties
    static func backgroundColor(for isDarkMode: Bool) -> Color {
        isDarkMode ? darkBackground : lightBackground
    }
    
    static func textColor(for isDarkMode: Bool) -> Color {
        isDarkMode ? darkText : lightText
    }
}
```

### Iconography

- **Icon System**: SF Symbols exclusively
- **Sidebar Toggle**: `sidebar.left` symbol
- **Categories**: User-selectable SF Symbols with search functionality
- **Actions**: Standard SF Symbols for save, edit, delete operations
- **Delete Action**: `trash` symbol in bottom left of note cards
- **Add Category**: `plus` symbol for "Add new Space" button
- **Dark Mode Toggle**: `moon.fill` and `sun.max.fill` symbols
- **Category Management**: `trash` for category deletion with confirmation

### Layout Specifications

- **Sidebar Width**: 250px (fixed)
- **Grid Spacing**: 12px between cards (reduced for compact layout)
- **Card Dimensions**: Square aspect ratio with reduced overall size
- **Card Padding**: 10px internal padding (reduced for compact design)
- **Editor Padding**: 40px left/right margins
- **Content Max Width**: 800px for optimal readability
- **Delete Icon**: 16x16px in bottom right corner of note cards with 8px margin
- **Date Display**: Bottom left corner of note cards with 8px margin
- **Category Icons**: 16x16px next to category names in sidebar
- **Dark Mode Toggle**: 20x20px at bottom of sidebar with 12px padding
- **Add Category Button**: Full width at bottom of sidebar with 8px vertical padding
- **Focus Statistics**: Below "Add new space" with 12px vertical spacing
- **Font Size Indicator**: 20x20px near sidebar toggle with current size display
- **Focus Timer**: 24x24px watch icon with countdown display
- **Control Bar**: Horizontal layout for sidebar toggle, font size, and timer controls
- **No Divider Lines**: Removed from below "Soul" and above "Add new space"

## Performance Considerations

### Memory Management

- **Lazy Loading**: Grid views load notes on-demand
- **Text Truncation**: Efficient preview generation
- **Image Caching**: If note attachments are added later

### Responsiveness

- **Debounced Auto-save**: 500ms delay after typing stops
- **Smooth Animations**: 0.3s duration for sidebar transitions
- **Grid Adaptation**: Dynamic column count based on window width

### Storage Optimization

- **Incremental Saves**: Only modified notes are written to disk
- **Compression**: JSON minification for storage efficiency
- **Backup Strategy**: Automatic backup creation before major changes

## New Feature Implementation Details

### SF Symbol Integration

The app will include a comprehensive SF Symbol picker that allows users to select icons for their categories. The implementation will:

- Load available SF Symbols from a curated list of appropriate icons
- Provide real-time search functionality to filter icons by name
- Display icons in a responsive grid layout
- Support both light and dark mode rendering of symbols

### Category Management Flow

1. **Category Creation**:
   - User clicks "Add new Space" button in sidebar
   - Modal presents with name field and icon picker
   - User types category name and selects SF Symbol
   - Category is created and added to sidebar

2. **Category Deletion**:
   - Long press or right-click on category reveals delete option
   - Confirmation dialog prevents accidental deletion
   - Notes in deleted category are moved to "General" category
   - Category is removed from sidebar and storage

### Dark Mode Implementation

The dark mode system will use environment-based theme management:

- `ThemeManager` as an `EnvironmentObject` accessible throughout the app
- Automatic color adaptation for all UI elements
- Persistent theme preference storage
- Smooth transitions when switching themes

### Note Deletion Flow

1. **Delete Trigger**: User clicks trash icon on note card (now in bottom right)
2. **Confirmation**: Alert dialog asks for deletion confirmation
3. **Deletion**: Note is removed from storage and UI updates
4. **Feedback**: Grid view animates the removal of the deleted note

### Font Size Management System

The font size system provides user-customizable text sizing:

- **Font Size Cycling**: 16px → 18px → 22px → 24px → 16px for body text
- **Persistent Preferences**: Font size choice saved and applied across all notes
- **Visual Indicator**: Current font size displayed near sidebar toggle
- **Global Application**: Selected font size applies to all notes consistently

### Focus Timer System

The focus timer helps users maintain concentration during writing sessions:

1. **Timer Setup**:
   - Watch icon displayed near sidebar toggle and font size controls
   - Default 10-minute timer with option to change to 5 minutes
   - Timer starts when user selects duration

2. **Focus Loss Detection**:
   - System monitors app focus state using NSApplication notifications
   - When user switches apps/tabs during active timer, macOS alert appears
   - Alert shows remaining time and offers "Return" or "Cancel" options

3. **Typing Activity Monitoring**:
   - System tracks typing activity in note editor
   - After 15 seconds of no typing, "You stopped typing" prompt appears
   - User can choose "I am thinking" or "I was distracted"
   - Distraction option leads to optional reason input and session management

4. **Session Logging**:
   - All focus events logged with timestamps
   - Events include: session start/end, focus loss, typing pauses, distractions
   - Logs stored persistently and accessible through sidebar statistics

### Focus Statistics Integration

Focus statistics are integrated into the sidebar for easy access:

- **Statistics Display**: Shows total focus hours and distractions avoided
- **Visual Integration**: Positioned below dark/light mode toggle with appropriate icons
- **Navigation**: Clicking statistics opens detailed focus log view
- **Real-time Updates**: Statistics update as focus sessions progress

### UI Refinements and Layout Changes

- **Sidebar Cleanup**: Removed divider lines below "Soul" and above "Add new space"
- **Square Note Cards**: Changed from rectangular to square shape with reduced size
- **Note Ordering**: Notes sorted by modification date (most recent first)
- **Card Layout**: Trash icon moved to bottom right, date to bottom left
- **Title Constraints**: Note titles restricted to single line with overflow prevention
- **Font Size Updates**: Title increased to 32px, body default to 16px (user-adjustable)

### New Issue Resolutions

#### Create Note Card Consistency

The create note option will be redesigned to match the visual consistency of regular note cards:

- **Square Dimensions**: Create note card uses identical dimensions to regular note cards
- **Consistent Styling**: Same padding, border radius, and visual treatment as note cards
- **Proper Layout**: Prevents card compression and maintains grid alignment
- **Visual Hierarchy**: Clear "+" icon and "Create Note" text with proper spacing

#### Note Title Improvements

The note title editing experience will be enhanced for better usability:

- **Fixed Positioning**: Title field maintains consistent position regardless of cursor placement
- **Semibold Typography**: Title uses semibold font weight for improved visual hierarchy
- **Character Limit**: Hard limit of 45 characters with input prevention beyond limit
- **Stable Layout**: No vertical movement when focusing or editing title field

#### Note Body Cursor Management

The note body text editing will support natural cursor placement and editing:

- **Click-to-Position**: Cursor placement at exact click location within text
- **Maintain Position**: Cursor stays at insertion point during typing
- **Natural Editing**: Text insertion at cursor position without automatic repositioning
- **Selection Support**: Proper text selection and editing at any position in the body

#### Sidebar Layout Reorganization

The sidebar will be reorganized for better information hierarchy:

- **Metrics Positioning**: Focus and distraction metrics moved below dark/light mode toggle
- **Consistent Styling**: Metrics use same visual treatment as other sidebar elements
- **Proper Alignment**: Metrics align with sidebar content and maintain proper spacing
- **Clear Hierarchy**: Logical flow from categories to controls to metrics

#### Enhanced Focus System

The focus system will be redesigned for less intrusive operation:

- **Window-Aware Alerts**: Focus alerts appear on the user's current window, not the app window
- **Extended Timer**: Typing detection timer increased from 15 seconds to 1 minute
- **Smart Timer Reset**: Timer only restarts after user returns to note editing from distraction dialog
- **Context-Aware Behavior**: System understands user workflow and adapts accordingly

#### Simplified Distraction Logging

A new, streamlined distraction log system will replace the complex session logging:

- **Single Window Interface**: One comprehensive window for all distraction statistics
- **Clear Metrics Display**: Bold numbers for total, weekly, and monthly distractions avoided
- **Descriptive Layout**: Numbers with explanatory text below on same line
- **Detailed Log List**: Chronological list showing date, time, and distraction reason
- **Proper Window Sizing**: Adequate window dimensions for comfortable viewing

#### Accurate Distraction Recording

Distraction recording will be improved to capture actual user behavior:

- **Tab Change Detection**: Automatic recording when user switches tabs and returns
- **Custom Reason Support**: User-provided distraction reasons stored and displayed
- **Activity-Based Recording**: 1-minute activity in distraction dialog counts as engagement
- **Contextual Labeling**: Clear distinction between tab changes and custom distractions

#### Achievement Sharing System

A new achievement sharing feature will allow users to celebrate focus milestones:

- **Hover Interactions**: "Share your achievement" option appears on hover over statistics
- **Image Generation**: System creates downloadable images of achievement statistics
- **macOS Window Styling**: Generated images styled to look like native macOS windows
- **Multiple Statistics**: Sharing available for total, weekly, and monthly statistics
- **Proper Permissions**: Downloads saved to user's Downloads folder with appropriate file permissions

#### Critical UI Fixes

Several critical UI issues will be resolved for better user experience:

- **Stable Title Positioning**: Note title field maintains fixed position without vertical movement during editing
- **Bold Title Styling**: Title uses bold font weight at 36px size for better visual hierarchy
- **Natural Cursor Behavior**: Note body supports click-to-position cursor placement and maintains cursor position during typing
- **Text Insertion**: Text inserted at current cursor position rather than automatically moving to end

#### AI Integration Features

New AI-powered features will enhance the note-taking experience:

- **Distraction Log Export**: Users can download distraction logs as text files for AI analysis
- **ChatGPT Integration**: Direct links to ChatGPT for both distraction analysis and note reflection
- **Note Reflection Modal**: Large modal dialog displaying note content with copy-to-clipboard functionality
- **Seamless Workflow**: Integrated buttons and workflows for AI-assisted analysis

#### Application Rebranding

The application will be rebranded to better reflect its purpose:

- **New Name**: Application renamed from "note" to "Solo" 
- **Custom Logo**: Integration of custom logo from specified logo folder
- **Consistent Branding**: "Solo" branding applied throughout the interface and system integration