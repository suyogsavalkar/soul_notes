//
//  SFSymbolPicker.swift
//  note
//
//  Created by Kiro on 26/07/25.
//

import SwiftUI

struct SFSymbolPicker: View {
    @Binding var selectedIcon: String
    @Binding var searchText: String
    @EnvironmentObject var themeManager: ThemeManager
    
    let availableIcons: [String] = [
        // General
        "folder", "folder.fill", "doc", "doc.fill", "note", "note.text",
        "book", "book.fill", "bookmark", "bookmark.fill", "tag", "tag.fill",
        
        // Work & Business
        "briefcase", "briefcase.fill", "building", "building.2", "chart.bar",
        "chart.pie", "chart.line.uptrend.xyaxis", "dollarsign.circle",
        "creditcard", "banknote", "calendar", "clock", "timer",
        
        // Personal & Life
        "person", "person.fill", "heart", "heart.fill", "house", "house.fill",
        "car", "car.fill", "airplane", "train.side.front.car", "bicycle",
        "camera", "camera.fill", "photo", "music.note", "headphones",
        
        // Education & Learning
        "graduationcap", "studentdesk", "pencil", "pencil.circle", "paintbrush",
        "paintpalette", "book.closed", "books.vertical", "magazine",
        
        // Health & Fitness
        "heart.text.square", "cross.case", "pills", "stethoscope", "figure.walk",
        "figure.run", "dumbbell", "tennis.racket", "basketball",
        
        // Food & Cooking
        "fork.knife", "cup.and.saucer", "wineglass", "birthday.cake",
        "carrot", "leaf", "apple.logo",
        
        // Technology
        "laptopcomputer", "desktopcomputer", "iphone", "ipad", "applewatch",
        "headphones.circle", "speaker", "wifi", "antenna.radiowaves.left.and.right",
        
        // Travel & Places
        "map", "location", "globe", "airplane.departure", "suitcase",
        "tent", "mountain.2", "beach.umbrella", "car.ferry",
        
        // Shopping & Finance
        "cart", "bag", "giftcard", "creditcard.circle", "banknote.fill",
        "percent", "dollarsign.square", "eurosign.circle",
        
        // Communication
        "envelope", "envelope.fill", "phone", "phone.fill", "message",
        "message.fill", "bubble.left", "bubble.right", "megaphone",
        
        // Entertainment
        "tv", "gamecontroller", "dice", "puzzlepiece", "theatermasks",
        "guitar", "piano", "microphone", "film",
        
        // Nature & Weather
        "sun.max", "moon", "cloud", "snow", "bolt", "drop", "flame",
        "leaf.fill", "tree", "flower", "pawprint",
        
        // Tools & Utilities
        "hammer", "wrench", "screwdriver", "paintbrush.pointed",
        "scissors", "paperclip", "pin", "lock", "key",
        
        // Symbols & Shapes
        "star", "star.fill", "heart.circle", "circle", "square", "triangle",
        "diamond", "hexagon", "octagon", "oval", "capsule",
        
        // Arrows & Navigation
        "arrow.up", "arrow.down", "arrow.left", "arrow.right",
        "arrow.up.circle", "chevron.up", "chevron.down", "location.north"
    ]
    
    var filteredIcons: [String] {
        if searchText.isEmpty {
            return availableIcons
        } else {
            return availableIcons.filter { icon in
                icon.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 8)
    
    var body: some View {
        VStack(spacing: 16) {
            // Search field
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(themeManager.secondaryTextColor)
                    .font(.system(size: 16))
                
                TextField("Search icons...", text: $searchText)
                    .font(.dmSans(size: 14))
                    .foregroundColor(themeManager.textColor)
                    .textFieldStyle(PlainTextFieldStyle())
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(themeManager.secondaryTextColor)
                            .font(.system(size: 16))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(themeManager.cardBackgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(themeManager.cardBorderColor, lineWidth: 1)
                    )
            )
            
            // Icons grid
            ScrollView {
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(filteredIcons, id: \.self) { iconName in
                        IconButton(
                            iconName: iconName,
                            isSelected: selectedIcon == iconName,
                            onTap: {
                                selectedIcon = iconName
                            }
                        )
                    }
                }
                .padding(.horizontal, 4)
            }
            .frame(maxHeight: 300)
            
            // Selected icon preview
            if !selectedIcon.isEmpty {
                VStack(spacing: 8) {
                    Divider()
                        .background(themeManager.dividerColor)
                    
                    HStack {
                        Text("Selected:")
                            .font(.dmSans(size: 14))
                            .foregroundColor(themeManager.secondaryTextColor)
                        
                        Image(systemName: selectedIcon)
                            .font(.system(size: 20))
                            .foregroundColor(themeManager.accentColor)
                        
                        Text(selectedIcon)
                            .font(.dmSans(size: 14))
                            .foregroundColor(themeManager.textColor)
                        
                        Spacer()
                    }
                }
            }
        }
        .padding(16)
        .background(themeManager.backgroundColor)
    }
}

struct IconButton: View {
    let iconName: String
    let isSelected: Bool
    let onTap: () -> Void
    @EnvironmentObject var themeManager: ThemeManager
    @State private var isHovered = false
    
    var body: some View {
        Button(action: onTap) {
            Group {
                if isValidSFSymbol(iconName) {
                    Image(systemName: iconName)
                        .font(.system(size: 18))
                } else {
                    // Fallback for invalid SF Symbols
                    Image(systemName: "folder")
                        .font(.system(size: 18))
                        .opacity(0.5)
                }
            }
            .foregroundColor(
                isSelected ? themeManager.accentColor : 
                (isHovered ? themeManager.textColor : themeManager.secondaryTextColor)
            )
            .frame(width: 32, height: 32)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(
                        isSelected ? themeManager.accentColor.opacity(0.2) :
                        (isHovered ? themeManager.cardBorderColor.opacity(0.5) : Color.clear)
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(
                        isSelected ? themeManager.accentColor : Color.clear,
                        lineWidth: 2
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel("Icon: \(iconName)")
        .accessibilityHint(isSelected ? "Currently selected" : "Tap to select this icon")
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovered = hovering
            }
        }
        .scaleEffect(isSelected ? 1.1 : (isHovered ? 1.05 : 1.0))
        .animation(.easeInOut(duration: 0.2), value: isSelected)
        .animation(.easeInOut(duration: 0.2), value: isHovered)
    }
    
    private func isValidSFSymbol(_ symbolName: String) -> Bool {
        // Check if the SF Symbol exists by trying to create a UIImage
        #if canImport(UIKit)
        return UIImage(systemName: symbolName) != nil
        #else
        // On macOS, we'll assume the symbol is valid if it's in our curated list
        return true
        #endif
    }
}

#Preview {
    @State var selectedIcon = "folder"
    @State var searchText = ""
    
    return SFSymbolPicker(
        selectedIcon: $selectedIcon,
        searchText: $searchText
    )
    .environmentObject(ThemeManager())
    .frame(width: 400, height: 500)
}