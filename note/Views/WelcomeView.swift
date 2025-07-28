//
//  WelcomeView.swift
//  note
//
//  Created by Kiro on 26/07/25.
//

import SwiftUI

struct WelcomeView: View {
    let onCreateNote: () -> Void
    @State private var isHovered = false
    @EnvironmentObject var themeManager: ThemeManager
    
    var cardDimensions: CGSize {
        // Matches NotePreviewCard dimensions exactly
        return CGSize(width: 180, height: 180) // Square aspect ratio
    }
    
    var body: some View {
        Button(action: onCreateNote) {
            VStack(spacing: 12) {
                // Top spacer to center content vertically
                Spacer()
                
                VStack(spacing: 8) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(themeManager.accentColor)
                    
                    Text("Create Note")
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
    WelcomeView(onCreateNote: {})
        .environmentObject(ThemeManager())
        .frame(width: 200, height: 200)
        .padding()
}

