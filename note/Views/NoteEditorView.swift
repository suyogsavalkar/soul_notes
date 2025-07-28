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
    @State private var showReflectWithAI = false
    @FocusState private var isBodyFocused: Bool
    
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
                
                // Reflect with AI button
                Button("Reflect with AI") {
                    showReflectWithAI = true
                }
                .font(.dmSans(size: 12))
                .foregroundColor(themeManager.accentColor)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(themeManager.accentColor.opacity(0.1))
                )
                .buttonStyle(PlainButtonStyle())
                
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
                        // Title field with stable positioning and bold 36px font
                        VStack(alignment: .leading, spacing: 0) {
                            TextField("Note title", text: Binding(
                                get: { note.title },
                                set: { newValue in
                                    // Limit to 45 characters
                                    if newValue.count <= 45 {
                                        note.title = newValue
                                    }
                                }
                            ))
                            .font(.dmSansBold(size: 36)) // Bold 36px font as required
                            .foregroundColor(themeManager.textColor)
                            .textFieldStyle(PlainTextFieldStyle())
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .frame(height: 60, alignment: .leading) // Fixed height to accommodate 36px font with proper spacing
                            .padding(.top, 40) // Increased top margin for stability and prevent movement
                            .padding(.bottom, 20) // Bottom padding for visual separation
                            .onChange(of: note.title) {
                                handleContentChange()
                                handleTypingActivity()
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading) // Fixed positioning
                        .background(Color.clear) // Ensure stable background
                        .clipped() // Prevent any overflow that might cause movement
                        .fixedSize(horizontal: false, vertical: true) // Prevent vertical expansion
                        
                        // Body field with natural cursor positioning
                        ZStack(alignment: .topLeading) {
                            if note.body.isEmpty {
                                Text("Start writing...")
                                    .font(fontSizeManager.bodyFont)
                                    .foregroundColor(themeManager.secondaryTextColor.opacity(0.5))
                                    .padding(.top, 8)
                                    .padding(.leading, 4)
                                    .allowsHitTesting(false)
                            }
                            
                            TextEditor(text: $note.body)
                                .font(fontSizeManager.bodyFont)
                                .foregroundColor(themeManager.textColor)
                                .scrollContentBackground(.hidden)
                                .background(Color.clear)
                                .frame(minHeight: max(400, geometry.size.height - 200))
                                .focused($isBodyFocused)
                                .textSelection(.enabled) // Enable text selection and cursor positioning
                                .multilineTextAlignment(.leading) // Ensure proper text alignment
                                .onChange(of: note.body) { oldValue, newValue in
                                    // Only handle content change, don't interfere with cursor position
                                    // TextEditor naturally maintains cursor position during typing
                                    handleContentChange()
                                    handleTypingActivity()
                                }
                                .onTapGesture { _ in
                                    // Set focus when tapping, TextEditor handles cursor positioning automatically
                                    if !isBodyFocused {
                                        isBodyFocused = true
                                    }
                                }
                                .allowsHitTesting(true) // Ensure proper hit testing for cursor placement
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
        .sheet(isPresented: $showReflectWithAI) {
            NoteReflectionView(
                noteTitle: note.title,
                noteContent: note.body,
                isPresented: $showReflectWithAI
            )
            .environmentObject(themeManager)
        }
    }
    
    private func handleContentChange() {
        checkForChanges()
        scheduleAutoSave()
    }
    
    private func handleTypingActivity() {
        lastTypingTime = Date()
        focusTimerManager.updateLastTypingTime()
        
        // Reset typing timer
        typingTimer?.invalidate()
        
        // Only start monitoring if focus timer is running
        if focusTimerManager.isTimerRunning {
            typingTimer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: false) { _ in
                // User hasn't typed for 1 minute
                focusTimerManager.handleTypingPause()
            }
        }
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

struct ReflectWithAIView: View {
    let noteContent: String
    let noteTitle: String
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Text("Reflect with AI")
                    .font(.dmSansBold(size: 24))
                    .foregroundColor(themeManager.textColor)
                
                Spacer()
                
                Button("Done") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            
            // Note content display
            VStack(alignment: .leading, spacing: 12) {
                Text("Note: \(noteTitle.isEmpty ? "Untitled" : noteTitle)")
                    .font(.dmSansMedium(size: 18))
                    .foregroundColor(themeManager.textColor)
                
                ScrollView {
                    Text(noteContent.isEmpty ? "This note is empty." : noteContent)
                        .font(.dmSans(size: 14))
                        .foregroundColor(themeManager.textColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(themeManager.cardBackgroundColor)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(themeManager.cardBorderColor, lineWidth: 1)
                        )
                }
                .frame(maxHeight: 300)
            }
            .padding(.horizontal, 24)
            
            // Action buttons
            HStack(spacing: 16) {
                Button("Copy to Clipboard") {
                    let pasteboard = NSPasteboard.general
                    pasteboard.clearContents()
                    
                    let fullContent = """
                    Note Title: \(noteTitle.isEmpty ? "Untitled" : noteTitle)
                    
                    Content:
                    \(noteContent.isEmpty ? "This note is empty." : noteContent)
                    
                    Please help me reflect on this note and provide insights about:
                    1. Key themes and ideas
                    2. Areas for further development
                    3. Questions to explore deeper
                    4. Connections to other concepts
                    5. Action items or next steps
                    """
                    
                    pasteboard.setString(fullContent, forType: .string)
                    
                    // Show brief feedback
                    // You could add a toast notification here
                }
                .font(.dmSans(size: 14))
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(themeManager.secondaryTextColor)
                .cornerRadius(6)
                .buttonStyle(PlainButtonStyle())
                
                Button("Go to ChatGPT") {
                    if let url = URL(string: "https://chatgpt.com") {
                        NSWorkspace.shared.open(url)
                    }
                }
                .font(.dmSans(size: 14))
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(themeManager.accentColor)
                .cornerRadius(6)
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
        .background(themeManager.backgroundColor)
        .frame(minWidth: 500, minHeight: 400)
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