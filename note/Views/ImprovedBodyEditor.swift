//
//  ImprovedBodyEditor.swift
//  note
//
//  Created by Kiro on 28/07/25.
//

import SwiftUI

struct ImprovedBodyEditor: View {
    @Binding var text: String
    let fontSize: CGFloat
    let textColor: Color
    let minHeight: CGFloat
    let onTextChange: (String, String) -> Void
    let onImmediateSave: ((String, String) -> Void)?
    
    @State private var localText: String = ""
    @State private var uiUpdateTimer: Timer?
    @FocusState private var isFocused: Bool
    @EnvironmentObject var themeManager: ThemeManager
    
    init(text: Binding<String>, fontSize: CGFloat, textColor: Color, minHeight: CGFloat, onTextChange: @escaping (String, String) -> Void, onImmediateSave: ((String, String) -> Void)? = nil) {
        self._text = text
        self.fontSize = fontSize
        self.textColor = textColor
        self.minHeight = minHeight
        self.onTextChange = onTextChange
        self.onImmediateSave = onImmediateSave
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // Placeholder text
            if localText.isEmpty && !isFocused {
                Text("Start writing...")
                    .font(.dmSans(size: fontSize))
                    .foregroundColor(themeManager.secondaryTextColor.opacity(0.3))
                    .padding(.top, 8)
                    .padding(.leading, 4)
                    .allowsHitTesting(false)
            }
            
            // Native TextEditor with local binding for smooth typing
            TextEditor(text: $localText)
                .font(.dmSans(size: fontSize))
                .foregroundColor(textColor)
                .focused($isFocused)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .frame(minHeight: minHeight)
                .focusEffectDisabled() // Remove focus ring/glow
                .onChange(of: localText) { oldValue, newValue in
                    // Immediate save for data persistence (0ms delay)
                    if text != newValue {
                        text = newValue
                        onImmediateSave?(oldValue, newValue)
                    }
                    
                    // Debounced UI updates to prevent cursor jumping (100ms for responsiveness)
                    uiUpdateTimer?.invalidate()
                    uiUpdateTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
                        onTextChange(oldValue, newValue)
                    }
                }
                .onAppear {
                    localText = text
                }
                .onChange(of: text) { _, newValue in
                    // Only update local text if it's different and not from user typing
                    if localText != newValue && !isFocused {
                        localText = newValue
                    }
                }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}

#Preview {
    @State var sampleText = "This is sample text for the improved body editor."
    
    return ImprovedBodyEditor(
        text: $sampleText,
        fontSize: 16,
        textColor: .primary,
        minHeight: 400,
        onTextChange: { old, new in
            print("Text changed from '\(old)' to '\(new)'")
        }
    )
    .environmentObject(ThemeManager())
    .padding()
    .frame(width: 600, height: 500)
}