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
    
    func captureFocusAchievementSection(for statType: FocusStatType, stats: FocusTimeRangeStats) -> NSImage? {
        let image = generateFocusAchievementImage(for: statType, stats: stats)
        return image
    }
    
    func openInPreview(_ image: NSImage) -> Bool {
        // Create a temporary file for the image
        let tempDirectory = NSTemporaryDirectory()
        let fileName = "soul_achievement_\(Date().timeIntervalSince1970).png"
        let tempURL = URL(fileURLWithPath: tempDirectory).appendingPathComponent(fileName)
        
        // Convert NSImage to PNG data
        guard let tiffData = image.tiffRepresentation,
              let bitmapRep = NSBitmapImageRep(data: tiffData),
              let pngData = bitmapRep.representation(using: .png, properties: [:]) else {
            return false
        }
        
        do {
            // Write the image data to the temporary file
            try pngData.write(to: tempURL)
            
            // Open the file in Preview
            NSWorkspace.shared.open(tempURL)
            
            return true
        } catch {
            print("Failed to save or open image: \(error)")
            return false
        }
    }
    
    func showPreviewSuccess() {
        DispatchQueue.main.async {
            self.lastScreenshotResult = "Achievement opened in Preview! You can now save and share it."
            
            // Clear the message after 3 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.lastScreenshotResult = ""
            }
        }
    }
    
    func handleScreenshotError(_ error: Error) {
        DispatchQueue.main.async {
            self.lastScreenshotResult = "Failed to open screenshot in Preview: \(error.localizedDescription)"
            
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
        let titleString = NSAttributedString(string: "Soul - Focus Achievement", attributes: titleAttributes)
        let titleRect = NSRect(x: 70, y: size.height - 22, width: 200, height: 16)
        titleString.draw(in: titleRect)
        
        // Draw content area
        let contentRect = NSRect(x: 0, y: 0, width: size.width, height: size.height - 30)
        NSColor.controlBackgroundColor.setFill()
        contentRect.fill()
        
        // Draw achievement content
        let number = getStatNumber(for: statType, stats: stats)
        let description = statType.displayName
        
        // Center content vertically - calculate positions from center, moved down a bit
        let centerY = (size.height - 30) / 2 - 10 // Subtract title bar height and move down
        
        // Draw Soul logo
        let iconRect = NSRect(x: 30, y: centerY + 20, width: 40, height: 40)
        if let logoImage = loadSoulLogo() {
            logoImage.draw(in: iconRect)
        } else {
            // Fallback to colored background with Soul text
            NSColor.systemOrange.setFill()
            NSBezierPath(roundedRect: iconRect, xRadius: 8, yRadius: 8).fill()
            
            let iconTextAttributes: [NSAttributedString.Key: Any] = [
                .font: NSFont.boldSystemFont(ofSize: 12),
                .foregroundColor: NSColor.white
            ]
            let iconText = NSAttributedString(string: "Soul", attributes: iconTextAttributes)
            let iconTextRect = NSRect(x: 35, y: centerY + 35, width: 30, height: 15)
            iconText.draw(in: iconTextRect)
        }
        
        // Draw number (bold and large) - centered
        let numberAttributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.boldSystemFont(ofSize: 48),
            .foregroundColor: NSColor.labelColor
        ]
        let numberString = NSAttributedString(string: "\(number)", attributes: numberAttributes)
        let numberRect = NSRect(x: 90, y: centerY + 10, width: 250, height: 60)
        numberString.draw(in: numberRect)
        
        // Draw description - centered
        let descriptionAttributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 14),
            .foregroundColor: NSColor.secondaryLabelColor
        ]
        let descriptionString = NSAttributedString(string: description, attributes: descriptionAttributes)
        let descriptionRect = NSRect(x: 30, y: centerY - 20, width: 340, height: 20)
        descriptionString.draw(in: descriptionRect)
        

        
        image.unlockFocus()
        
        return image
    }
    
    private func generateFocusAchievementImage(for statType: FocusStatType, stats: FocusTimeRangeStats) -> NSImage {
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
        let titleString = NSAttributedString(string: "Soul - Focus Achievement", attributes: titleAttributes)
        let titleRect = NSRect(x: 70, y: size.height - 22, width: 200, height: 16)
        titleString.draw(in: titleRect)
        
        // Draw content area
        let contentRect = NSRect(x: 0, y: 0, width: size.width, height: size.height - 30)
        NSColor.controlBackgroundColor.setFill()
        contentRect.fill()
        
        // Draw achievement content
        let focusTime = getFocusTimeString(for: statType, stats: stats)
        let description = statType.displayName
        
        // Center content vertically - calculate positions from center, moved down a bit
        let centerY = (size.height - 30) / 2 - 10 // Subtract title bar height and move down
        
        // Draw Soul logo
        let iconRect = NSRect(x: 30, y: centerY + 20, width: 40, height: 40)
        if let logoImage = loadSoulLogo() {
            logoImage.draw(in: iconRect)
        } else {
            // Fallback to colored background with Soul text
            NSColor.systemOrange.setFill()
            NSBezierPath(roundedRect: iconRect, xRadius: 8, yRadius: 8).fill()
            
            let iconTextAttributes: [NSAttributedString.Key: Any] = [
                .font: NSFont.boldSystemFont(ofSize: 12),
                .foregroundColor: NSColor.white
            ]
            let iconText = NSAttributedString(string: "Soul", attributes: iconTextAttributes)
            let iconTextRect = NSRect(x: 35, y: centerY + 35, width: 30, height: 15)
            iconText.draw(in: iconTextRect)
        }
        
        // Draw focus time (bold and large) - centered
        let focusTimeAttributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.boldSystemFont(ofSize: 48),
            .foregroundColor: NSColor.labelColor
        ]
        let focusTimeString = NSAttributedString(string: focusTime, attributes: focusTimeAttributes)
        let focusTimeRect = NSRect(x: 90, y: centerY + 10, width: 250, height: 60)
        focusTimeString.draw(in: focusTimeRect)
        
        // Draw description - centered
        let descriptionAttributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 14),
            .foregroundColor: NSColor.secondaryLabelColor
        ]
        let descriptionString = NSAttributedString(string: description, attributes: descriptionAttributes)
        let descriptionRect = NSRect(x: 30, y: centerY - 20, width: 340, height: 20)
        descriptionString.draw(in: descriptionRect)
        

        
        image.unlockFocus()
        
        return image
    }
    
    private func getFocusTimeString(for statType: FocusStatType, stats: FocusTimeRangeStats) -> String {
        switch statType {
        case .todayFocus:
            return stats.formattedTodayFocusTime
        case .weeklyFocus:
            return stats.formattedLastWeekFocusTime
        case .totalFocus:
            return stats.formattedTotalFocusTime
        }
    }
    
    private func getStatNumber(for statType: StatType, stats: DistractionStats) -> Int {
        switch statType {
        case .today:
            return stats.todayDistractionsAvoided
        case .weekly:
            return stats.weeklyDistractionsAvoided
        case .total:
            return stats.totalDistractionsAvoided
        }
    }
    
    private func loadSoulLogo() -> NSImage? {
        // Try to load from the logo directory first
        if let logoPath = Bundle.main.path(forResource: "Untitled design", ofType: "png", inDirectory: "logo"),
           let logoImage = NSImage(contentsOfFile: logoPath) {
            return logoImage
        }
        
        // Try to load from the logo directory without subdirectory
        if let logoPath = Bundle.main.path(forResource: "Untitled design", ofType: "png"),
           let logoImage = NSImage(contentsOfFile: logoPath) {
            return logoImage
        }
        
        // Try to load from app icon assets as fallback
        if let appIcon = NSImage(named: "AppIcon") {
            return appIcon
        }
        
        // Try to load the icon files directly
        if let iconImage = NSImage(named: "icon_512x512") {
            return iconImage
        }
        
        return nil
    }
}