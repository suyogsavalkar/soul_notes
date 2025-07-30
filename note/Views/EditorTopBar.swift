//
//  EditorTopBar.swift
//  note
//
//  Created by Kiro on 28/07/25.
//

import SwiftUI

struct EditorTopBar: View {
    let wordCount: Int
    let hasUnsavedChanges: Bool
    let onToggleSidebar: () -> Void
    let onSave: () -> Void
    let onReflectWithAI: () -> Void
    let onClose: (() -> Void)?
    
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var fontSizeManager: FontSizeManager
    @EnvironmentObject var focusTimerManager: FocusTimerManager
    
    private var isReflectButtonEnabled: Bool {
        wordCount >= 150
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Left side controls
            HStack(spacing: 16) {
                // Sidebar toggle
                Button(action: onToggleSidebar) {
                    Image(systemName: "sidebar.left")
                        .font(.system(size: 16))
                        .foregroundColor(themeManager.textColor)
                }
                .buttonStyle(HoverButtonStyle())
                .accessibilityLabel("Toggle sidebar")
                
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
                .buttonStyle(HoverButtonStyle())
                .accessibilityLabel("Change font size")
                .accessibilityHint("Current size: \(Int(fontSizeManager.currentBodyFontSize)) pixels")
                
                // Focus timer control
                FocusTimerControl()
                    .environmentObject(focusTimerManager)
                    .environmentObject(themeManager)
                
                // Reflect with AI button (moved to left side, near timer)
                Button("Reflect with AI") {
                    onReflectWithAI()
                }
                .font(.dmSans(size: 12))
                .foregroundColor(isReflectButtonEnabled ? themeManager.accentColor : themeManager.secondaryTextColor)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(isReflectButtonEnabled ? themeManager.accentColor.opacity(0.1) : themeManager.secondaryTextColor.opacity(0.05))
                )
                .buttonStyle(HoverButtonStyle())
                .disabled(!isReflectButtonEnabled)
                .tooltip(
                    "Write at least 150 words first",
                    position: .top,
                    isEnabled: !isReflectButtonEnabled
                )
                .accessibilityLabel("Reflect with AI")
                .accessibilityHint(isReflectButtonEnabled ? "Available with \(wordCount) words" : "Requires at least 150 words")
            }
            
            Spacer()
            
            // Right side - save indicator and close button
            HStack(spacing: 12) {
                // Save indicator
                if hasUnsavedChanges {
                    Text("Saving...")
                        .font(.dmSans(size: 12))
                        .foregroundColor(themeManager.accentColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .accessibilityLabel("Saving changes")
                        .accessibilityHint("Note is being saved automatically")
                }
                
                // Close button
                if let onClose = onClose {
                    EditorCloseButton(onClose: onClose)
                        .environmentObject(themeManager)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(themeManager.backgroundColor)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(themeManager.dividerColor),
            alignment: .bottom
        )
    }
}

#Preview {
    EditorTopBar(
        wordCount: 75,
        hasUnsavedChanges: true,
        onToggleSidebar: { print("Toggle sidebar") },
        onSave: { print("Save") },
        onReflectWithAI: { print("Reflect with AI") },
        onClose: { print("Close") }
    )
    .environmentObject(ThemeManager())
    .environmentObject(FontSizeManager())
    .environmentObject(FocusTimerManager())
    .frame(width: 800)
}