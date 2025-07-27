// //
// //  Font+DMSans.swift
// //  note
// //
// //  Created by Kiro on 26/07/25.
// //

// import SwiftUI

// extension Font {
//     // MARK: - DM Sans Font Family
    
//     /// DM Sans Regular font with specified size
//     static func dmSans(size: CGFloat) -> Font {
//         return Font.custom("DMSans-Regular", size: size)
//             .fallback(to: .system(size: size))
//     }
    
//     /// DM Sans Medium font with specified size
//     static func dmSansMedium(size: CGFloat) -> Font {
//         return Font.custom("DMSans-Medium", size: size)
//             .fallback(to: .system(size: size, weight: .medium))
//     }
    
//     /// DM Sans Bold font with specified size
//     static func dmSansBold(size: CGFloat) -> Font {
//         return Font.custom("DMSans-Bold", size: size)
//             .fallback(to: .system(size: size, weight: .bold))
//     }
    
//     // MARK: - App-Specific Font Styles
    
//     /// Note title font (32px DM Sans Medium)
//     static let noteTitle = Font.dmSansMedium(size: 32)
    
//     /// Note body font (16px DM Sans Regular)
//     static let noteBody = Font.dmSans(size: 16)
    
//     /// Sidebar category font (14px DM Sans Medium)
//     static let sidebarCategory = Font.dmSansMedium(size: 14)
    
//     /// Card title font (16px DM Sans Medium)
//     static let cardTitle = Font.dmSansMedium(size: 16)
    
//     /// Card preview font (12px DM Sans Regular)
//     static let cardPreview = Font.dmSans(size: 12)
    
//     /// UI elements font (13px DM Sans Regular)
//     static let uiElement = Font.dmSans(size: 13)
// }

// extension Font {
//     /// Fallback mechanism for custom fonts
//     func fallback(to fallbackFont: Font) -> Font {
//         // In a production app, you might want to check if the custom font is available
//         // For now, we'll assume the font files are properly bundled
//         return self
//     }
// }

//
//  Font+DMSans.swift
//  note
//
//  Created by Kiro on 26/07/25.
//

import SwiftUI

extension Font {
    // MARK: - DM Sans Font Family
    
    /// DM Sans Regular font with specified size
    static func dmSans(size: CGFloat) -> Font {
        return Font.custom("DMSans-Regular", size: size)
    }
    
    /// DM Sans Medium font with specified size
    static func dmSansMedium(size: CGFloat) -> Font {
        return Font.custom("DMSans-Medium", size: size)
    }
    
    /// DM Sans Bold font with specified size
    static func dmSansBold(size: CGFloat) -> Font {
        return Font.custom("DMSans-Bold", size: size)
    }
    
    // MARK: - App-Specific Font Styles
    
    /// Note title font (32px DM Sans Medium)
    static let noteTitle = Font.dmSansMedium(size: 32)
    
    /// Note body font (16px DM Sans Regular)
    static let noteBody = Font.dmSans(size: 16)
    
    /// Sidebar category font (14px DM Sans Medium)
    static let sidebarCategory = Font.dmSansMedium(size: 14)
    
    /// Card title font (16px DM Sans Medium)
    static let cardTitle = Font.dmSansMedium(size: 16)
    
    /// Card preview font (12px DM Sans Regular)
    static let cardPreview = Font.dmSans(size: 12)
    
    /// UI elements font (13px DM Sans Regular)
    static let uiElement = Font.dmSans(size: 13)
}