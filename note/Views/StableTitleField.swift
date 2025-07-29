//
//  StableTitleField.swift
//  note
//
//  Created by Kiro on 28/07/25.
//

import SwiftUI

struct StableTitleField: View {
    @Binding var title: String
    let onTitleChange: () -> Void
    let onImmediateSave: (() -> Void)?
    
    @State private var localTitle: String = ""
    @State private var uiUpdateTimer: Timer?
    @FocusState private var isFocused: Bool
    @EnvironmentObject var themeManager: ThemeManager
    
    private let maxCharacters = 45
    
    init(title: Binding<String>, onTitleChange: @escaping () -> Void, onImmediateSave: (() -> Void)? = nil) {
        self._title = title
        self.onTitleChange = onTitleChange
        self.onImmediateSave = onImmediateSave
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Simplified container with proper baseline alignment
            ZStack(alignment: .leading) {
                // Placeholder text with matching baseline
                if localTitle.isEmpty && !isFocused {
                    Text("Note title")
                        .font(.dmSansBold(size: 36))
                        .foregroundColor(themeManager.secondaryTextColor.opacity(0.3))
                        .allowsHitTesting(false)
                }
                
                // Title input field with local binding
                TextField("", text: $localTitle)
                    .font(.dmSansBold(size: 36))
                    .foregroundColor(themeManager.textColor)
                    .textFieldStyle(PlainTextFieldStyle())
                    .focused($isFocused)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .focusEffectDisabled() // Remove focus ring/glow
                    .onChange(of: localTitle) { _, newValue in
                        // Enforce character limit
                        if newValue.count > maxCharacters {
                            localTitle = String(newValue.prefix(maxCharacters))
                            return
                        }
                        
                        // Immediate save for data persistence (0ms delay)
                        if title != localTitle {
                            title = localTitle
                            onImmediateSave?()
                        }
                        
                        // Debounced UI updates (100ms for responsiveness)
                        uiUpdateTimer?.invalidate()
                        uiUpdateTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
                            onTitleChange()
                        }
                    }
                    .onAppear {
                        localTitle = title
                    }
                    .onChange(of: title) { _, newValue in
                        // Only update local title if it's different and not from user typing
                        if localTitle != newValue && !isFocused {
                            localTitle = newValue
                        }
                    }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Character count indicator (only show when approaching limit)
            if localTitle.count > maxCharacters - 10 {
                HStack {
                    Spacer()
                    Text("\(localTitle.count)/\(maxCharacters)")
                        .font(.dmSans(size: 12))
                        .foregroundColor(localTitle.count >= maxCharacters ? .red : themeManager.secondaryTextColor)
                        .padding(.top, 4)
                }
            }
        }
    }
}

#Preview {
    @State var sampleTitle = "Sample Note Title"
    
    return StableTitleField(
        title: $sampleTitle,
        onTitleChange: {
            print("Title changed to: \(sampleTitle)")
        }
    )
    .environmentObject(ThemeManager())
    .padding()
    .frame(width: 600)
}