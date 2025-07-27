//
//  NoteEditorView.swift
//  note
//
//  Created by Kiro on 26/07/25.
//

import SwiftUI

struct NoteEditorView: View {
    @Binding var note: Note
    @State private var hasUnsavedChanges: Bool = false
    @State private var originalNote: Note
    @State private var autoSaveTimer: Timer?
    private let autoSaveDebouncer = PerformanceOptimizer.Debouncer(delay: 0.5)
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var fontSizeManager: FontSizeManager
    @EnvironmentObject var focusTimerManager: FocusTimerManager
    @State private var lastTypingTime: Date = Date()
    @State private var typingTimer: Timer?
    
    let onSave: () -> Void
    let onToggleSidebar: () -> Void
    
    init(note: Binding<Note>, onSave: @escaping () -> Void, onToggleSidebar: @escaping () -> Void) {
        self._note = note
        self._originalNote = State(initialValue: note.wrappedValue)
        self.onSave = onSave
        self.onToggleSidebar = onToggleSidebar
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Top bar with sidebar toggle and font size control
            HStack(spacing: 16) {
                Button(action: onToggleSidebar) {
                    Image(systemName: "sidebar.left")
                        .font(.system(size: 16))
                        .foregroundColor(themeManager.textColor)
                }
                .buttonStyle(PlainButtonStyle())
                
                // Font size control
                Button(action: {
                    fontSizeManager.cycleFontSize()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "textformat.size")
                            .font(.system(size: 14))
                            .foregroundColor(themeManager.textColor)
                        
                        Text("\(Int(fontSizeManager.currentBodyFontSize))px")
                            .font(.system(size: 12))
                            .foregroundColor(themeManager.secondaryTextColor)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(themeManager.secondaryTextColor.opacity(0.1))
                    )
                }
                .buttonStyle(PlainButtonStyle())
                .accessibilityLabel("Change font size")
                .accessibilityHint("Current size: \(Int(fontSizeManager.currentBodyFontSize)) pixels")
                
                // Focus timer control
                FocusTimerControl()
                    .environmentObject(focusTimerManager)
                    .environmentObject(themeManager)
                
                Spacer()
            }
            .padding(.leading, 16)
            .padding(.vertical, 12)
            .background(themeManager.backgroundColor)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(themeManager.dividerColor),
                alignment: .bottom
            )
            
            // Editor content
            GeometryReader { geometry in
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Title field
                        TextField("Note title", text: $note.title)
                            .font(fontSizeManager.titleFont)
                            .foregroundColor(themeManager.textColor)
                            .textFieldStyle(PlainTextFieldStyle())
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .onChange(of: note.title) { _ in
                                handleContentChange()
                                handleTypingActivity()
                            }
                        
                        // Body field
                        TextEditor(text: $note.body)
                            .font(fontSizeManager.bodyFont)
                            .foregroundColor(themeManager.textColor)
                            .scrollContentBackground(.hidden)
                            .background(Color.clear)
                            .frame(minHeight: max(400, geometry.size.height - 200))
                            .onChange(of: note.body) { _ in
                                handleContentChange()
                                handleTypingActivity()
                            }
                        
                        Spacer(minLength: 100) // Extra space at bottom
                    }
                    .padding(.horizontal, responsivePadding(for: geometry.size.width))
                    .padding(.top, 32)
                    .frame(maxWidth: responsiveMaxWidth(for: geometry.size.width))
                    .frame(maxWidth: .infinity) // Center the content
                }
            }
            .background(themeManager.backgroundColor)
            
            // Save button overlay
            if hasUnsavedChanges {
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button(hasUnsavedChanges ? "Save Changes" : "Saved") {
                            saveNote()
                        }
                        .buttonStyle(SaveButtonStyle(isSaved: !hasUnsavedChanges))
                        .keyboardShortcut("s", modifiers: .command)
                        
                        Spacer()
                    }
                    .padding(.bottom, 20)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.easeInOut(duration: 0.3), value: hasUnsavedChanges)
            }
        }
        .background(themeManager.backgroundColor)
        .onAppear {
            originalNote = note
        }
        .onDisappear {
            autoSaveTimer?.invalidate()
            autoSaveDebouncer.cancel()
            typingTimer?.invalidate()
        }
    }
    
    private func handleContentChange() {
        checkForChanges()
        scheduleAutoSave()
    }
    
    private func handleTypingActivity() {
        lastTypingTime = Date()
        
        // Reset typing timer
        typingTimer?.invalidate()
        
        // Only start monitoring if focus timer is running
        if focusTimerManager.isTimerRunning {
            typingTimer = Timer.scheduledTimer(withTimeInterval: 15.0, repeats: false) { _ in
                // User hasn't typed for 15 seconds
                focusTimerManager.handleTypingPause()
            }
        }
    }
    
    private func handleTypingActivity() {
        focusTimerManager.updateLastTypingTime()
    }
    
    private func checkForChanges() {
        hasUnsavedChanges = note.title != originalNote.title || note.body != originalNote.body
    }
    
    private func scheduleAutoSave() {
        autoSaveDebouncer.debounce {
            if self.hasUnsavedChanges {
                self.autoSave()
            }
        }
    }
    
    private func autoSave() {
        onSave()
        originalNote = note
        
        // Keep the save button visible briefly to show it was saved
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            hasUnsavedChanges = false
        }
    }
    
    private func saveNote() {
        autoSaveTimer?.invalidate()
        onSave()
        originalNote = note
        hasUnsavedChanges = false
    }
    
    // MARK: - Responsive Layout Helpers
    
    private func responsivePadding(for width: CGFloat) -> CGFloat {
        if width < 600 {
            return 20
        } else if width < 900 {
            return 30
        } else {
            return 40
        }
    }
    
    private func responsiveMaxWidth(for width: CGFloat) -> CGFloat {
        if width < 600 {
            return width - 40
        } else if width < 900 {
            return 700
        } else {
            return 800
        }
    }
}

struct SaveButtonStyle: ButtonStyle {
    let isSaved: Bool
    @EnvironmentObject var themeManager: ThemeManager
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.uiElement)
            .foregroundColor(isSaved ? themeManager.secondaryTextColor : Color.black)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(isSaved ? themeManager.secondaryTextColor.opacity(0.1) : themeManager.accentColor)
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(isSaved ? 0.05 : 0.1), radius: 4, x: 0, y: 2)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    @State var sampleNote = Note(
        title: "Sample Note",
        body: "This is a sample note with some content to demonstrate the editor interface.",
        categoryId: UUID()
    )
    
    return NoteEditorView(
        note: $sampleNote,
        onSave: { print("Save tapped") },
        onToggleSidebar: { print("Toggle sidebar") }
    )
    .environmentObject(ThemeManager())
    .frame(width: 800, height: 600)
}