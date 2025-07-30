//
//  SidebarView.swift
//  note
//
//  Created by Kiro on 26/07/25.
//

import SwiftUI

struct SidebarView: View {
    @Binding var selectedCategory: Category?
    let categories: [Category]
    let onCategorySelect: (Category) -> Void
    let onCategoryAdd: ((String, String) -> Void)?
    let onCategoryDelete: ((Category) -> Void)?
    let onFocusStatsClick: (() -> Void)?
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var focusTimerManager: FocusTimerManager
    @State private var showingCategoryCreation = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                Text("Soul")
                    .font(.dmSansBold(size: 20))
                    .foregroundColor(themeManager.textColor)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
            

            
            // Categories list
            ScrollView {
                LazyVStack(spacing: 4) {
                    ForEach(categories) { category in
                        CategoryRowView(
                            category: category,
                            isSelected: selectedCategory?.id == category.id,
                            onTap: {
                                selectedCategory = category
                                onCategorySelect(category)
                            },
                            onDelete: onCategoryDelete != nil ? {
                                onCategoryDelete?(category)
                            } : nil
                        )
                    }
                }
                .padding(.vertical, 8)
            }
            
            Spacer()
            
            // Bottom section with Add Space, Dark mode toggle, and Focus statistics
            VStack(spacing: 12) {
                // Add new Space button
                if onCategoryAdd != nil {
                    HStack {
                        Button(action: {
                            showingCategoryCreation = true
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "plus")
                                    .font(.system(size: 16))
                                    .foregroundColor(themeManager.accentColor)
                                
                                Text("Add new Space")
                                    .font(.dmSans(size: 14))
                                    .foregroundColor(themeManager.textColor)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.clear)
                            )
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(HoverButtonStyle())
                        .accessibilityLabel("Add new Space")
                        .accessibilityHint("Creates a new category space")
                    }
                    .padding(.horizontal, 8)
                }
                
                // Dark mode toggle
                HStack {
                    Button(action: {
                        themeManager.toggleTheme()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: themeManager.isDarkMode ? "sun.max.fill" : "moon.fill")
                                .font(.system(size: 16))
                                .foregroundColor(themeManager.textColor)
                            
                            Text(themeManager.isDarkMode ? "Light Mode" : "Dark Mode")
                                .font(.dmSans(size: 14))
                                .foregroundColor(themeManager.textColor)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.clear)
                        )
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(HoverButtonStyle())
                    .accessibilityLabel(themeManager.isDarkMode ? "Switch to Light Mode" : "Switch to Dark Mode")
                    .accessibilityHint("Toggles between light and dark theme")
                }
                .padding(.horizontal, 8)
                
                // Focus statistics (moved below dark mode toggle)
                if let onFocusStatsClick = onFocusStatsClick {
                    FocusStatsView(
                        focusStats: focusTimerManager.focusStats,
                        distractionStats: focusTimerManager.distractionStats,
                        onTapStats: onFocusStatsClick
                    )
                    .environmentObject(themeManager)
                }
            }
            .padding(.bottom, 16)
        }
        .background(themeManager.sidebarBackgroundColor)
        .frame(maxHeight: .infinity)
        .sheet(isPresented: $showingCategoryCreation) {
            CategoryCreationView(
                isPresented: $showingCategoryCreation,
                onCategoryCreate: { name, iconName in
                    onCategoryAdd?(name, iconName)
                }
            )
            .environmentObject(themeManager)
        }
    }
}

struct CategoryRowView: View {
    let category: Category
    let isSelected: Bool
    let onTap: () -> Void
    let onDelete: (() -> Void)?
    @EnvironmentObject var themeManager: ThemeManager
    @State private var showingDeleteConfirmation = false
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Image(systemName: category.iconName)
                    .font(.system(size: 16))
                    .foregroundColor(isSelected ? themeManager.accentColor : themeManager.secondaryTextColor)
                    .frame(width: 20)
                
                Text(category.name)
                    .font(.sidebarCategory)
                    .foregroundColor(isSelected ? themeManager.textColor : themeManager.secondaryTextColor)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(isSelected ? themeManager.sidebarSelectedColor : Color.clear)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(HoverButtonStyle())
        .padding(.horizontal, 8)
        .contextMenu {
            if onDelete != nil, category.name != "General" {
                Button(action: {
                    showingDeleteConfirmation = true
                }) {
                    Label("Delete Space", systemImage: "trash")
                }
                .foregroundColor(.red)
            }
        }
        .alert("Delete Space", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete?()
            }
        } message: {
            Text("Are you sure you want to delete \"\(category.name)\"? All notes in this space will be moved to the General space. This action cannot be undone.")
        }
    }
}

#Preview {
    SidebarView(
        selectedCategory: .constant(Category.defaultCategories.first),
        categories: Category.defaultCategories,
        onCategorySelect: { _ in },
        onCategoryAdd: { name, icon in
            print("Adding category: \(name) with icon: \(icon)")
        },
        onCategoryDelete: { category in
            print("Deleting category: \(category.name)")
        },
        onFocusStatsClick: {
            print("Focus stats clicked")
        }
    )
    .environmentObject(ThemeManager())
    .environmentObject(FocusTimerManager())
    .frame(width: 250, height: 400)
}