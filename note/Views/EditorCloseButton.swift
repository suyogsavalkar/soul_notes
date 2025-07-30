//
//  EditorCloseButton.swift
//  note
//
//  Created by Kiro on 29/07/25.
//

import SwiftUI

struct EditorCloseButton: View {
    let onClose: () -> Void
    @State private var isHovered: Bool = false
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        Button(action: onClose) {
            Image(systemName: "xmark")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isHovered ? Color.red : themeManager.secondaryTextColor)
                .frame(width: 16, height: 16)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(8)
        .background(
            Circle()
                .fill(isHovered ? Color.red.opacity(0.1) : Color.clear)
        )
        .scaleEffect(isHovered ? 1.1 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isHovered)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovered = hovering
            }
        }
        .accessibilityLabel("Close note")
        .accessibilityHint("Returns to category view")
        .help("Close note (⌘W)")
    }
}

#Preview {
    HStack(spacing: 20) {
        EditorCloseButton(onClose: {
            print("Close button tapped")
        })
        
        // Show hover state
        EditorCloseButton(onClose: {})
            .onAppear {
                // This would show the hover state in preview
            }
    }
    .environmentObject(ThemeManager())
    .padding()
}