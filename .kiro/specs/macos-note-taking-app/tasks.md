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

- [x] 49. Fix create note card visual consistency

  - Update WelcomeView to use identical dimensions as NotePreviewCard
  - Ensure create note card maintains square aspect ratio matching other cards
  - Fix card compression issues by applying proper layout constraints
  - Test create note card appearance in different grid configurations
  - _Requirements: 25.1, 25.2, 25.3_

- [x] 50. Implement note title improvements
- [x] 50.1 Fix title positioning and styling

  - Modify NoteEditorView to keep title field in fixed position
  - Apply semibold font weight to title text field
  - Prevent title field from moving when cursor is placed or focus changes
  - Test title stability across different editing scenarios
  - _Requirements: 26.1, 26.2_

- [x] 50.2 Implement title character limit

  - Add 45-character limit to title text field with input validation
  - Implement character count tracking and input prevention beyond limit
  - Add visual feedback for character limit (optional counter or styling)
  - Test title truncation and limit enforcement
  - _Requirements: 26.3, 26.4_

- [x] 51. Fix note body cursor positioning

  - Modify note body text editor to support click-to-position cursor placement
  - Ensure cursor stays at insertion point during typing without auto-repositioning
  - Fix text insertion to occur at current cursor position, not at end
  - Test cursor behavior with various text editing scenarios (middle insertion, selection)
  - _Requirements: 27.1, 27.2, 27.3, 27.4_

- [x] 52. Reorganize sidebar layout

  - Move focus and distraction metrics below dark/light mode toggle in SidebarView
  - Update sidebar layout constraints to accommodate new metrics positioning
  - Ensure proper styling and alignment of metrics with other sidebar elements
  - Test sidebar layout with different window sizes and content states
  - _Requirements: 28.1, 28.2, 28.3_

- [x] 53. Enhance focus system behavior
- [x] 53.1 Implement window-aware focus alerts

  - Modify focus loss detection to show alerts on user's current window
  - Update alert system to target active window instead of app window
  - Handle edge cases where current window detection might fail
  - Test alert positioning across different window configurations
  - _Requirements: 29.1_

- [x] 53.2 Adjust focus timing behavior

  - Change typing detection timer from 15 seconds to 1 minute
  - Modify timer restart logic to only begin after user returns to note editing
  - Update focus system to start 1-minute timer only after distraction dialog dismissal
  - Test timing behavior with various user interaction patterns
  - _Requirements: 29.2, 29.3, 29.4_

- [x] 54. Create simplified distraction logging system
- [x] 54.1 Build new distraction log interface

  - Create new FocusLogView with single window design for distraction statistics
  - Implement bold number display for total, weekly, and monthly distractions avoided
  - Add descriptive text below each statistic number on the same line
  - Create chronological list showing date, time, and distraction reason
  - Ensure proper window sizing that's not too small for content
  - _Requirements: 30.1, 30.2, 30.3, 30.4, 30.5, 30.6, 30.7_

- [x] 54.2 Update distraction data models

  - Replace complex FocusLogEntry with simplified DistractionLogEntry model
  - Create DistractionStats model for total, weekly, and monthly counts
  - Implement DistractionType enum for tab changes vs custom reasons
  - Add methods for calculating weekly and monthly statistics
  - _Requirements: 30.2, 30.3, 30.4_

- [x] 55. Implement accurate distraction recording
- [x] 55.1 Create tab change detection and recording

  - Implement automatic distraction recording when user changes tabs and returns
  - Log tab change events with "Tab change" label in distraction field
  - Count tab change returns as distractions avoided
  - Test tab switching detection across different applications
  - _Requirements: 31.1, 31.3_

- [x] 55.2 Implement custom distraction reason handling

  - Record user-provided distraction reasons in log with custom text
  - Display custom reasons in distraction field instead of generic labels
  - Count 1-minute activity in distraction dialog as user engagement
  - Ensure custom reasons are properly stored and retrieved
  - _Requirements: 31.2, 31.4, 31.5_

- [x] 56. Create achievement sharing system
- [x] 56.1 Implement hover interactions for statistics

  - Add hover detection to total, weekly, and monthly distraction numbers
  - Display "share your achievement" option on hover over each statistic
  - Create hover state styling and interaction feedback
  - Test hover behavior across different UI states
  - _Requirements: 32.1, 32.2, 32.3_

- [x] 56.2 Build achievement image generation

  - Implement image generation system for achievement statistics
  - Create macOS window-styled image templates for statistics
  - Add download functionality for generated achievement images
  - Handle image generation errors and provide user feedback
  - Test image generation with different statistics values
  - _Requirements: 32.4, 32.5_

- [x] 57. Update focus timer manager for new requirements

  - Modify FocusTimerManager to support new timing behavior (1-minute detection)
  - Update distraction recording to use simplified DistractionLogEntry model
  - Implement window-aware alert system integration
  - Add support for tab change detection and automatic recording
  - _Requirements: 29.2, 29.3, 31.1, 31.3_

- [x] 58. Write comprehensive tests for issue fixes
- [x] 58.1 Create unit tests for UI fixes

  - Test create note card dimensions and layout consistency
  - Test title character limit enforcement and positioning
  - Test cursor positioning and text insertion in note body
  - Test sidebar layout reorganization and metrics positioning
  - _Requirements: 25.3, 26.4, 27.4, 28.3_

- [x] 58.2 Create integration tests for focus system improvements

  - Test window-aware alert system functionality
  - Test new timing behavior for focus detection
  - Test distraction recording accuracy for tab changes and custom reasons
  - Test achievement sharing image generation and download
  - _Requirements: 29.4, 31.5, 32.5_

- [x] 59. Fix critical UI and functionality issues
- [x] 59.1 Fix note title positioning and character count display

  - Add proper margin-top to title field to prevent movement when cursor is placed
  - Remove character count display (xx/45) from title area
  - Ensure title field remains stable during editing
  - Test title positioning across different editing scenarios
  - _Requirements: 26.1, 26.2_

- [x] 59.2 Fix note body cursor positioning

  - Implement proper cursor placement that allows editing anywhere in text
  - Prevent cursor from jumping to end when typing in middle of text
  - Ensure text insertion occurs at cursor position, not at end
  - Test cursor behavior with click-to-position and keyboard navigation
  - _Requirements: 27.1, 27.2, 27.3, 27.4_

- [x] 59.3 Fix focus system distraction recording

  - Implement 1-minute typing inactivity detection (changed from current timing)
  - Record custom distraction reasons in focus log instead of generic "tab change"
  - Show user-provided reason in distraction log entries
  - Ensure distractions from typing inactivity are properly recorded
  - _Requirements: 29.2, 31.2, 31.4_

- [x] 59.4 Fix achievement sharing functionality

  - Implement working image download for "share your achievement" button
  - Create proper image generation with macOS window styling
  - Add error handling for image generation and download failures
  - Test image download across different statistics (total, weekly, monthly)
  - _Requirements: 32.4, 32.5_

- [x] 59.5 Rename application to "Soul"

  - Update app name from "note" to "Soul" in all relevant files
  - Modify Info.plist to reflect new app name
  - Update any hardcoded references to old app name
  - Ensure app displays as "Soul" in macOS system
  - _Requirements: 12.1_

- [x] 60. Fix achievement sharing file permissions

  - Update achievement image download to save to user's Downloads folder
  - Implement proper file permissions for downloaded images
  - Add error handling for file system permission issues
  - Test image download functionality across different user permission scenarios
  - _Requirements: 32.4_

- [x] 61. Fix note title positioning and styling
- [x] 61.1 Implement stable title positioning

  - Modify NoteEditorView title field to prevent vertical movement during editing
  - Add proper margins and constraints to keep title in fixed position
  - Ensure title field doesn't move when cursor is placed or focus changes
  - Test title stability across different editing scenarios
  - _Requirements: 33.1, 33.3, 33.4_

- [x] 61.2 Update title font styling

  - Change title font from semibold to bold weight
  - Update title font size from current size to 36px
  - Ensure consistent bold styling across all title displays
  - Test title readability and visual hierarchy with new styling
  - _Requirements: 33.2_

- [x] 62. Fix note body cursor positioning

  - Implement proper click-to-position cursor placement in note body
  - Ensure cursor stays at clicked position during typing
  - Prevent automatic cursor movement to end of text during editing
  - Fix text insertion to occur at current cursor position
  - Test cursor behavior with various text editing scenarios
  - _Requirements: 34.1, 34.2, 34.3, 34.4_

- [x] 63. Implement distraction log export functionality
- [x] 63.1 Create distraction log export system

  - Build DistractionExportManager class for handling log exports
  - Implement text file generation with formatted distraction data
  - Add date, time, and reason formatting for readability
  - Create file download functionality to user's Downloads folder
  - _Requirements: 35.2_

- [x] 63.2 Add export UI to distraction log view

  - Add "Get diagnosed by ChatGPT" button next to "Recent Distractions" header
  - Implement button click handler to trigger log export
  - Create success message display after successful download
  - Add "Go to ChatGPT" button with link icon in success message
  - Implement ChatGPT website opening functionality
  - _Requirements: 35.1, 35.3, 35.4, 35.5_

- [x] 64. Create note reflection modal system
- [x] 64.1 Build note reflection modal interface

  - Create NoteReflectionView modal dialog component
  - Implement large modal sizing with proper responsive layout
  - Add scrollable text area for displaying note content
  - Style modal with theme-aware colors and consistent design
  - _Requirements: 36.2, 36.3_

- [x] 64.2 Add reflection functionality

  - Implement copy to clipboard functionality for note content
  - Add "Go to ChatGPT" button at bottom of modal
  - Create ChatGPT website opening functionality
  - Format note content appropriately for AI analysis
  - _Requirements: 36.4, 36.5, 36.6_

- [x] 64.3 Integrate reflection modal with note editor

  - Add "Reflect with AI" button next to timer controls in note editor
  - Implement modal presentation when button is clicked
  - Pass current note content to reflection modal
  - Test modal integration with existing note editor functionality
  - _Requirements: 36.1_

- [x] 65. Rebrand application to "Solo"
- [x] 65.1 Update application name and branding

  - Change app name from "note" to "Solo" in Info.plist
  - Update app display name in macOS system
  - Replace any hardcoded references to old app name throughout codebase
  - Update app bundle identifier if necessary
  - _Requirements: 37.1, 37.3_

- [x] 65.2 Integrate new logo

  - Locate and import logo files from specified logo folder (/Users/suyog/Suyog/Important/note/notelogo)
  - Update app icon assets with new Solo logo
  - Ensure logo displays correctly in dock and applications folder
  - Test logo appearance across different macOS display settings
  - _Requirements: 37.2, 37.4_

- [x] 66. Write comprehensive tests for new features
- [x] 66.1 Create unit tests for new functionality

  - Test DistractionExportManager file generation and formatting
  - Test note reflection modal content handling and clipboard operations
  - Test achievement sharing file permission handling
  - Verify cursor positioning fixes in note body editor
  - _Requirements: 32.4, 34.4, 35.2, 36.4_

- [x] 66.2 Create integration tests for new workflows

  - Test complete distraction log export and ChatGPT navigation workflow
  - Test note reflection modal presentation and interaction workflow
  - Test achievement sharing download and success message workflow
  - Verify title positioning stability across different editing scenarios
  - _Requirements: 33.4, 35.5, 36.6, 32.5_

- [x] 67. Final integration testing for all new features
  - Test all new features working together without conflicts
  - Verify performance impact of changes is minimal
  - Test user workflows end-to-end with all improvements
  - Validate file system operations work correctly across different user environments
  - Perform comprehensive user acceptance testing for all new functionality
  - _Requirements: 33.4, 34.4, 35.5, 36.6, 37.4_
