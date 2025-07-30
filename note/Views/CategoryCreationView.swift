//
//  CategoryCreationView.swift
//  note
//
//  Created by Kiro on 26/07/25.
//

import SwiftUI

struct CategoryCreationView: View {
    @Binding var isPresented: Bool
    let onCategoryCreate: (String, String) -> Void
    @EnvironmentObject var themeManager: ThemeManager
    
    @State private var categoryName: String = ""
    @State private var selectedIcon: String = "folder"
    @State private var searchText: String = ""
    @State private var showingError: Bool = false
    @State private var errorMessage: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Add new Space")
                    .font(.dmSansBold(size: 18))
                    .foregroundColor(themeManager.textColor)
                
                Spacer()
                
                Button(action: {
                    isPresented = false
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16))
                        .foregroundColor(themeManager.secondaryTextColor)
                }
                .buttonStyle(HoverButtonStyle())
                .accessibilityLabel("Close")
            }
            .padding(20)
            .background(themeManager.backgroundColor)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(themeManager.dividerColor),
                alignment: .bottom
            )
            
            // Content
            ScrollView {
                VStack(spacing: 24) {
                    // Category name input
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Space Name")
                            .font(.dmSansMedium(size: 14))
                            .foregroundColor(themeManager.textColor)
                        
                        TextField("Enter space name", text: $categoryName)
                            .font(.dmSans(size: 16))
                            .foregroundColor(themeManager.textColor)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(themeManager.cardBackgroundColor)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(themeManager.cardBorderColor, lineWidth: 1)
                                    )
                            )
                            .accessibilityLabel("Space name")
                            .accessibilityHint("Enter a name for your new space")
                    }
                    
                    // Icon selection
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Choose Icon")
                            .font(.dmSansMedium(size: 14))
                            .foregroundColor(themeManager.textColor)
                        
                        SFSymbolPicker(
                            selectedIcon: $selectedIcon,
                            searchText: $searchText
                        )
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(themeManager.cardBackgroundColor)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(themeManager.cardBorderColor, lineWidth: 1)
                                )
                        )
                    }
                }
                .padding(20)
            }
            .background(themeManager.backgroundColor)
            
            // Footer with buttons
            HStack(spacing: 12) {
                Button("Cancel") {
                    isPresented = false
                }
                .buttonStyle(SecondaryButtonStyle())
                
                Button("Create Space") {
                    createCategory()
                }
                .buttonStyle(PrimaryButtonStyle())
                .disabled(categoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding(20)
            .background(themeManager.backgroundColor)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(themeManager.dividerColor),
                alignment: .top
            )
        }
        .frame(width: 500, height: 600)
        .background(themeManager.backgroundColor)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
        .alert("Error", isPresented: $showingError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func createCategory() {
        let trimmedName = categoryName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Validation
        guard !trimmedName.isEmpty else {
            showError("Please enter a space name.")
            return
        }
        
        guard trimmedName.count >= 2 else {
            showError("Space name must be at least 2 characters long.")
            return
        }
        
        guard trimmedName.count <= 50 else {
            showError("Space name must be 50 characters or less.")
            return
        }
        
        // Check for invalid characters
        let invalidCharacters = CharacterSet(charactersIn: "/\\:*?\"<>|")
        guard trimmedName.rangeOfCharacter(from: invalidCharacters) == nil else {
            showError("Space name contains invalid characters. Please avoid: / \\ : * ? \" < > |")
            return
        }
        
        guard !selectedIcon.isEmpty else {
            showError("Please select an icon.")
            return
        }
        
        // Create the category
        do {
            onCategoryCreate(trimmedName, selectedIcon)
            isPresented = false
        } catch {
            showError("Failed to create space. Please try again.")
        }
    }
    
    private func showError(_ message: String) {
        errorMessage = message
        showingError = true
    }
}



#Preview {
    @State var isPresented = true
    
    return CategoryCreationView(
        isPresented: $isPresented,
        onCategoryCreate: { name, icon in
            print("Creating category: \(name) with icon: \(icon)")
        }
    )
    .environmentObject(ThemeManager())
}