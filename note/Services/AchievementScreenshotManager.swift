//
//  AchievementScreenshotManager.swift
//  note
//
//  Created by Kiro on 28/07/25.
//

import SwiftUI
import AppKit

class AchievementScreenshotManager: ObservableObject {
    @Published var lastScreenshotResult: String = ""
    
    func captureAchievementSection(for statType: StatType, stats: DistractionStats) -> NSImage? {
        let image = generateAchievementImage(for: statType, stats: stats)
        return image
    }
    
    func copyToClipboard(_ image: NSImage) -> Bool {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        
        // Convert NSImage to data for clipboard
        guard let tiffData = image.tiffRepresentation,
              let bitmapRep = NSBitmapImageRep(data: tiffData),
              let pngData = bitmapRep.representation(using: .png, properties: [:]) else {
            return false
        }
        
        // Add both PNG data and TIFF representation for maximum compatibility
        let success = pasteboard.setData(pngData, forType: .png) && 
                     pasteboard.setData(tiffData, forType: .tiff)
        
        return success
    }
    
    func showClipboardSuccess() {
        DispatchQueue.main.async {
            self.lastScreenshotResult = "Achievement copied to clipboard! You can now paste it anywhere."
            
            // Clear the message after 3 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.lastScreenshotResult = ""
            }
        }
    }
    
    func handleScreenshotError(_ error: Error) {
        DispatchQueue.main.async {
            self.lastScreenshotResult = "Failed to capture screenshot: \(error.localizedDescription)"
            
            // Clear the message after 5 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.lastScreenshotResult = ""
            }
        }
    }
    
    private func generateAchievementImage(for statType: StatType, stats: DistractionStats) -> NSImage {
        let size = NSSize(width: 400, height: 200)
        let image = NSImage(size: size)
        
        image.lockFocus()
        
        // Draw macOS window-style background
        let windowRect = NSRect(origin: .zero, size: size)
        NSColor.windowBackgroundColor.setFill()
        windowRect.fill()
        
        // Draw window title bar
        let titleBarRect = NSRect(x: 0, y: size.height - 30, width: size.width, height: 30)
        NSColor.controlBackgroundColor.setFill()
        titleBarRect.fill()
        
        // Draw window controls (traffic lights)
        let controlSize: CGFloat = 10
        let controlY = size.height - 20
        
        // Red close button
        NSColor.systemRed.setFill()
        let closeButton = NSRect(x: 15, y: controlY, width: controlSize, height: controlSize)
        NSBezierPath(ovalIn: closeButton).fill()
        
        // Yellow minimize button
        NSColor.systemYellow.setFill()
        let minimizeButton = NSRect(x: 30, y: controlY, width: controlSize, height: controlSize)
        NSBezierPath(ovalIn: minimizeButton).fill()
        
        // Green maximize button
        NSColor.systemGreen.setFill()
        let maximizeButton = NSRect(x: 45, y: controlY, width: controlSize, height: controlSize)
        NSBezierPath(ovalIn: maximizeButton).fill()
        
        // Draw window title
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 12, weight: .medium),
            .foregroundColor: NSColor.labelColor
        ]
        let titleString = NSAttributedString(string: "Solo - Focus Achievement", attributes: titleAttributes)
        let titleRect = NSRect(x: 70, y: size.height - 22, width: 200, height: 16)
        titleString.draw(in: titleRect)
        
        // Draw content area
        let contentRect = NSRect(x: 0, y: 0, width: size.width, height: size.height - 30)
        NSColor.controlBackgroundColor.setFill()
        contentRect.fill()
        
        // Draw achievement content
        let number = getStatNumber(for: statType, stats: stats)
        let description = statType.displayName
        
        // Draw app icon area (placeholder)
        let iconRect = NSRect(x: 30, y: 120, width: 40, height: 40)
        NSColor.systemBlue.withAlphaComponent(0.3).setFill()
        NSBezierPath(roundedRect: iconRect, xRadius: 8, yRadius: 8).fill()
        
        // Draw "Solo" text in icon area
        let iconTextAttributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.boldSystemFont(ofSize: 12),
            .foregroundColor: NSColor.systemBlue
        ]
        let iconText = NSAttributedString(string: "Solo", attributes: iconTextAttributes)
        let iconTextRect = NSRect(x: 35, y: 135, width: 30, height: 15)
        iconText.draw(in: iconTextRect)
        
        // Draw number (bold and large)
        let numberAttributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.boldSystemFont(ofSize: 48),
            .foregroundColor: NSColor.labelColor
        ]
        let numberString = NSAttributedString(string: "\(number)", attributes: numberAttributes)
        let numberRect = NSRect(x: 90, y: 110, width: 250, height: 60)
        numberString.draw(in: numberRect)
        
        // Draw description
        let descriptionAttributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 14),
            .foregroundColor: NSColor.secondaryLabelColor
        ]
        let descriptionString = NSAttributedString(string: description, attributes: descriptionAttributes)
        let descriptionRect = NSRect(x: 30, y: 80, width: 340, height: 20)
        descriptionString.draw(in: descriptionRect)
        
        // Draw achievement badge
        let badgeRect = NSRect(x: 30, y: 40, width: 340, height: 30)
        NSColor.systemGreen.withAlphaComponent(0.2).setFill()
        NSBezierPath(roundedRect: badgeRect, xRadius: 6, yRadius: 6).fill()
        
        let badgeTextAttributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 14, weight: .medium),
            .foregroundColor: NSColor.systemGreen
        ]
        let badgeText = NSAttributedString(string: "🎉 Achievement Unlocked!", attributes: badgeTextAttributes)
        let badgeTextRect = NSRect(x: 40, y: 50, width: 320, height: 16)
        badgeText.draw(in: badgeTextRect)
        
        image.unlockFocus()
        
        return image
    }
    
    private func getStatNumber(for statType: StatType, stats: DistractionStats) -> Int {
        switch statType {
        case .total:
            return stats.totalDistractionsAvoided
        case .weekly:
            return stats.weeklyDistractionsAvoided
        case .monthly:
            return stats.monthlyDistractionsAvoided
        }
    }
}