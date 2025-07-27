# Requirements Document

## Introduction

This document outlines the requirements for a responsive macOS note-taking application that provides users with an intuitive interface for creating, organizing, and managing notes locally on their device. The app features a sidebar-based navigation system with categorized note organization, a grid-based note preview system, and a focused note editing experience with automatic saving capabilities.

## Requirements

### Requirement 1

**User Story:** As a user, I want to see a clean interface with consistent visual design, so that I can focus on my note-taking without distractions.

#### Acceptance Criteria

1. WHEN the app launches THEN the system SHALL display the interface using DM Sans font throughout the application
2. WHEN any screen is displayed THEN the system SHALL use a white background as the primary color
3. WHEN icons are needed THEN the system SHALL use SF Pro symbols for all iconography
4. WHEN accent colors are required THEN the system SHALL use pastel orange as the accent color
5. WHEN text is displayed THEN the system SHALL use only three colors: white, pastel orange, and black

### Requirement 2

**User Story:** As a user, I want to organize my notes into different categories, so that I can easily find and manage related notes.

#### Acceptance Criteria

1. WHEN the app launches THEN the system SHALL display a sidebar on the left containing different note categories
2. WHEN a user clicks on a category THEN the system SHALL display notes belonging to that specific category
3. WHEN switching between categories THEN the system SHALL update the main view to show only notes from the selected category
4. WHEN no category is selected THEN the system SHALL display a default category or all notes

### Requirement 3

**User Story:** As a user, I want to see a preview of my notes in a grid layout, so that I can quickly identify and select the note I want to work with.

#### Acceptance Criteria

1. WHEN a category is selected THEN the system SHALL display notes in a grid view format
2. WHEN displaying note previews THEN the system SHALL show the note title prominently
3. WHEN displaying note previews THEN the system SHALL show the initial text from the note body
4. WHEN the note content exceeds the preview space THEN the system SHALL properly truncate the text with appropriate indicators
5. WHEN notes are displayed in grid view THEN the system SHALL maintain consistent spacing and alignment

### Requirement 4

**User Story:** As a user, I want to focus on writing when editing a note, so that I can be productive without interface distractions.

#### Acceptance Criteria

1. WHEN a user clicks on a note from the grid view THEN the system SHALL slide the sidebar out of view
2. WHEN in note editing mode THEN the system SHALL display only a toggle icon at the top left to show/hide the sidebar
3. WHEN editing a note THEN the system SHALL display the title field with 24px font size
4. WHEN editing a note THEN the system SHALL display the body field with 12px font size
5. WHEN in editing mode THEN the system SHALL center the note content with appropriate left and right padding for readability

### Requirement 5

**User Story:** As a user, I want my notes to be saved locally on my device, so that I can access them without internet connectivity and maintain privacy.

#### Acceptance Criteria

1. WHEN a note is created or modified THEN the system SHALL store the note data locally on the Mac device
2. WHEN the app is closed and reopened THEN the system SHALL restore all previously saved notes
3. WHEN notes are stored THEN the system SHALL use the local file system or appropriate local storage mechanism
4. WHEN accessing notes THEN the system SHALL NOT require internet connectivity

### Requirement 6

**User Story:** As a user, I want to save my changes as I work, so that I don't lose my progress if something unexpected happens.

#### Acceptance Criteria

1. WHEN a user types or makes changes to a note THEN the system SHALL detect the changes immediately
2. WHEN changes are detected THEN the system SHALL display a save option at the bottom center of the page
3. WHEN the save option is displayed THEN the system SHALL allow the user to save changes with a single action
4. WHEN changes are saved THEN the system SHALL persist the updated note content locally
5. WHEN no changes are pending THEN the system SHALL hide the save option

### Requirement 7

**User Story:** As a user, I want the app to be responsive and work well on my MacBook, so that I can use it efficiently regardless of my screen size or window configuration.

#### Acceptance Criteria

1. WHEN the app window is resized THEN the system SHALL adapt the layout appropriately
2. WHEN displayed on different MacBook screen sizes THEN the system SHALL maintain usability and readability
3. WHEN the sidebar is toggled THEN the system SHALL animate the transition smoothly
4. WHEN switching between grid view and note editing THEN the system SHALL provide smooth transitions
5. WHEN the app is used in different window sizes THEN the system SHALL maintain proper spacing and proportions

### Requirement 8

**User Story:** As a user, I want to delete notes I no longer need, so that I can keep my workspace organized and clutter-free.

#### Acceptance Criteria

1. WHEN viewing a note in the grid view THEN the system SHALL display a trash icon in the bottom left corner of each note card
2. WHEN a user clicks the trash icon THEN the system SHALL prompt for confirmation before deletion
3. WHEN deletion is confirmed THEN the system SHALL permanently remove the note from storage
4. WHEN a note is deleted THEN the system SHALL update the grid view to reflect the removal
5. WHEN the last note in a category is deleted THEN the system SHALL display an appropriate empty state

### Requirement 9

**User Story:** As a user, I want a clean interface without unnecessary elements, so that I can focus on my notes without distractions.

#### Acceptance Criteria

1. WHEN the app is displayed THEN the system SHALL NOT show a top bar with the text "note"
2. WHEN the interface is rendered THEN the system SHALL maximize the available space for note content
3. WHEN navigating the app THEN the system SHALL maintain clean visual hierarchy without redundant labels

### Requirement 10

**User Story:** As a user, I want to switch between light and dark modes, so that I can use the app comfortably in different lighting conditions.

#### Acceptance Criteria

1. WHEN viewing the sidebar THEN the system SHALL display a dark mode toggle at the bottom
2. WHEN dark mode is enabled THEN the system SHALL change the background to matte black (#171717)
3. WHEN dark mode is enabled THEN the system SHALL change text and icons to white
4. WHEN dark mode is toggled THEN the system SHALL apply the theme change throughout the entire application
5. WHEN the app is restarted THEN the system SHALL remember the user's theme preference

### Requirement 11

**User Story:** As a user, I want to create and manage my own categories, so that I can organize my notes according to my personal workflow.

#### Acceptance Criteria

1. WHEN viewing the sidebar THEN the system SHALL display an "Add new Space" button at the bottom with a plus icon
2. WHEN the add category button is clicked THEN the system SHALL prompt for a category name and icon selection
3. WHEN selecting an icon THEN the system SHALL display all available SF Symbol icons in a searchable interface
4. WHEN searching for icons THEN the system SHALL filter the available icons based on the search term
5. WHEN a category is created THEN the system SHALL add it to the sidebar and make it available for note organization
6. WHEN a user wants to delete a category THEN the system SHALL provide a delete option with confirmation
7. WHEN a category is deleted THEN the system SHALL handle any existing notes in that category appropriately

### Requirement 12

**User Story:** As a user, I want the app to reflect my personal branding preferences, so that it feels more personalized and meaningful.

#### Acceptance Criteria

1. WHEN the sidebar is displayed THEN the system SHALL show "Soul" instead of "Notes" as the main section title
2. WHEN the app interface is rendered THEN the system SHALL maintain consistency with this personalized branding

### Requirement 13

**User Story:** As a user, I want a subtle and elegant interface design, so that the app feels modern and unobtrusive.

#### Acceptance Criteria

1. WHEN the sidebar divider line is displayed THEN the system SHALL use a muted grayish color instead of dark
2. WHEN interface elements are rendered THEN the system SHALL prioritize subtle visual separation over high contrast borders
3. WHEN the overall interface is displayed THEN the system SHALL maintain visual hierarchy while reducing visual noise

### Requirement 14

**User Story:** As a user, I want to remove visual clutter from the sidebar, so that I can focus on my categories without unnecessary dividers.

#### Acceptance Criteria

1. WHEN the sidebar is displayed THEN the system SHALL NOT show a division line below the word "Soul"
2. WHEN the sidebar is displayed THEN the system SHALL NOT show a division line above the "Add a new space" option
3. WHEN the sidebar layout is rendered THEN the system SHALL maintain proper spacing without divider lines

### Requirement 15

**User Story:** As a user, I want larger and more readable text in my notes, so that I can write and read comfortably.

#### Acceptance Criteria

1. WHEN editing a note THEN the system SHALL display the title field with 32px font size
2. WHEN editing a note THEN the system SHALL display the body field with 16px font size as default
3. WHEN the note editor is displayed THEN the system SHALL use these font sizes consistently

### Requirement 16

**User Story:** As a user, I want to adjust the font size of my notes, so that I can customize the reading experience to my preference.

#### Acceptance Criteria

1. WHEN viewing the note editor THEN the system SHALL display a font size indicator near the sidebar toggle icon
2. WHEN the font size indicator is clicked THEN the system SHALL cycle through font sizes: 16px → 18px → 22px → 24px → 16px
3. WHEN a font size is selected THEN the system SHALL apply it to the body text of the current note
4. WHEN a font size is changed THEN the system SHALL persist this preference and apply it to all other notes
5. WHEN the app is restarted THEN the system SHALL remember and apply the user's preferred font size

### Requirement 17

**User Story:** As a user, I want square note cards that are more compact, so that I can see more notes at once in an organized grid.

#### Acceptance Criteria

1. WHEN notes are displayed in grid view THEN the system SHALL use square-shaped note cards
2. WHEN note cards are rendered THEN the system SHALL make them smaller than the current rectangular cards
3. WHEN the grid is displayed THEN the system SHALL maintain proper spacing between the smaller square cards

### Requirement 18

**User Story:** As a user, I want to see my most recently updated notes first, so that I can quickly access my latest work.

#### Acceptance Criteria

1. WHEN notes are displayed in the grid view THEN the system SHALL order them by date updated
2. WHEN a note is modified THEN the system SHALL move it to the top of the grid
3. WHEN notes have the same update time THEN the system SHALL use creation date as secondary sort criteria

### Requirement 19

**User Story:** As a user, I want better positioned action buttons on note cards, so that the interface feels more organized and intuitive.

#### Acceptance Criteria

1. WHEN note cards are displayed THEN the system SHALL position the trash icon in the bottom right corner
2. WHEN note cards are displayed THEN the system SHALL position the date in the bottom left corner
3. WHEN note cards are rendered THEN the system SHALL maintain proper alignment and spacing for these elements

### Requirement 20

**User Story:** As a user, I want the note title to stay on one line, so that the interface looks clean and consistent.

#### Acceptance Criteria

1. WHEN editing a note title THEN the system SHALL restrict the title to a single line
2. WHEN the title text exceeds the available width THEN the system SHALL prevent horizontal overflow
3. WHEN typing in the title field THEN the system SHALL handle text truncation or scrolling within the single line

### Requirement 21

**User Story:** As a user, I want a focus timer to help me stay concentrated while writing, so that I can be more productive and mindful of my writing time.

#### Acceptance Criteria

1. WHEN viewing the note editor THEN the system SHALL display a watch icon with countdown timer near the sidebar toggle and font size controls
2. WHEN the timer is displayed THEN the system SHALL show a default time of 10 minutes
3. WHEN the timer icon is clicked THEN the system SHALL allow changing the timer to 5 minutes or 10 minutes
4. WHEN a timer duration is selected THEN the system SHALL start the countdown timer
5. WHEN the timer is running THEN the system SHALL display the remaining time in MM:SS format

### Requirement 22

**User Story:** As a user, I want to be reminded to stay focused when I switch away from the app, so that I can maintain my writing concentration.

#### Acceptance Criteria

1. WHEN the timer is running AND the user switches to another app THEN the system SHALL detect the focus change
2. WHEN the timer is running AND the user switches tabs or swipes to another UI THEN the system SHALL detect the focus change
3. WHEN focus is lost during an active timer THEN the system SHALL display a macOS alert in the center of the screen
4. WHEN the focus alert is shown THEN the system SHALL display the message "You still have XX:XX minutes left to focus on yourself"
5. WHEN the focus alert is displayed THEN the system SHALL show two options: "Return" and "Cancel"
6. WHEN "Return" is clicked THEN the system SHALL bring the app back to focus and continue the timer
7. WHEN "Cancel" is clicked THEN the system SHALL end the timer session

### Requirement 23

**User Story:** As a user, I want to be prompted when I stop typing during a focus session, so that I can reflect on whether I'm staying on task.

#### Acceptance Criteria

1. WHEN the timer is running AND the user hasn't typed for 15 seconds THEN the system SHALL display a message "You stopped typing"
2. WHEN the typing pause message is shown THEN the system SHALL display two options: "I was distracted" and "I am thinking"
3. WHEN "I am thinking" is clicked THEN the system SHALL dismiss the message and continue the timer
4. WHEN "I was distracted" is clicked THEN the system SHALL show an additional dialog
5. WHEN the distraction dialog is shown THEN the system SHALL display an optional text box asking "What were you distracted by?"
6. WHEN the distraction dialog is shown THEN the system SHALL display two options: "End the session" and "Return to the note"
7. WHEN "Return to the note" is clicked THEN the system SHALL dismiss the dialog and continue the timer
8. WHEN "End the session" is clicked THEN the system SHALL stop the timer and end the focus session

### Requirement 24

**User Story:** As a user, I want to track my focus sessions and distractions, so that I can understand my writing patterns and improve my concentration.

#### Acceptance Criteria

1. WHEN the user switches focus away from the app THEN the system SHALL log the event with date and time
2. WHEN the user gets the "stopped typing" prompt THEN the system SHALL log the event with date and time
3. WHEN the user selects "I was distracted" THEN the system SHALL log the distraction with optional reason and date/time
4. WHEN the user chooses to end a session THEN the system SHALL log the session end with date and time
5. WHEN focus sessions are completed THEN the system SHALL calculate total focus time and distraction count
6. WHEN the sidebar is displayed THEN the system SHALL show focus statistics below "Add new space" option
7. WHEN focus statistics are shown THEN the system SHALL display "{time} hours focus" and "{number} distractions avoided" with appropriate icons
8. WHEN focus statistics are clicked THEN the system SHALL navigate to a complete log list view
9. WHEN the log list is displayed THEN the system SHALL show all focus events with timestamps and details