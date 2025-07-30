//
//  MainView.swift
//  note
//
//  Created by Kiro on 26/07/25.
//

import SwiftUI

struct MainView: View {
    @StateObject private var noteManager = NoteManager()
    @StateObject private var errorHandler = ErrorHandler()
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var fontSizeManager = FontSizeManager()
    @StateObject private var focusTimerManager = FocusTimerManager()
    @StateObject private var searchManager = SearchManager()
    @State private var selectedCategory: Category?
    @State private var selectedNote: Note?
    @State private var showingSidebar: Bool = true
    @State private var sidebarVisibility: NavigationSplitViewVisibility = .all
    @State private var showingFocusLog: Bool = false
    @State private var searchResults: [Note] = []
    
    var body: some View {
        NavigationSplitView(columnVisibility: $sidebarVisibility) {
            // Sidebar
            SidebarView(
                selectedCategory: $selectedCategory,
                categories: noteManager.categories,
                onCategorySelect: { category in
                    // Save current note before switching categories
                    if let currentNote = selectedNote {
                        noteManager.updateNote(currentNote)
                        noteManager.saveChangesImmediately()
                    }
                    
                    selectedCategory = category
                    selectedNote = nil // Clear note selection when switching categories
                    
                    // Clear search when switching categories
                    searchManager.clearSearch()
                    searchResults = []
                },
                onCategoryAdd: { name, iconName in
                    do {
                        let newCategory = try noteManager.createCategory(name: name, iconName: iconName)
                        selectedCategory = newCategory
                    } catch {
                        errorHandler.handle(error, context: "creating category")
                    }
                },
                onCategoryDelete: { category in
                    do {
                        try noteManager.deleteCategory(category)
                        // If the deleted category was selected, select the first available category
                        if selectedCategory?.id == category.id {
                            selectedCategory = noteManager.categories.first
                        }
                    } catch {
                        errorHandler.handle(error, context: "deleting category")
                    }
                },
                onFocusStatsClick: {
                    showingFocusLog = true
                }
            )
            .navigationSplitViewColumnWidth(min: 200, ideal: 250, max: 300)
        } detail: {
            // Main content area
            Group {
                if let selectedNote = selectedNote {
                    NoteEditorView(
                        note: Binding(
                            get: { selectedNote },
                            set: { updatedNote in
                                self.selectedNote = updatedNote
                                noteManager.updateNote(updatedNote)
                            }
                        ),
                        onSave: {
                            noteManager.updateNote(selectedNote)
                            // Force immediate save to disk
                            noteManager.saveChangesImmediately()
                        },
                        onToggleSidebar: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                if sidebarVisibility == .all {
                                    sidebarVisibility = .detailOnly
                                } else {
                                    sidebarVisibility = .all
                                }
                            }
                        },
                        onClose: {
                            // Save current note before closing
                            noteManager.updateNote(selectedNote)
                            noteManager.saveChangesImmediately()
                            
                            // Find the category that contains this note
                            let noteCategory = noteManager.categories.first { category in
                                category.id == selectedNote.categoryId
                            }
                            
                            // Set the selected category to the note's category (or fallback to General)
                            if let category = noteCategory {
                                selectedCategory = category
                            } else {
                                // Fallback to General category if note's category doesn't exist
                                selectedCategory = noteManager.categories.first { $0.name == "General" } ?? noteManager.categories.first
                            }
                            
                            // Clear the selected note to return to grid view
                            withAnimation(.easeInOut(duration: 0.3)) {
                                self.selectedNote = nil
                            }
                        }
                    )
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .trailing).combined(with: .opacity)
                    ))
                } else if let selectedCategory = selectedCategory {
                    NotesGridView(
                        notes: searchManager.isSearchActive ? searchResults : noteManager.notes(for: selectedCategory),
                        onNoteSelect: { note in
                            // Save current note before switching
                            if let currentNote = selectedNote {
                                noteManager.updateNote(currentNote)
                                noteManager.saveChangesImmediately()
                            }
                            
                            withAnimation(.easeInOut(duration: 0.3)) {
                                selectedNote = note
                            }
                        },
                        onCreateNote: {
                            let newNote = noteManager.createNote(in: selectedCategory)
                            withAnimation(.easeInOut(duration: 0.3)) {
                                selectedNote = newNote
                            }
                        },
                        onNoteDelete: { note in
                            withAnimation(.easeInOut(duration: 0.3)) {
                                // Clear selection if deleting the currently selected note
                                if selectedNote?.id == note.id {
                                    selectedNote = nil
                                }
                                noteManager.deleteNote(note)
                            }
                        },
                        isSearchActive: searchManager.isSearchActive,
                        searchQuery: searchManager.searchQuery,
                        showSearchBar: selectedCategory.name == "General",
                        onSearchChange: { query in
                            searchManager.updateSearch(query: query, in: noteManager.notes)
                            searchResults = searchManager.searchResults
                        }
                    )
                    .transition(.asymmetric(
                        insertion: .move(edge: .leading).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
                } else {
                    // Default state - show all notes or welcome screen
                    WelcomeView(
                        onCreateNote: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                if let firstCategory = noteManager.categories.first {
                                    selectedCategory = firstCategory
                                    let newNote = noteManager.createNote(in: firstCategory)
                                    selectedNote = newNote
                                }
                            }
                        }
                    )
                    .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: selectedNote)
            .animation(.easeInOut(duration: 0.3), value: selectedCategory)
        }
        .navigationSplitViewStyle(.balanced)
        .frame(minWidth: 800, minHeight: 600)
        .environmentObject(themeManager)
        .environmentObject(fontSizeManager)
        .environmentObject(focusTimerManager)
        .background(themeManager.backgroundColor)
        .alert("Error", isPresented: $errorHandler.showingError) {
            Button("OK") {
                errorHandler.clearError()
            }
        } message: {
            if let error = errorHandler.currentError {
                VStack(alignment: .leading) {
                    Text(error.localizedDescription)
                    if let suggestion = error.recoverySuggestion {
                        Text(suggestion)
                            .font(.caption)
                    }
                }
            }
        }
        .sheet(isPresented: $showingFocusLog) {
            FocusLogView(
                distractionStats: focusTimerManager.distractionStats,
                distractionLogs: focusTimerManager.getDistractionLogs()
            )
            .environmentObject(focusTimerManager)
            .environmentObject(themeManager)
        }
        .onAppear {
            // Initialize font loader
            _ = FontLoader.shared
            
            // Select first category by default
            if selectedCategory == nil, let firstCategory = noteManager.categories.first {
                selectedCategory = firstCategory
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSApplication.willTerminateNotification)) { _ in
            // Save any unsaved changes before app quits
            if let currentNote = selectedNote {
                noteManager.updateNote(currentNote)
                noteManager.saveChangesImmediately()
            }
        }
    }
}