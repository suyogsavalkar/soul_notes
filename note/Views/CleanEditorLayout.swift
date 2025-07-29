//
//  CleanEditorLayout.swift
//  note
//
//  Created by Kiro on 28/07/25.
//

import SwiftUI

struct CleanEditorLayout: View {
    let content: () -> AnyView
    
    @EnvironmentObject var themeManager: ThemeManager
    
    init<Content: View>(@ViewBuilder content: @escaping () -> Content) {
        self.content = { AnyView(content()) }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    content()
                    
                    // Extra space at bottom for comfortable scrolling like a notepad
                    Spacer(minLength: 200)
                }
                .padding(.horizontal, notepadPadding(for: geometry.size.width))
                .padding(.top, 48)
                .padding(.bottom, 32)
                .frame(maxWidth: notepadMaxWidth(for: geometry.size.width))
                .frame(maxWidth: .infinity) // Center the content
            }
            .background(themeManager.backgroundColor)
            .scrollIndicators(.hidden) // Hide scroll indicators for cleaner notepad feel
        }
        .background(themeManager.backgroundColor)
    }
    
    // MARK: - Notepad Layout Helpers
    
    private func notepadPadding(for width: CGFloat) -> CGFloat {
        if width < 600 {
            return 32
        } else if width < 900 {
            return 48
        } else {
            return 64
        }
    }
    
    private func notepadMaxWidth(for width: CGFloat) -> CGFloat {
        if width < 600 {
            return width - 64
        } else if width < 900 {
            return 650
        } else {
            return 750
        }
    }
}

// MARK: - Clean Container View

struct CleanContainer<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .background(Color.clear) // Ensure no unexpected backgrounds
            .clipped() // Prevent overflow artifacts
            .frame(maxWidth: .infinity, alignment: .leading) // Consistent alignment
    }
}

// MARK: - View Extensions for Clean Layout

extension View {
    /// Applies clean layout styling to remove visual artifacts
    func cleanLayout() -> some View {
        self
            .background(Color.clear)
            .clipped()
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    /// Removes default TextEditor background and styling artifacts
    func cleanTextEditor() -> some View {
        self
            .scrollContentBackground(.hidden)
            .background(Color.clear)
            .textFieldStyle(PlainTextFieldStyle())
    }
}