//
//  Color+Theme.swift
//  note
//
//  Created by Kiro on 26/07/25.
//

import SwiftUI

extension Color {
    // MARK: - Static Colors (Theme-Independent)
    
    /// Accent color (pastel orange) - consistent across themes
    static let noteAccent = Color(red: 1.0, green: 0.8, blue: 0.6)
    
    // MARK: - Theme-Aware Colors
    // These will be replaced by ThemeManager properties in views
    
    /// Primary background color - use ThemeManager.backgroundColor instead
    static let noteBackground = Color.white
    
    /// Primary text color - use ThemeManager.textColor instead
    static let noteText = Color.black
    
    /// Secondary text color - use ThemeManager.secondaryTextColor instead
    static let secondaryText = Color.black.opacity(0.6)
    
    /// Sidebar background color - use ThemeManager.sidebarBackgroundColor instead
    static let sidebarBackground = Color(hex: "F8F9FA")
    
    /// Sidebar selected item background - use ThemeManager.sidebarSelectedColor instead
    static let sidebarSelected = Color.noteAccent.opacity(0.2)
    
    /// Card background color - use ThemeManager.cardBackgroundColor instead
    static let cardBackground = Color.white
    
    /// Card border color - use ThemeManager.cardBorderColor instead
    static let cardBorder = Color.black.opacity(0.1)
    
    /// Divider color - use ThemeManager.dividerColor instead
    static let divider = Color.gray.opacity(0.3)
    
    // MARK: - Utility Colors
    
    /// Focus ring color
    static let focusRing = Color.noteAccent
    
    /// Save button background
    static let saveButton = Color.noteAccent
    
    /// Save button text
    static let saveButtonText = Color.black
    
    // MARK: - Category Colors (using pastel orange variations)
    
    /// Category color variations for visual distinction
    static let categoryColors: [Color] = [
        Color.noteAccent,
        Color.noteAccent.opacity(0.8),
        Color.noteAccent.opacity(0.6),
        Color.noteAccent.opacity(0.4)
    ]
}

// MARK: - Hex Color Support

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}