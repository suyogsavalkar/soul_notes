//
//  TitleEditor.swift
//  note
//
//  Created by Kiro on 29/07/25.
//

import SwiftUI

struct TitleEditor: View {
    @Binding var title: String
    @FocusState private var isFocused: Bool
    @EnvironmentObject var themeManager: ThemeManager
    
    let fontSize: CGFloat = 36
    let characterLimit: Int = 35
    let onTextChange: (String, String) -> Void
    let onImmediateSave: (String, String) -> Void
    
    var body: some View {
        TextField("Untitled", text: titleBinding)
            .font(.dmSansSemiBold(size: fontSize))
            .foregroundColor(themeManager.textColor)
            .textFieldStyle(PlainTextFieldStyle())
            .focused($isFocused)
            .onSubmit {
                // Move focus to body when user presses Enter
                NotificationCenter.default.post(name: .titleSubmitted, object: nil)
            }
            .onChange(of: title) { oldValue, newValue in
                handleTitleChange(oldValue: oldValue, newValue: newValue)
            }
    }
    
    // MARK: - Private Properties
    
    private var titleBinding: Binding<String> {
        Binding(
            get: { title },
            set: { newValue in
                let truncatedValue = String(newValue.prefix(characterLimit))
                if title != truncatedValue {
                    title = truncatedValue
                }
            }
        )
    }
    
    // MARK: - Private Methods
    
    private func handleTitleChange(oldValue: String, newValue: String) {
        let truncatedValue = String(newValue.prefix(characterLimit))
        
        // Only trigger callbacks if the value actually changed
        if oldValue != truncatedValue {
            // Immediate save for data persistence
            onImmediateSave(oldValue, truncatedValue)
            
            // Debounced UI updates
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                onTextChange(oldValue, truncatedValue)
            }
        }
    }
}

// MARK: - Focus Management Extensions

extension TitleEditor {
    func setFocus(_ focused: Bool) {
        isFocused = focused
    }
    
    var isCurrentlyFocused: Bool {
        return isFocused
    }
}

// MARK: - Notification Names

extension Notification.Name {
    static let titleSubmitted = Notification.Name("titleSubmitted")
}

#Preview {
    @State var sampleTitle = "Sample Note Title"
    
    return TitleEditor(
        title: $sampleTitle,
        onTextChange: { oldValue, newValue in
            print("Title changed from '\(oldValue)' to '\(newValue)'")
        },
        onImmediateSave: { oldValue, newValue in
            print("Title immediate save: '\(newValue)'")
        }
    )
    .environmentObject(ThemeManager())
    .padding()
    .frame(width: 600, height: 100)
}