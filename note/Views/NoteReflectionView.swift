//
//  NoteReflectionView.swift
//  note
//
//  Created by Kiro on 28/07/25.
//

import SwiftUI

struct NoteReflectionView: View {
    let noteContent: String
    @Binding var isPresented: Bool
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            HStack {
                Text("Reflect with AI")
                    .font(.dmSansBold(size: 24))
                    .foregroundColor(themeManager.textColor)
                
                Spacer()
                
                Button("Close") {
                    isPresented = false
                }
                .buttonStyle(HoverButtonStyle())
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            
            // Note content display
            VStack(alignment: .leading, spacing: 12) {
                Text("Note Content")
                    .font(.dmSansMedium(size: 18))
                    .foregroundColor(themeManager.textColor)
                
                ScrollView {
                    Text(noteContent.isEmpty ? "This note is empty." : noteContent)
                        .font(.dmSans(size: 14))
                        .foregroundColor(themeManager.textColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(themeManager.cardBackgroundColor)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(themeManager.cardBorderColor, lineWidth: 1)
                        )
                }
                .frame(maxHeight: 300)
            }
            .padding(.horizontal, 24)
            
            // Action buttons
            HStack(spacing: 16) {
                Button("Copy to Clipboard") {
                    copyToClipboard()
                }
                .font(.dmSans(size: 14))
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(themeManager.secondaryTextColor)
                .cornerRadius(6)
                .buttonStyle(HoverButtonStyle())
                
                Button("Go to ChatGPT") {
                    openChatGPT()
                }
                .font(.dmSans(size: 14))
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(themeManager.accentColor)
                .cornerRadius(6)
                .buttonStyle(HoverButtonStyle())
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
        .background(themeManager.backgroundColor)
        .frame(minWidth: 500, minHeight: 400)
    }
    
    private func copyToClipboard() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        
        let fullContent = """
        Note Content:
        \(noteContent.isEmpty ? "This note is empty." : noteContent)
        
        Please help me reflect on this note and provide insights about:
        1. Key themes and ideas
        2. Areas for further development
        3. Questions to explore deeper
        4. Connections to other concepts
        5. Action items or next steps
        """
        
        pasteboard.setString(fullContent, forType: .string)
        
        // Show brief feedback
        // You could add a toast notification here
    }
    
    private func openChatGPT() {
        if let url = URL(string: "https://chatgpt.com") {
            NSWorkspace.shared.open(url)
        }
    }
}

#Preview {
    @State var isPresented = true
    
    return NoteReflectionView(
        noteContent: "This is a sample note with some content to demonstrate the reflection interface.",
        isPresented: $isPresented
    )
    .environmentObject(ThemeManager())
    .frame(width: 600, height: 500)
}