//
//  NotesGridView.swift
//  note
//
//  Created by Kiro on 26/07/25.
//

import SwiftUI

struct NotesGridView: View {
    let notes: [Note]
    let onNoteSelect: (Note) -> Void
    let onCreateNote: () -> Void
    let onNoteDelete: ((Note) -> Void)?
    let isSearchActive: Bool
    let searchQuery: String
    let showSearchBar: Bool
    let onSearchChange: ((String) -> Void)?
    
    @State private var gridColumns: [GridItem] = []
    @State private var searchText: String = ""
    @EnvironmentObject var themeManager: ThemeManager
    
    init(notes: [Note], onNoteSelect: @escaping (Note) -> Void, onCreateNote: @escaping () -> Void, onNoteDelete: ((Note) -> Void)? = nil, isSearchActive: Bool = false, searchQuery: String = "", showSearchBar: Bool = false, onSearchChange: ((String) -> Void)? = nil) {
        self.notes = notes
        self.onNoteSelect = onNoteSelect
        self.onCreateNote = onCreateNote
        self.onNoteDelete = onNoteDelete
        self.isSearchActive = isSearchActive
        self.searchQuery = searchQuery
        self.showSearchBar = showSearchBar
        self.onSearchChange = onSearchChange
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Search bar (only show when enabled)
                if showSearchBar {
                    SearchBar(
                        searchText: $searchText,
                        placeholder: "Search all notes...",
                        onSearchChange: { query in
                            onSearchChange?(query)
                        }
                    )
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 8)
                }
                
                ScrollView {
                    if isSearchActive && notes.isEmpty {
                        // Empty search results state
                        SearchEmptyStateView(searchQuery: searchQuery)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(32)
                    } else {
                        LazyVGrid(columns: gridColumns, spacing: 12, pinnedViews: []) {
                            // Only show create note card when not searching
                            if !isSearchActive {
                                CreateNoteCard(onTap: onCreateNote)
                            }
                            
                            // Existing notes with lazy loading
                            ForEach(notes.indices, id: \.self) { index in
                                NotePreviewCard(
                                    note: notes[index],
                                    onTap: {
                                        onNoteSelect(notes[index])
                                    },
                                    onDelete: onNoteDelete != nil ? {
                                        onNoteDelete?(notes[index])
                                    } : nil
                                )
                                .onAppear {
                                    // Preload next batch if needed
                                    if PerformanceOptimizer.shouldLoadMore(items: notes, currentIndex: index) {
                                        // Could implement pagination here if needed
                                    }
                                }
                            }
                        }
                        .padding(16)
                    }
                }
            }
            .background(themeManager.backgroundColor)
            .onAppear {
                updateGridColumns(for: geometry.size.width)
            }
            .onChange(of: geometry.size.width) { _, width in
                updateGridColumns(for: width)
            }
        }
    }
    
    private func updateGridColumns(for width: CGFloat) {
        let minCardWidth: CGFloat = 180  // Reduced from 250 for smaller cards
        let maxCardWidth: CGFloat = 220  // Reduced from 320 for smaller cards
        let spacing: CGFloat = 12        // Reduced from 16 for more compact layout
        let padding: CGFloat = 32        // 16 on each side
        
        let availableWidth = width - padding
        
        // Calculate optimal number of columns for square cards
        var columnsCount = max(1, Int(availableWidth / (minCardWidth + spacing)))
        
        // Ensure cards don't get too wide (maintain square aspect ratio)
        let cardWidth = (availableWidth - CGFloat(columnsCount - 1) * spacing) / CGFloat(columnsCount)
        if cardWidth > maxCardWidth && columnsCount > 1 {
            columnsCount += 1
        }
        
        // Responsive breakpoints adjusted for smaller cards
        if width < 500 {
            columnsCount = 1
        } else if width < 800 {
            columnsCount = min(3, columnsCount)
        } else if width < 1100 {
            columnsCount = min(4, columnsCount)
        } else {
            columnsCount = min(5, columnsCount)
        }
        
        gridColumns = Array(repeating: GridItem(.flexible(), spacing: spacing), count: columnsCount)
    }
}

struct SearchEmptyStateView: View {
    let searchQuery: String
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(themeManager.secondaryTextColor.opacity(0.6))
            
            VStack(spacing: 8) {
                Text("No notes found")
                    .font(.dmSansMedium(size: 18))
                    .foregroundColor(themeManager.textColor)
                
                Text("No notes match \"\(searchQuery)\"")
                    .font(.dmSans(size: 14))
                    .foregroundColor(themeManager.secondaryTextColor)
                    .multilineTextAlignment(.center)
            }
            
            Text("Try searching with different keywords or check your spelling.")
                .font(.dmSans(size: 12))
                .foregroundColor(themeManager.secondaryTextColor.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("No search results found for \(searchQuery)")
    }
}

struct CreateNoteCard: View {
    let onTap: () -> Void
    @State private var isHovered = false
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                // Top spacer to center content vertically
                Spacer()
                
                VStack(spacing: 8) {
                    Image(systemName: "plus.circle")
                        .font(.system(size: 32))
                        .foregroundColor(themeManager.accentColor)
                    
                    Text("Create New Note")
                        .font(.cardTitle)
                        .foregroundColor(themeManager.secondaryTextColor)
                        .multilineTextAlignment(.center)
                }
                
                // Bottom spacer to center content vertically
                Spacer()
            }
            .padding(10) // Same padding as NotePreviewCard
            .frame(maxWidth: .infinity, alignment: .center)
            .aspectRatio(1.0, contentMode: .fill) // Same aspect ratio as NotePreviewCard
            .background(themeManager.cardBackgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isHovered ? themeManager.accentColor : themeManager.cardBorderColor,
                        style: StrokeStyle(lineWidth: 2, dash: [8, 4])
                    )
            )
            .cornerRadius(12)
            .shadow(
                color: isHovered ? themeManager.accentColor.opacity(0.2) : Color.clear,
                radius: isHovered ? 8 : 0,
                x: 0,
                y: 2
            ) // Same shadow as NotePreviewCard
            .scaleEffect(isHovered ? 1.02 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isHovered)
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel("Create New Note")
        .accessibilityHint("Creates a new note in the current category")
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovered = hovering
            }
        }
    }
}

#Preview {
    let sampleNotes = [
        Note(title: "Meeting Notes", body: "Discussed project timeline and deliverables for the upcoming quarter.", categoryId: UUID()),
        Note(title: "Ideas", body: "New app concept: A note-taking app with categories and grid view.", categoryId: UUID()),
        Note(title: "Shopping List", body: "Milk, Bread, Eggs, Apples, Bananas", categoryId: UUID())
    ]
    
    NotesGridView(
        notes: sampleNotes,
        onNoteSelect: { _ in },
        onCreateNote: { },
        onNoteDelete: { _ in }
    )
    .environmentObject(ThemeManager())
    .frame(width: 800, height: 600)
}