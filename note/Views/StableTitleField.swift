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
        VStack(alignment: .leading, spacing: 8) {
            // Simple, stable title input with proper alignment
            ZStack(alignment: .leading) {
                // Invisible text for consistent height calculation
                Text("Ag")
                    .font(.dmSansBold(size: 36))
                    .foregroundColor(.clear)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                TextField("Note title", text: $localTitle)
                    .font(.dmSansBold(size: 36))
                    .foregroundColor(themeManager.textColor)
                    .textFieldStyle(PlainTextFieldStyle())
                    .focused($isFocused)
                    .lineLimit(1)
                    .focusEffectDisabled()
            }
            .frame(minHeight: 44)
                .onChange(of: localTitle) { _, newValue in
                    // Character limit enforcement
                    if newValue.count > maxCharacters {
                        localTitle = String(newValue.prefix(maxCharacters))
                        return
                    }
                    
                    // Immediate data sync
                    if title != localTitle {
                        title = localTitle
                        onImmediateSave?()
                    }
                    
                    // Debounced UI updates
                    uiUpdateTimer?.invalidate()
                    uiUpdateTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
                        onTitleChange()
                    }
                }
                .onAppear {
                    localTitle = title
                }
                .onChange(of: title) { _, newValue in
                    if localTitle != newValue && !isFocused {
                        localTitle = newValue
                    }
                }
            
            // Character count (only when approaching limit)
            if localTitle.count > maxCharacters - 10 {
                HStack {
                    Spacer()
                    Text("\(localTitle.count)/\(maxCharacters)")
                        .font(.dmSans(size: 12))
                        .foregroundColor(localTitle.count >= maxCharacters ? .red : themeManager.secondaryTextColor)
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