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

### Requirement 25

**User Story:** As a user, I want the create note option to appear as a proper square card, so that it maintains visual consistency with other note cards.

#### Acceptance Criteria

1. WHEN the notes grid is displayed THEN the system SHALL show the create note option as a square card matching other note cards
2. WHEN the create note card is rendered THEN the system SHALL ensure it has the same dimensions and styling as regular note cards
3. WHEN the create note card is displayed THEN the system SHALL prevent the card from being squished or smaller than other cards

### Requirement 26

**User Story:** As a user, I want the note title to remain in a fixed position and be properly styled, so that I can edit it without visual disruption.

#### Acceptance Criteria

1. WHEN editing a note THEN the system SHALL keep the title field in a fixed position that doesn't move when cursor is placed
2. WHEN the title is displayed THEN the system SHALL use semibold font weight for better visual hierarchy
3. WHEN typing in the title field THEN the system SHALL limit the title to 45 characters maximum
4. WHEN the title reaches 45 characters THEN the system SHALL prevent further input or provide appropriate truncation

### Requirement 27

**User Story:** As a user, I want to be able to place my cursor anywhere in the note body and type naturally, so that I can edit text efficiently.

#### Acceptance Criteria

1. WHEN clicking anywhere in the note body text THEN the system SHALL place the cursor at the clicked position
2. WHEN typing in the note body THEN the system SHALL insert text at the current cursor position
3. WHEN editing text in the middle of the body THEN the system SHALL NOT move the cursor to the end automatically
4. WHEN the note body is focused THEN the system SHALL maintain proper cursor positioning throughout the editing session

### Requirement 28

**User Story:** As a user, I want the focus and distraction metrics properly positioned in the sidebar, so that the interface feels organized and accessible.

#### Acceptance Criteria

1. WHEN the sidebar is displayed THEN the system SHALL position focus and distraction metrics below the dark/light mode toggle
2. WHEN the metrics are displayed THEN the system SHALL maintain proper styling and alignment consistent with other sidebar elements
3. WHEN the sidebar layout is rendered THEN the system SHALL ensure metrics don't interfere with other sidebar functionality

### Requirement 29

**User Story:** As a user, I want improved focus system behavior that doesn't disrupt my workflow, so that I can maintain concentration without intrusive interruptions.

#### Acceptance Criteria

1. WHEN switching tabs or apps THEN the system SHALL display focus alerts on the current window where the user is, not on the app window
2. WHEN the user hasn't typed for a period THEN the system SHALL wait 1 minute before showing the alert (changed from 15 seconds)
3. WHEN the user provides a distraction reason and returns to the note view THEN the system SHALL start the 1-minute timer for typing detection
4. WHEN the alert is dismissed THEN the system SHALL only restart the typing timer after the user returns to active note editing

### Requirement 30

**User Story:** As a user, I want a simple and comprehensive distraction log system, so that I can track my focus patterns effectively.

#### Acceptance Criteria

1. WHEN clicking on distraction metrics THEN the system SHALL open a single window showing the distraction log
2. WHEN the distraction log is displayed THEN the system SHALL show total number of distractions avoided as a bold number
3. WHEN the distraction log is displayed THEN the system SHALL show distractions avoided in last 7 days as a bold number
4. WHEN the distraction log is displayed THEN the system SHALL show distractions avoided in last 30 days as a bold number
5. WHEN the statistics are displayed THEN the system SHALL show descriptive text below each number on the same line
6. WHEN the distraction log is displayed THEN the system SHALL show a list of distractions with date, time, and distraction reason
7. WHEN the distraction log window is opened THEN the system SHALL ensure it's properly sized and not too small

### Requirement 31

**User Story:** As a user, I want distractions to be recorded accurately based on my actions, so that the log reflects my actual focus patterns.

#### Acceptance Criteria

1. WHEN the user changes tabs and clicks return THEN the system SHALL record this as a distraction avoided
2. WHEN the user provides a custom reason for distraction THEN the system SHALL record this custom reason in the log
3. WHEN the distraction is due to tab change THEN the system SHALL show "Tab change" in the distraction field
4. WHEN the distraction has a custom reason THEN the system SHALL show the user-provided reason in the distraction field
5. WHEN the user spends 1 minute providing a distraction reason THEN the system SHALL count this as activity and record the distraction

### Requirement 32

**User Story:** As a user, I want to share my focus achievements, so that I can celebrate my productivity milestones.

#### Acceptance Criteria

1. WHEN hovering over the total distractions number THEN the system SHALL show a "share your achievement" option
2. WHEN hovering over the weekly distractions number THEN the system SHALL show a "share your achievement" option  
3. WHEN hovering over the monthly distractions number THEN the system SHALL show a "share your achievement" option
4. WHEN clicking "share your achievement" THEN the system SHALL download an image of the numbers to the user's Downloads folder with proper permissions
5. WHEN the achievement image is generated THEN the system SHALL style it as if the numbers are in a macOS window

### Requirement 33

**User Story:** As a user, I want the note title to remain stable and properly styled during editing, so that I can focus on writing without visual distractions.

#### Acceptance Criteria

1. WHEN editing a note title THEN the system SHALL keep the title field in a fixed position that doesn't move up and down
2. WHEN the title is displayed THEN the system SHALL use bold font weight with 36px font size
3. WHEN typing in the title field THEN the system SHALL maintain stable positioning regardless of cursor placement
4. WHEN the title field is focused THEN the system SHALL prevent any vertical movement or layout shifts

### Requirement 34

**User Story:** As a user, I want natural cursor behavior in the note body, so that I can edit text efficiently at any position.

#### Acceptance Criteria

1. WHEN clicking anywhere in the note body text THEN the system SHALL place the cursor at the exact clicked position
2. WHEN typing in the note body THEN the system SHALL insert text at the current cursor position
3. WHEN editing text in the middle of the body THEN the system SHALL NOT automatically move the cursor to the end
4. WHEN the cursor is positioned anywhere in the text THEN the system SHALL maintain that position during typing

### Requirement 35

**User Story:** As a user, I want to download my distraction logs for AI analysis, so that I can get insights about my focus patterns.

#### Acceptance Criteria

1. WHEN viewing the distraction log THEN the system SHALL display a "Get diagnosed by ChatGPT" button next to "Recent Distractions"
2. WHEN the "Get diagnosed by ChatGPT" button is clicked THEN the system SHALL download a text file containing all distraction logs with date, time, and reason
3. WHEN the download is complete THEN the system SHALL show a message "Diagnosis log downloaded successfully!"
4. WHEN the success message is shown THEN the system SHALL display a "Go to ChatGPT" button with a link icon
5. WHEN the "Go to ChatGPT" button is clicked THEN the system SHALL open chatgpt.com in the default browser

### Requirement 36

**User Story:** As a user, I want to reflect on my notes with AI assistance, so that I can gain deeper insights into my writing.

#### Acceptance Criteria

1. WHEN viewing the note editor controls THEN the system SHALL display a "Reflect with AI" button next to the timer controls
2. WHEN the "Reflect with AI" button is clicked THEN the system SHALL open a large modal dialog
3. WHEN the reflection modal is displayed THEN the system SHALL show the current note content in a scrollable text box
4. WHEN the reflection modal is displayed THEN the system SHALL provide a "Copy to Clipboard" button for the note content
5. WHEN the reflection modal is displayed THEN the system SHALL provide a "Go to ChatGPT" button at the bottom
6. WHEN the "Go to ChatGPT" button is clicked THEN the system SHALL open chatgpt.com in the default browser

### Requirement 37

**User Story:** As a user, I want the app to be called "Solo" with an appropriate logo, so that it reflects the focused, individual nature of the note-taking experience.

#### Acceptance Criteria

1. WHEN the app is displayed in macOS THEN the system SHALL show "Solo" as the application name
2. WHEN the app icon is displayed THEN the system SHALL use the logo from the specified logo folder
3. WHEN the app is referenced in the interface THEN the system SHALL consistently use "Solo" branding
4. WHEN the app appears in the dock or applications folder THEN the system SHALL display the new logo and "Solo" name