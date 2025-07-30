//
//  ButtonStyles.swift
//  note
//
//  Created by Kiro on 30/07/25.
//

import SwiftUI

// MARK: - Hover Button Style

struct HoverButtonStyle: ButtonStyle {
    @State private var isHovered = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(isHovered ? 1.05 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : (isHovered ? 1.0 : 0.9))
            .animation(.easeInOut(duration: 0.15), value: isHovered)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
            .onHover { hovering in
                isHovered = hovering
            }
    }
}

// MARK: - Secondary Button Style (for cancel/secondary actions)

struct SecondaryButtonStyle: ButtonStyle {
    @State private var isHovered = false
    @EnvironmentObject var themeManager: ThemeManager
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.dmSans(size: 14))
            .foregroundColor(themeManager.secondaryTextColor)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(themeManager.secondaryTextColor.opacity(0.1))
            )
            .scaleEffect(isHovered ? 1.02 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: isHovered)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
            .onHover { hovering in
                isHovered = hovering
            }
    }
}

// MARK: - Primary Button Style (for main actions)

struct PrimaryButtonStyle: ButtonStyle {
    @State private var isHovered = false
    @EnvironmentObject var themeManager: ThemeManager
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.dmSansMedium(size: 14))
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(themeManager.accentColor)
            )
            .scaleEffect(isHovered ? 1.02 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: isHovered)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
            .onHover { hovering in
                isHovered = hovering
            }
    }
}