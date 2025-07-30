//
//  SearchBar.swift
//  note
//
//  Created by Kiro on 29/07/25.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    let placeholder: String
    let onSearchChange: (String) -> Void
    
    @EnvironmentObject var themeManager: ThemeManager
    @FocusState private var isSearchFocused: Bool
    
    init(searchText: Binding<String>, placeholder: String = "Search notes...", onSearchChange: @escaping (String) -> Void) {
        self._searchText = searchText
        self.placeholder = placeholder
        self.onSearchChange = onSearchChange
    }
    
    var body: some View {
        HStack(spacing: 8) {
            // Search icon
            Image(systemName: "magnifyingglass")
                .font(.system(size: 14))
                .foregroundColor(themeManager.secondaryTextColor)
                .frame(width: 16, height: 16)
            
            // Search text field
            TextField(placeholder, text: $searchText)
                .font(.dmSans(size: 14))
                .foregroundColor(themeManager.textColor)
                .textFieldStyle(PlainTextFieldStyle())
                .focused($isSearchFocused)
                .onChange(of: searchText) { _, newValue in
                    onSearchChange(newValue)
                }
                .onSubmit {
                    // Handle search submission if needed
                    onSearchChange(searchText)
                }
            
            // Clear button (only show when there's text)
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                    onSearchChange("")
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 14))
                        .foregroundColor(themeManager.secondaryTextColor)
                        .frame(width: 16, height: 16)
                }
                .buttonStyle(PlainButtonStyle())
                .accessibilityLabel("Clear search")
                .accessibilityHint("Clears the search text")
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(themeManager.cardBackgroundColor)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(
                    isSearchFocused ? themeManager.accentColor : themeManager.cardBorderColor,
                    lineWidth: isSearchFocused ? 2 : 1
                )
        )
        .animation(.easeInOut(duration: 0.2), value: isSearchFocused)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Search notes")
        .accessibilityHint("Type to search through all your notes")
    }
}

#Preview {
    @State var searchText = ""
    
    return VStack(spacing: 16) {
        SearchBar(
            searchText: $searchText,
            placeholder: "Search notes...",
            onSearchChange: { query in
                print("Search query: \(query)")
            }
        )
        
        SearchBar(
            searchText: .constant("Sample search text"),
            placeholder: "Search notes...",
            onSearchChange: { _ in }
        )
    }
    .environmentObject(ThemeManager())
    .padding()
    .frame(width: 300)
}