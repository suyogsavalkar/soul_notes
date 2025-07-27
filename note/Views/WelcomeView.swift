//
//  WelcomeView.swift
//  note
//
//  Created by Kiro on 26/07/25.
//

import SwiftUI

struct WelcomeView: View {
    let onGetStarted: () -> Void
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "doc.text")
                .font(.system(size: 64))
                .foregroundColor(themeManager.accentColor)
            
            VStack(spacing: 8) {
                Text("Welcome to Soul")
                    .font(.dmSansBold(size: 28))
                    .foregroundColor(themeManager.textColor)
                
                Text("Select a category from the sidebar to get started")
                    .font(.uiElement)
                    .foregroundColor(themeManager.secondaryTextColor)
            }
            
            Button("Get Started") {
                onGetStarted()
            }
            .buttonStyle(PrimaryButtonStyle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(themeManager.backgroundColor)
    }
}

