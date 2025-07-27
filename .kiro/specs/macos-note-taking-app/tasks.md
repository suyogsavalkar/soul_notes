# Implementation Plan

- [x] 1. Set up project structure and data models

  - Create data model files for Note and Category structures
  - Implement Codable conformance for JSON serialization
  - Add UUID and Date handling for note identification and timestamps
  - _Requirements: 5.1, 5.2_

- [x] 2. Implement local storage and data persistence

  - Create NoteManager class with ObservableObject conformance
  - Implement JSON file read/write operations for local storage
  - Add error handling for file system operations
  - Create default categories and initial data setup
  - _Requirements: 5.1, 5.2, 5.3, 2.4_

- [x] 3. Create core CRUD operations for notes

  - Implement createNote, updateNote, and deleteNote methods in NoteManager
  - Add category filtering functionality for notes
  - Implement note preview text generation with proper truncation
  - Write unit tests for all CRUD operations
  - _Requirements: 3.4, 6.4, 2.3_

- [x] 4. Set up custom font integration

  - Add DM Sans font files to the project bundle
  - Create font extension for consistent typography usage
  - Implement custom font loading and fallback handling
  - _Requirements: 1.1_

- [x] 5. Create color system and design tokens

  - Define custom Color extensions for the three-color palette
  - Implement pastel orange accent color specification
  - Create reusable color constants for consistency
  - _Requirements: 1.2, 1.3, 1.4, 1.5_

- [x] 6. Build main application structure

  - Replace ContentView with MainView using NavigationSplitView
  - Implement sidebar visibility state management
  - Create basic navigation between sidebar and main content
  - Add NoteManager as StateObject to main view
  - _Requirements: 2.1, 4.2, 7.3_

- [x] 7. Implement sidebar navigation component

  - Create SidebarView with category list display
  - Add category selection handling and state binding
  - Implement SF Symbols for category icons
  - Style sidebar with proper spacing and typography
  - _Requirements: 2.1, 2.2, 2.3, 1.4_

- [x] 8. Build notes grid view component

  - Create NotesGridView with LazyVGrid implementation
  - Implement responsive grid columns that adapt to window size
  - Add note filtering based on selected category
  - Create smooth grid animations and transitions
  - _Requirements: 3.1, 3.5, 7.1, 7.2, 7.5_

- [x] 9. Create note preview cards

  - Build NotePreviewCard component with title and body preview
  - Implement proper text truncation for preview content
  - Add consistent card styling with padding and spacing
  - Handle tap gestures for note selection
  - _Requirements: 3.2, 3.3, 3.4_

- [x] 10. Implement note editor interface

  - Create NoteEditorView with title and body text fields
  - Set up 24px font size for title and 12px for body
  - Implement centered content layout with left/right padding
  - Add sidebar toggle button at top left
  - _Requirements: 4.3, 4.4, 4.5, 4.2_

- [x] 11. Add auto-save functionality and change detection

  - Implement change detection for note content modifications
  - Create debounced auto-save mechanism with 500ms delay
  - Add save button display at bottom center when changes are detected
  - Handle save button visibility and user-triggered saves
  - _Requirements: 6.1, 6.2, 6.3, 6.4, 6.5_

- [x] 12. Implement sidebar slide animation

  - Add smooth sidebar show/hide transitions
  - Create toggle functionality between grid view and editor
  - Implement proper animation timing and easing
  - Ensure responsive behavior during window resizing
  - _Requirements: 4.1, 7.3, 7.4_

- [x] 13. Add responsive design and window adaptation

  - Implement dynamic grid column calculation based on window width
  - Add proper layout constraints for different screen sizes
  - Ensure text readability across various window configurations
  - Test and optimize performance for window resizing
  - _Requirements: 7.1, 7.2, 7.5_

- [x] 14. Create comprehensive error handling

  - Add file system error handling with user feedback
  - Implement data validation and recovery mechanisms
  - Create fallback states for missing or corrupted data
  - Add user notifications for critical errors
  - _Requirements: 5.1, 5.2, 5.3_

- [x] 15. Write unit tests for core functionality

  - Test NoteManager CRUD operations and data persistence
  - Validate JSON serialization and file system operations
  - Test note preview generation and text truncation
  - Verify category filtering and selection logic
  - _Requirements: 2.3, 3.4, 5.1, 6.4_

- [x] 16. Implement integration tests for user flows

  - Test complete note creation and editing workflow
  - Verify sidebar navigation and category switching
  - Test auto-save behavior and change detection
  - Validate responsive layout adaptation
  - _Requirements: 2.2, 4.1, 6.1, 7.1_

- [x] 17. Add UI tests for user interactions

  - Test sidebar toggle and navigation interactions
  - Verify note selection from grid to editor transition
  - Test typing and auto-save user experience
  - Validate grid responsiveness and card interactions
  - _Requirements: 4.1, 4.2, 6.2, 7.4_

- [x] 18. Optimize performance and finalize implementation

  - Implement lazy loading for large note collections
  - Optimize text rendering and truncation performance
  - Add memory management for efficient resource usage
  - Fine-tune animation performance and smoothness
  - _Requirements: 7.1, 7.2, 7.4, 7.5_

- [x] 19. Implement note deletion functionality

  - Add trash icon to bottom left corner of NotePreviewCard components
  - Create delete confirmation dialog with proper styling
  - Implement deleteNote method in NoteManager with proper error handling
  - Update grid view to animate note removal after deletion
  - Write unit tests for note deletion functionality
  - _Requirements: 8.1, 8.2, 8.3, 8.4, 8.5_

- [x] 20. Remove top navigation bar

  - Remove or hide the "note" title from the main navigation interface
  - Adjust layout constraints to maximize content space
  - Ensure proper spacing and visual hierarchy without the top bar
  - Test responsive behavior with removed navigation element
  - _Requirements: 9.1, 9.2, 9.3_

- [x] 21. Create theme management system

  - Implement ThemeManager class as ObservableObject with dark/light mode state
  - Create theme preference persistence using JSON storage
  - Define color extensions for theme-aware color management
  - Add theme loading and saving functionality with error handling
  - Write unit tests for theme management functionality
  - _Requirements: 10.4, 10.5_

- [x] 22. Implement dark mode toggle in sidebar

  - Add dark mode toggle button at bottom of SidebarView
  - Create toggle UI with appropriate SF Symbol icons (moon/sun)
  - Connect toggle to ThemeManager state changes
  - Implement smooth theme transition animations
  - _Requirements: 10.1_

- [x] 23. Apply dark mode styling throughout app

  - Update all views to use theme-aware colors from ThemeManager
  - Implement matte black background (#171717) for dark mode
  - Change text and icons to white in dark mode
  - Ensure proper contrast and readability in both themes
  - Test all UI components in both light and dark modes
  - _Requirements: 10.2, 10.3_

- [x] 24. Create SF Symbol picker component

  - Build SFSymbolPicker view with grid layout for icon selection
  - Implement comprehensive list of appropriate SF Symbols for categories
  - Add real-time search functionality to filter icons by name
  - Create responsive grid layout that adapts to modal size
  - Style picker with theme-aware colors and proper spacing
  - _Requirements: 11.3, 11.4_

- [x] 25. Implement category creation interface

  - Create CategoryCreationView modal with name input and icon picker
  - Add form validation for category name (non-empty, unique)
  - Integrate SFSymbolPicker for icon selection
  - Implement category creation flow with proper error handling
  - Style modal with consistent design system and theme support
  - _Requirements: 11.2, 11.5_

- [x] 26. Add category management to sidebar

  - Update SidebarView to show "Soul" instead of "Notes" as section title
  - Add "Add new Space" button at bottom of sidebar with plus icon
  - Connect button to CategoryCreationView modal presentation
  - Update category list to display custom SF Symbol icons
  - Implement category selection and highlighting functionality
  - _Requirements: 11.1, 12.1_

- [x] 27. Implement category deletion functionality

  - Add category deletion option (long press or context menu)
  - Create deletion confirmation dialog with proper warnings
  - Implement category deletion logic with note reassignment to default category
  - Update sidebar to reflect category removal
  - Handle edge cases like deleting category with active notes
  - _Requirements: 11.6, 11.7_

- [x] 28. Update Category model and data persistence

  - Add iconName field to Category model for SF Symbol storage
  - Update default categories to include appropriate SF Symbol icons
  - Modify category JSON serialization to include icon data
  - Implement category CRUD operations in NoteManager
  - Add data migration for existing categories without icons
  - _Requirements: 11.5, 11.6_

- [x] 29. Refine UI styling and visual elements

  - Update sidebar divider lines to use muted grayish color
  - Ensure consistent spacing and padding throughout the interface
  - Apply subtle visual refinements for elegant appearance
  - Test visual consistency across different window sizes
  - Verify proper theme application to all UI elements
  - _Requirements: 13.1, 13.2, 13.3_

- [x] 30. Write comprehensive tests for new features

  - Create unit tests for ThemeManager functionality and persistence
  - Test category creation, deletion, and icon selection workflows
  - Verify note deletion functionality and confirmation dialogs
  - Test SF Symbol picker search and selection functionality
  - Add integration tests for theme switching across the app
  - _Requirements: 8.3, 10.5, 11.4, 11.7_

- [x] 31. Implement error handling for new features

  - Add proper error handling for category creation and deletion
  - Implement fallback behavior for missing or invalid SF Symbols
  - Create user feedback for theme switching failures
  - Add validation and error messages for category name conflicts
  - Test error scenarios and recovery mechanisms
  - _Requirements: 8.2, 10.4, 11.2, 11.6_

- [x] 32. Final integration and testing of new features

  - Test complete user workflows with all new features enabled
  - Verify theme persistence across app launches and restarts
  - Test category management with note organization workflows
  - Validate note deletion in various app states and categories
  - Perform comprehensive UI testing in both light and dark modes
  - _Requirements: 8.4, 9.3, 10.1, 11.1, 12.1, 13.3_

- [x] 33. Remove sidebar divider lines for cleaner design

  - Remove division line below "Soul" text in sidebar
  - Remove division line above "Add a new space" option
  - Adjust spacing to maintain visual hierarchy without dividers
  - Test layout consistency across different window sizes
  - _Requirements: 14.1, 14.2, 14.3_

- [x] 34. Update note editor font sizes

  - Change note title font size from 24px to 32px
  - Change note body default font size from 12px to 16px
  - Update font size constants and styling throughout the app
  - Test readability and layout with new font sizes
  - _Requirements: 15.1, 15.2, 15.3_

- [x] 35. Implement font size management system
- [x] 35.1 Create FontSizeManager class with ObservableObject

  - Implement font size cycling logic (16px → 18px → 22px → 24px → 16px)
  - Add font size persistence using JSON storage
  - Create font size preference loading and saving methods
  - Write unit tests for font size cycling and persistence
  - _Requirements: 16.4, 16.5_

- [x] 35.2 Add font size indicator and controls to note editor

  - Display current font size near sidebar toggle icon
  - Implement clickable font size control that cycles through sizes
  - Update note body text to use selected font size dynamically
  - Apply font size changes globally across all notes
  - _Requirements: 16.1, 16.2, 16.3_

- [x] 36. Update note grid layout to square cards

  - Change note preview cards from rectangular to square shape
  - Reduce overall card size for more compact grid layout
  - Adjust grid spacing and padding for smaller cards
  - Update LazyVGrid configuration for square aspect ratio
  - _Requirements: 17.1, 17.2, 17.3_

- [x] 37. Implement note sorting by date updated

  - Modify NotesGridView to sort notes by modifiedAt date
  - Ensure most recently updated notes appear first
  - Add secondary sorting by creation date for ties
  - Update note modification timestamps when notes are edited
  - _Requirements: 18.1, 18.2, 18.3_

- [x] 38. Reposition note card elements

  - Move trash icon from bottom left to bottom right corner
  - Position date display in bottom left corner of note cards
  - Update NotePreviewCard layout and constraints
  - Ensure proper alignment and spacing for repositioned elements
  - _Requirements: 19.1, 19.2, 19.3_

- [x] 39. Implement single-line title constraint

  - Restrict note title input to single line in editor
  - Prevent horizontal overflow of title text
  - Implement proper text truncation or scrolling within title field
  - Test title behavior with various text lengths and window sizes
  - _Requirements: 20.1, 20.2, 20.3_

- [x] 40. Create focus timer system foundation
- [x] 40.1 Implement FocusTimerManager class

  - Create ObservableObject class for timer state management
  - Implement timer countdown functionality with 5 and 10 minute options
  - Add timer start, stop, and pause methods
  - Create timer duration selection and persistence
  - Write unit tests for timer functionality
  - _Requirements: 21.2, 21.3, 21.4, 21.5_

- [x] 40.2 Add focus timer UI controls to note editor

  - Display watch icon with countdown timer near sidebar toggle
  - Implement timer duration selection interface
  - Show remaining time in MM:SS format during active sessions
  - Create timer start/stop controls and visual feedback
  - _Requirements: 21.1, 21.5_

- [x] 41. Implement app focus detection and alerts
- [x] 41.1 Create focus loss detection system

  - Monitor app focus state using NSApplication notifications
  - Detect when user switches to other apps or tabs during timer
  - Implement focus change event logging with timestamps
  - Handle edge cases like system sleep and app termination
  - _Requirements: 22.1, 22.2_

- [x] 41.2 Implement focus loss alert system

  - Display macOS alert when focus is lost during active timer
  - Show remaining time in alert message format
  - Create "Return" and "Cancel" button options in alert
  - Handle user responses to return to app or end session
  - _Requirements: 22.3, 22.4, 22.5, 22.6, 22.7_

- [x] 42. Create typing activity monitoring system
- [x] 42.1 Implement typing detection in note editor

  - Monitor typing activity and track last typing timestamp
  - Detect when user hasn't typed for 15 seconds during active timer
  - Create typing pause event logging
  - Handle typing detection across different text fields
  - _Requirements: 23.1_

- [x] 42.2 Create typing pause prompt interface

  - Display "You stopped typing" message after 15 seconds of inactivity
  - Implement "I was distracted" and "I am thinking" button options
  - Handle "I am thinking" selection to continue timer
  - Create distraction dialog flow for "I was distracted" selection
  - _Requirements: 23.2, 23.3, 23.4_

- [x] 42.3 Implement distraction logging interface

  - Create distraction reason input dialog with optional text field
  - Display "End the session" and "Return to the note" options
  - Handle session continuation or termination based on user choice
  - Log distraction events with optional reasons and timestamps
  - _Requirements: 23.5, 23.6, 23.7, 23.8_

- [x] 43. Create focus session logging system
- [x] 43.1 Implement focus event logging

  - Create FocusLogEntry model for different event types
  - Log focus loss events when user switches away from app
  - Log typing pause events and user responses
  - Log distraction events with reasons and session outcomes
  - Log session start, end, and duration events
  - _Requirements: 24.1, 24.2, 24.3, 24.4_

- [x] 43.2 Create focus statistics calculation

  - Calculate total focus time from completed sessions
  - Count distractions avoided (when user returns to session)
  - Implement statistics persistence and loading
  - Create real-time statistics updates during active sessions
  - _Requirements: 24.5_

- [x] 44. Implement focus statistics display in sidebar
- [x] 44.1 Create focus statistics UI component

  - Display focus hours and distractions avoided below "Add new space"
  - Use appropriate icons for focus time and distraction statistics
  - Implement clickable statistics that navigate to detailed logs
  - Style statistics component with theme-aware colors
  - _Requirements: 24.6, 24.7, 24.8_

- [x] 44.2 Create detailed focus log view

  - Build comprehensive log list showing all focus events
  - Display timestamps, event types, and details for each entry
  - Implement search and filtering functionality for log entries
  - Create navigation from sidebar statistics to log view
  - _Requirements: 24.9_

- [x] 45. Integrate all new systems with existing app
- [x] 45.1 Update main app structure for new managers

  - Add FontSizeManager and FocusTimerManager as environment objects
  - Update MainView to initialize and provide new managers
  - Ensure proper dependency injection throughout the app
  - Test manager integration with existing NoteManager and ThemeManager
  - _Requirements: 16.5, 21.1_

- [x] 45.2 Update note editor with all new controls

  - Integrate font size controls, focus timer, and sidebar toggle in header
  - Ensure proper layout and spacing for all control elements
  - Test control interactions and state management
  - Verify typing detection works with font size and timer systems
  - _Requirements: 16.1, 20.3, 21.1_

- [x] 46. Implement comprehensive error handling for new features

  - Add error handling for font size preference loading/saving failures
  - Implement focus timer error handling for system events
  - Create fallback mechanisms for focus detection failures
  - Add validation and error handling for focus log corruption
  - Handle macOS alert system failures gracefully
  - _Requirements: 16.5, 22.3, 24.1_

- [x] 47. Write comprehensive tests for all new functionality
- [x] 47.1 Create unit tests for new managers

  - Test FontSizeManager cycling and persistence functionality
  - Test FocusTimerManager timer operations and state management
  - Test focus event logging and statistics calculation
  - Verify error handling and edge cases for all managers
  - _Requirements: 16.4, 21.4, 24.5_

- [x] 47.2 Create integration tests for new user workflows

  - Test complete font size adjustment workflow
  - Test focus timer session from start to completion
  - Test distraction handling and logging workflows
  - Verify statistics display and navigation functionality
  - _Requirements: 16.3, 22.7, 23.8, 24.8_

- [x] 47.3 Create UI tests for new interface elements

  - Test font size control interactions and visual feedback
  - Test focus timer UI and countdown display
  - Test typing pause prompts and distraction dialogs
  - Test focus statistics display and navigation
  - _Requirements: 16.2, 21.5, 23.2, 24.7_

- [x] 48. Final integration and comprehensive testing
  - Test all new features working together seamlessly
  - Verify performance with focus monitoring and font size changes
  - Test app behavior during system events (sleep, app switching)
  - Validate data persistence for all new preference systems
  - Perform comprehensive user acceptance testing for all workflows
  - _Requirements: 14.3, 15.3, 17.3, 18.3, 19.3, 20.3, 21.5, 22.7, 23.8, 24.9_
