//
//  TooltipModifier.swift
//  note
//
//  Created by Kiro on 28/07/25.
//

import SwiftUI

// MARK: - Tooltip Configuration

struct TooltipConfiguration {
    let message: String
    let position: TooltipPosition
    let delay: TimeInterval
    
    init(message: String, position: TooltipPosition = .top, delay: TimeInterval = 0.5) {
        self.message = message
        self.position = position
        self.delay = delay
    }
}

enum TooltipPosition {
    case top, bottom, leading, trailing
}

// MARK: - Tooltip Modifier

struct TooltipModifier: ViewModifier {
    let configuration: TooltipConfiguration
    let isEnabled: Bool
    
    @State private var isHovering = false
    @State private var showTooltip = false
    @State private var hoverTask: Task<Void, Never>?
    @EnvironmentObject var themeManager: ThemeManager
    
    init(configuration: TooltipConfiguration, isEnabled: Bool = true) {
        self.configuration = configuration
        self.isEnabled = isEnabled
    }
    
    func body(content: Content) -> some View {
        content
            .overlay(
                tooltipView
                    .opacity(showTooltip && isEnabled ? 1 : 0)
                    .animation(.easeInOut(duration: 0.2), value: showTooltip)
            )
            .onHover { hovering in
                isHovering = hovering
                
                // Cancel any existing hover task
                hoverTask?.cancel()
                
                if hovering && isEnabled {
                    // Start delay timer for showing tooltip
                    hoverTask = Task {
                        try? await Task.sleep(nanoseconds: UInt64(configuration.delay * 1_000_000_000))
                        
                        if !Task.isCancelled && isHovering {
                            await MainActor.run {
                                showTooltip = true
                            }
                        }
                    }
                } else {
                    // Hide tooltip immediately when not hovering
                    showTooltip = false
                }
            }
    }
    
    @ViewBuilder
    private var tooltipView: some View {
        if showTooltip && isEnabled {
            tooltipContent
                .offset(tooltipOffset)
        }
    }
    
    private var tooltipContent: some View {
        Text(configuration.message)
            .font(.dmSans(size: 12))
            .foregroundColor(themeManager.textColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(themeManager.cardBackgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(themeManager.cardBorderColor, lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            )
            .fixedSize()
    }
    
    private var tooltipOffset: CGSize {
        switch configuration.position {
        case .top:
            return CGSize(width: 0, height: -35)
        case .bottom:
            return CGSize(width: 0, height: 35)
        case .leading:
            return CGSize(width: -100, height: 0)
        case .trailing:
            return CGSize(width: 100, height: 0)
        }
    }
}

// MARK: - View Extension

extension View {
    func tooltip(_ message: String, position: TooltipPosition = .top, delay: TimeInterval = 0.5, isEnabled: Bool = true) -> some View {
        let configuration = TooltipConfiguration(message: message, position: position, delay: delay)
        return self.modifier(TooltipModifier(configuration: configuration, isEnabled: isEnabled))
    }
    
    func tooltip(configuration: TooltipConfiguration, isEnabled: Bool = true) -> some View {
        self.modifier(TooltipModifier(configuration: configuration, isEnabled: isEnabled))
    }
}