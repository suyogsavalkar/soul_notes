//
//  NoteEditorView.swift
//  note
//
//  Created by Kiro on 26/07/25.
//

import SwiftUI

struct NoteEditorView: View {
    @Binding var note: Note
    @State private var originalNote: Note
    @State private var editorState = EditorState()
    @State private var showReflectWithAI = false
    @State private var lastTypingTime: Date = Date()
    @State private var typingTimer: Timer?
    
    // Focus management
    @FocusState private var titleFocused: Bool
    @FocusState private var bodyFocused: Bool
    @StateObject private var focusManager = FocusManager()
    
    // State management
    @StateObject private var saveStateManager = SaveStateManager()
    @StateObject private var errorHandler = EditorErrorHandler()
    
    // Environment objects
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var fontSizeManager: FontSizeManager
    @EnvironmentObject var focusTimerManager: FocusTimerManager
    
    let onSave: () -> Void
    let onToggleSidebar: () -> Void
    
    init(note: Binding<Note>, onSave: @escaping () -> Void, onToggleSidebar: @escaping () -> Void) {
        self._note = note
        self._originalNote = State(initialValue: note.wrappedValue)
        self.onSave = onSave
        self.onToggleSidebar = onToggleSidebar
    }
    
    // MARK: - Computed Properties
    
    /// Combined word count of title and body content
    var wordCount: Int {
        return WordCountCalculator.combinedWordCount(title: note.title, body: note.body)
    }
    
    /// Whether the "Reflect with AI" button should be enabled (150+ words required)
    var isReflectButtonEnabled: Bool {
        return WordCountCalculator.isReflectButtonEnabled(title: note.title, body: note.body)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Top bar with all controls
            EditorTopBar(
                wordCount: wordCount,
                hasUnsavedChanges: saveStateManager.shouldShowSaveButton,
                onToggleSidebar: onToggleSidebar,
                onSave: {
                    Task {
                        await performSave()
                    }
                },
                onReflectWithAI: {
                    showReflectWithAI = true
                }
            )
            .environmentObject(themeManager)
            .environmentObject(fontSizeManager)
            .environmentObject(focusTimerManager)
            
            // Editor content with clean layout
            CleanEditorLayout {
                VStack(alignment: .leading, spacing: 24) {
                    // Stable title field
                    StableTitleField(
                        title: $note.title,
                        onTitleChange: {
                            handleDebouncedUIUpdates()
                        },
                        onImmediateSave: {
                            handleImmediateSave()
                        }
                    )
                    .focused($titleFocused)
                    .managedFocus(focusManager, field: .title, themeManager: themeManager)
                    .environmentObject(themeManager)
                    
                    // Improved body editor
                    ImprovedBodyEditor(
                        text: $note.body,
                        fontSize: fontSizeManager.currentBodyFontSize,
                        textColor: themeManager.textColor,
                        minHeight: 300,
                        onTextChange: { oldValue, newValue in
                            // Only validate and update state after debounced changes
                            if errorHandler.validateTextInput(newValue, field: "body") {
                                handleDebouncedUIUpdates()
                            }
                        },
                        onImmediateSave: { oldValue, newValue in
                            handleImmediateSave()
                        }
                    )
                    .focused($bodyFocused)
                    .managedFocus(focusManager, field: .body, themeManager: themeManager)
                    .environmentObject(themeManager)
                }
            }
            .environmentObject(themeManager)
        }
        .background(themeManager.backgroundColor)
        .onAppear {
            setupEditor()
        }
        .onDisappear {
            cleanupEditor()
        }
        .onChange(of: titleFocused) { _, focused in
            if focused {
                focusManager.setFocus(to: .title)
            }
        }
        .onChange(of: bodyFocused) { _, focused in
            if focused {
                focusManager.setFocus(to: .body)
            }
        }
        .sheet(isPresented: $showReflectWithAI) {
            NoteReflectionView(
                noteTitle: note.title,
                noteContent: note.body,
                isPresented: $showReflectWithAI
            )
            .environmentObject(themeManager)
        }
        .overlay(
            EditorErrorAlert(errorHandler: errorHandler)
        )
    }
    
    // MARK: - Smart Debouncing Handlers
    
    private func handleImmediateSave() {
        // Immediate save (0ms) - just persist the data
        performSaveOperation()
    }
    
    private func handleDebouncedUIUpdates() {
        // UI updates (100ms) - word count, validation, etc.
        updateEditorState()
        handleFocusTimerUpdates()
    }
    
    private func handleFocusTimerUpdates() {
        // Focus timer updates (500ms) - less critical
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.handleTypingActivity()
        }
    }
    
    private func handleContentChange() {
        updateEditorState()
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
    
    private func updateEditorState() {
        editorState.update(
            title: note.title,
            body: note.body,
            originalTitle: originalNote.title,
            originalBody: originalNote.body
        )
        
        // Update save state manager
        if editorState.hasUnsavedChanges {
            saveStateManager.markAsUnsaved()
        }
    }
    
    private func scheduleAutoSave() {
        if editorState.hasUnsavedChanges {
            saveStateManager.scheduleAutoSave {
                self.performSaveOperation()
            }
        }
    }
    
    private func performSaveOperation() {
        // Create content backup before saving
        errorHandler.createContentBackup(title: note.title, body: note.body)
        
        // Perform the actual save
        onSave()
        
        // Update state after successful save
        originalNote = note
        editorState.markAsSaved()
    }
    
    private func performSave() async {
        let success = await saveStateManager.performImmediateSave {
            self.performSaveOperation()
        }
        
        if !success {
            // Handle save failure
            errorHandler.handleError(.saveFailure(underlying: NSError(domain: "SaveError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to save note"])))
        }
    }
    
    private func setupEditor() {
        originalNote = note
        updateEditorState()
        
        // Set up focus recovery notification
        NotificationCenter.default.addObserver(
            forName: .editorFocusRecovery,
            object: nil,
            queue: .main
        ) { _ in
            self.focusManager.restorePreviousFocus()
        }
    }
    
    private func cleanupEditor() {
        typingTimer?.invalidate()
        focusManager.cleanup()
        saveStateManager.reset()
        
        // Remove notification observer
        NotificationCenter.default.removeObserver(self, name: .editorFocusRecovery, object: nil)
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