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
    @State private var selectedCategory: Category?
    @State private var selectedNote: Note?
    @State private var showingSidebar: Bool = true
    @State private var sidebarVisibility: NavigationSplitViewVisibility = .all
    @State private var showingFocusLog: Bool = false
    
    var body: some View {
        NavigationSplitView(columnVisibility: $sidebarVisibility) {
            // Sidebar
            SidebarView(
                selectedCategory: $selectedCategory,
                categories: noteManager.categories,
                onCategorySelect: { category in
                    selectedCategory = category
                    selectedNote = nil // Clear note selection when switching categories
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
                        },
                        onToggleSidebar: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                if sidebarVisibility == .all {
                                    sidebarVisibility = .detailOnly
                                } else {
                                    sidebarVisibility = .all
                                }
                            }
                        }
                    )
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .trailing).combined(with: .opacity)
                    ))
                } else if let selectedCategory = selectedCategory {
                    NotesGridView(
                        notes: noteManager.notes(for: selectedCategory),
                        onNoteSelect: { note in
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
                        }
                    )
                    .transition(.asymmetric(
                        insertion: .move(edge: .leading).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
                } else {
                    // Default state - show all notes or welcome screen
                    WelcomeView(
                        onGetStarted: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                if let firstCategory = noteManager.categories.first {
                                    selectedCategory = firstCategory
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
            FocusLogView(focusLogs: focusTimerManager.getFocusLogs())
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
    }
}