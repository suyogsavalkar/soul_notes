//
//  DesignConstants.swift
//  note
//
//  Created by Kiro on 26/07/25.
//

import SwiftUI

/// Design constants for consistent styling throughout the app
struct DesignConstants {
    
    // MARK: - Corner Radius
    static let cardCornerRadius: CGFloat = 12
    static let buttonCornerRadius: CGFloat = 8
    static let inputCornerRadius: CGFloat = 8
    static let categoryRowCornerRadius: CGFloat = 6
    static let iconButtonCornerRadius: CGFloat = 6
    
    // MARK: - Spacing
    static let smallSpacing: CGFloat = 8
    static let mediumSpacing: CGFloat = 12
    static let largeSpacing: CGFloat = 16
    static let extraLargeSpacing: CGFloat = 24
    
    // MARK: - Padding
    static let smallPadding: CGFloat = 8
    static let mediumPadding: CGFloat = 12
    static let largePadding: CGFloat = 16
    static let extraLargePadding: CGFloat = 20
    
    // MARK: - Sizes
    static let iconSize: CGFloat = 16
    static let largeIconSize: CGFloat = 20
    static let buttonIconSize: CGFloat = 32
    static let categoryIconSize: CGFloat = 16
    
    // MARK: - Layout
    static let sidebarWidth: CGFloat = 250
    static let minWindowWidth: CGFloat = 800
    static let minWindowHeight: CGFloat = 600
    static let maxContentWidth: CGFloat = 800
    
    // MARK: - Animation
    static let defaultAnimationDuration: Double = 0.3
    static let quickAnimationDuration: Double = 0.2
    static let slowAnimationDuration: Double = 0.5
    
    // MARK: - Shadows
    static let cardShadowRadius: CGFloat = 8
    static let modalShadowRadius: CGFloat = 20
    static let buttonShadowRadius: CGFloat = 4
}

// MARK: - View Extensions for Consistent Styling

extension View {
    /// Applies consistent card styling
    func cardStyle(isHovered: Bool = false, theme: ThemeManager) -> some View {
        self
            .background(theme.cardBackgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: DesignConstants.cardCornerRadius)
                    .stroke(
                        isHovered ? theme.accentColor : theme.cardBorderColor,
                        lineWidth: isHovered ? 2 : 1
                    )
            )
            .cornerRadius(DesignConstants.cardCornerRadius)
            .shadow(
                color: isHovered ? theme.accentColor.opacity(0.2) : Color.clear,
                radius: isHovered ? DesignConstants.cardShadowRadius : 0,
                x: 0,
                y: 2
            )
    }
    
    /// Applies consistent button styling
    func primaryButtonStyle(theme: ThemeManager) -> some View {
        self
            .font(.dmSansMedium(size: 14))
            .foregroundColor(Color.black)
            .padding(.horizontal, DesignConstants.extraLargePadding)
            .padding(.vertical, DesignConstants.smallPadding + 2)
            .background(
                RoundedRectangle(cornerRadius: DesignConstants.buttonCornerRadius)
                    .fill(theme.accentColor)
            )
    }
    
    /// Applies consistent secondary button styling
    func secondaryButtonStyle(theme: ThemeManager) -> some View {
        self
            .font(.dmSansMedium(size: 14))
            .foregroundColor(theme.secondaryTextColor)
            .padding(.horizontal, DesignConstants.extraLargePadding)
            .padding(.vertical, DesignConstants.smallPadding + 2)
            .background(
                RoundedRectangle(cornerRadius: DesignConstants.buttonCornerRadius)
                    .fill(Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignConstants.buttonCornerRadius)
                            .stroke(theme.cardBorderColor, lineWidth: 1)
                    )
            )
    }
    
    /// Applies consistent input field styling
    func inputFieldStyle(theme: ThemeManager) -> some View {
        self
            .padding(.horizontal, DesignConstants.mediumPadding)
            .padding(.vertical, DesignConstants.smallPadding + 2)
            .background(
                RoundedRectangle(cornerRadius: DesignConstants.inputCornerRadius)
                    .fill(theme.cardBackgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignConstants.inputCornerRadius)
                            .stroke(theme.cardBorderColor, lineWidth: 1)
                    )
            )
    }
}