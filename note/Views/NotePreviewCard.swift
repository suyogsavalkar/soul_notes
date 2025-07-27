//
//  NotePreviewCard.swift
//  note
//
//  Created by Kiro on 26/07/25.
//

import SwiftUI

struct NotePreviewCard: View {
    let note: Note
    let onTap: () -> Void
    let onDelete: (() -> Void)?
    
    @State private var isHovered = false
    @State private var showingDeleteConfirmation = false
    @EnvironmentObject var themeManager: ThemeManager
    
    init(note: Note, onTap: @escaping () -> Void, onDelete: (() -> Void)? = nil) {
        self.note = note
        self.onTap = onTap
        self.onDelete = onDelete
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                // Title
                HStack {
                    Text(note.title.isEmpty ? "Untitled" : note.title)
                        .font(.cardTitle)
                        .foregroundColor(themeManager.textColor)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                }
                
                // Preview text
                if !note.body.isEmpty {
                    Text(note.preview)
                        .font(.cardPreview)
                        .foregroundColor(themeManager.secondaryTextColor)
                        .lineLimit(4)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    Text("No content")
                        .font(.cardPreview)
                        .foregroundColor(themeManager.secondaryTextColor.opacity(0.5))
                        .italic()
                }
                
                Spacer()
                
                // Footer with date (bottom left) and delete button (bottom right)
                HStack {
                    // Date in bottom left
                    Text(formatDate(note.modifiedAt))
                        .font(.dmSans(size: 10))
                        .foregroundColor(themeManager.secondaryTextColor)
                    
                    Spacer()
                    
                    // Delete button in bottom right (only show if onDelete is provided and card is hovered)
                    if let onDelete = onDelete, isHovered {
                        Button(action: {
                            showingDeleteConfirmation = true
                        }) {
                            Image(systemName: "trash")
                                .font(.system(size: 14))
                                .foregroundColor(.red)
                                .frame(width: 16, height: 16)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .accessibilityLabel("Delete note")
                        .accessibilityHint("Deletes this note permanently")
                        .transition(.opacity.combined(with: .scale))
                    }
                }
            }
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .aspectRatio(1.0, contentMode: .fill)
            .background(themeManager.cardBackgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isHovered ? themeManager.accentColor : themeManager.cardBorderColor,
                        lineWidth: isHovered ? 2 : 1
                    )
            )
            .cornerRadius(12)
            .shadow(
                color: isHovered ? themeManager.accentColor.opacity(0.2) : Color.clear,
                radius: isHovered ? 8 : 0,
                x: 0,
                y: 2
            )
            .scaleEffect(isHovered ? 1.02 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isHovered)
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel("Note: \(note.title.isEmpty ? "Untitled" : note.title)")
        .accessibilityValue(note.body.isEmpty ? "No content" : note.preview)
        .accessibilityHint("Double-tap to edit this note")
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovered = hovering
            }
        }
        .alert("Delete Note", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete?()
            }
        } message: {
            Text("Are you sure you want to delete \"\(note.title.isEmpty ? "Untitled" : note.title)\"? This action cannot be undone.")
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        
        if calendar.isDate(date, inSameDayAs: Date()) {
            formatter.timeStyle = .short
            return "Today, \(formatter.string(from: date))"
        } else if let yesterday = calendar.date(byAdding: .day, value: -1, to: Date()),
                  calendar.isDate(date, inSameDayAs: yesterday) {
            formatter.timeStyle = .short
            return "Yesterday, \(formatter.string(from: date))"
        } else if let weekAgo = calendar.date(byAdding: .weekOfYear, value: -1, to: Date()),
                  date > weekAgo {
            formatter.dateFormat = "EEEE"
            return formatter.string(from: date)
        } else {
            formatter.dateStyle = .short
            return formatter.string(from: date)
        }
    }
}

#Preview {
    let sampleNote = Note(
        title: "Meeting Notes",
        body: "Discussed project timeline and deliverables for the upcoming quarter. Need to follow up on budget approval and resource allocation.",
        categoryId: UUID()
    )
    
    HStack(spacing: 16) {
        NotePreviewCard(note: sampleNote, onTap: {}, onDelete: {})
        
        NotePreviewCard(
            note: Note(title: "", body: "", categoryId: UUID()),
            onTap: {},
            onDelete: {}
        )
    }
    .environmentObject(ThemeManager())
    .padding()
    .frame(width: 600, height: 250)
}