//
//  FontLoader.swift
//  note
//
//  Created by Kiro on 26/07/25.
//

import Foundation
import CoreText
import AppKit

class FontLoader {
    static let shared = FontLoader()
    
    private init() {
        loadCustomFonts()
    }
    
    private func loadCustomFonts() {
        let fontNames = [
            "DMSans-Regular",
            "DMSans-Medium", 
            "DMSans-Bold"
        ]
        
        for fontName in fontNames {
            loadFont(named: fontName)
        }
    }
    
    private func loadFont(named fontName: String) {
        guard let fontURL = Bundle.main.url(forResource: fontName, withExtension: "ttf") else {
            print("Warning: Could not find font file \(fontName).ttf")
            return
        }
        
        guard let fontData = NSData(contentsOf: fontURL) else {
            print("Warning: Could not load font data for \(fontName)")
            return
        }
        
        guard let provider = CGDataProvider(data: fontData) else {
            print("Warning: Could not create data provider for \(fontName)")
            return
        }
        
        guard let font = CGFont(provider) else {
            print("Warning: Could not create font from data for \(fontName)")
            return
        }
        
        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(font, &error) {
            if let error = error?.takeRetainedValue() {
                print("Warning: Failed to register font \(fontName): \(error)")
            }
        } else {
            print("Successfully loaded font: \(fontName)")
        }
    }
    
    /// Check if a custom font is available
    static func isFontAvailable(_ fontName: String) -> Bool {
        let font = NSFont(name: fontName, size: 12)
        return font != nil
    }
}