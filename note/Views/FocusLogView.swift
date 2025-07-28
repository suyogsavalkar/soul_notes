//
//  FocusLogView.swift
//  note
//
//  Created by Kiro on 27/07/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct FocusLogView: View {
    let distractionStats: DistractionStats
    let distractionLogs: [DistractionLogEntry]
    @State private var hoveredStat: StatType? = nil
    @State private var showChatGPTMessage = false
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            HStack {
                Text("Distraction Log")
                    .font(.dmSansBold(size: 24))
                    .foregroundColor(themeManager.textColor)
                
                Spacer()
                
                Button("Done") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            
            // Statistics Section with bold numbers and hover interactions
            VStack(spacing: 16) {
                // Total distractions avoided
                StatisticView(
                    number: distractionStats.totalDistractionsAvoided,
                    description: "Total distractions avoided",
                    statType: .total,
                    hoveredStat: $hoveredStat,
                    onShare: shareAchievement
                )
                
                // Weekly distractions avoided
                StatisticView(
                    number: distractionStats.weeklyDistractionsAvoided,
                    description: "Distractions avoided in last 7 days",
                    statType: .weekly,
                    hoveredStat: $hoveredStat,
                    onShare: shareAchievement
                )
                
                // Monthly distractions avoided
                StatisticView(
                    number: distractionStats.monthlyDistractionsAvoided,
                    description: "Distractions avoided in last 30 days",
                    statType: .monthly,
                    hoveredStat: $hoveredStat,
                    onShare: shareAchievement
                )
            }
            .padding(.horizontal, 24)
            
            Divider()
                .background(themeManager.dividerColor)
            
            // Distraction Log List
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Recent Distractions")
                        .font(.dmSansMedium(size: 18))
                        .foregroundColor(themeManager.textColor)
                    
                    Spacer()
                    
                    Button("Get diagnosed by ChatGPT") {
                        downloadDiagnosisLog()
                    }
                    .font(.dmSans(size: 14))
                    .foregroundColor(themeManager.accentColor)
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal, 24)
                
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(sortedDistractionLogs) { logEntry in
                            DistractionLogEntryView(logEntry: logEntry)
                                .environmentObject(themeManager)
                        }
                        
                        if distractionLogs.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: "checkmark.shield")
                                    .font(.system(size: 48))
                                    .foregroundColor(themeManager.accentColor.opacity(0.5))
                                
                                Text("No distractions logged yet")
                                    .font(.dmSansMedium(size: 16))
                                    .foregroundColor(themeManager.secondaryTextColor)
                                
                                Text("Keep up the great focus!")
                                    .font(.dmSans(size: 14))
                                    .foregroundColor(themeManager.secondaryTextColor.opacity(0.7))
                            }
                            .padding(.top, 40)
                        }
                    }
                    .padding(.horizontal, 24)
                }
            }
            
            Spacer()
            
            // ChatGPT message overlay
            if showChatGPTMessage {
                VStack(spacing: 16) {
                    Text("Diagnosis log downloaded successfully!")
                        .font(.dmSansMedium(size: 16))
                        .foregroundColor(themeManager.textColor)
                    
                    HStack(spacing: 8) {
                        Button("Go to ChatGPT") {
                            if let url = URL(string: "https://chatgpt.com") {
                                NSWorkspace.shared.open(url)
                            }
                            showChatGPTMessage = false
                        }
                        .font(.dmSans(size: 14))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(themeManager.accentColor)
                        .cornerRadius(6)
                        .buttonStyle(PlainButtonStyle())
                        
                        Image(systemName: "link")
                            .font(.system(size: 14))
                            .foregroundColor(themeManager.accentColor)
                        
                        Button("Dismiss") {
                            showChatGPTMessage = false
                        }
                        .font(.dmSans(size: 14))
                        .foregroundColor(themeManager.secondaryTextColor)
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(themeManager.cardBackgroundColor)
                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.easeInOut(duration: 0.3), value: showChatGPTMessage)
            }
        }
        .background(themeManager.backgroundColor)
        .frame(minWidth: 500, minHeight: 600) // Proper window sizing
    }
    
    private var sortedDistractionLogs: [DistractionLogEntry] {
        distractionLogs.sorted { $0.timestamp > $1.timestamp }
    }
    
    func downloadDiagnosisLog() {
        // Generate diagnosis log content
        let logContent = generateDiagnosisLogContent()
        
        // Use NSSavePanel to let user choose where to save
        let savePanel = NSSavePanel()
        savePanel.allowedContentTypes = [.plainText]
        savePanel.canCreateDirectories = true
        savePanel.isExtensionHidden = false
        savePanel.allowsOtherFileTypes = false
        savePanel.title = "Save Diagnosis Log"
        savePanel.message = "Choose where to save your focus diagnosis log"
        savePanel.nameFieldLabel = "Save as:"
        
        let fileName = "soul-focus-diagnosis-\(Date().timeIntervalSince1970).txt"
        savePanel.nameFieldStringValue = fileName
        
        // Set default directory to Downloads with proper error handling
        do {
            if let downloadsURL = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first {
                // Ensure Downloads directory exists and is accessible
                var isDirectory: ObjCBool = false
                if FileManager.default.fileExists(atPath: downloadsURL.path, isDirectory: &isDirectory) && isDirectory.boolValue {
                    // Check if we have write permissions
                    if FileManager.default.isWritableFile(atPath: downloadsURL.path) {
                        savePanel.directoryURL = downloadsURL
                    } else {
                        print("Warning: Downloads folder is not writable, using default location")
                    }
                } else {
                    // Try to create Downloads directory if it doesn't exist
                    try FileManager.default.createDirectory(at: downloadsURL, withIntermediateDirectories: true, attributes: nil)
                    savePanel.directoryURL = downloadsURL
                }
            }
        } catch {
            print("Warning: Could not access Downloads folder: \(error.localizedDescription)")
            // NSSavePanel will use default location if directoryURL is not set
        }
        
        savePanel.begin { response in
            if response == .OK, let url = savePanel.url {
                do {
                    // Ensure parent directory exists
                    let parentDirectory = url.deletingLastPathComponent()
                    if !FileManager.default.fileExists(atPath: parentDirectory.path) {
                        try FileManager.default.createDirectory(at: parentDirectory, withIntermediateDirectories: true, attributes: nil)
                    }
                    
                    // Write with proper file attributes and encoding
                    try logContent.write(to: url, atomically: true, encoding: .utf8)
                    
                    // Set proper file permissions (readable by user and group)
                    try FileManager.default.setAttributes([
                        .posixPermissions: 0o644
                    ], ofItemAtPath: url.path)
                    
                    print("Diagnosis log saved to: \(url.path)")
                    
                    // Show success message with ChatGPT link
                    DispatchQueue.main.async {
                        withAnimation {
                            self.showChatGPTMessage = true
                        }
                        
                        // Auto-hide message after 10 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                            withAnimation {
                                self.showChatGPTMessage = false
                            }
                        }
                    }
                } catch {
                    print("Failed to save diagnosis log: \(error)")
                    DispatchQueue.main.async {
                        let errorMessage = "Failed to save diagnosis log: \(error.localizedDescription)\n\nTip: Try selecting a different folder or check your file permissions."
                        self.showErrorAlert(errorMessage)
                    }
                }
            }
        }
    }
    
    private func generateDiagnosisLogContent() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .medium
        
        var content = """
        Soul Focus Diagnosis Log
        Generated on: \(dateFormatter.string(from: Date()))
        
        FOCUS STATISTICS:
        - Total distractions avoided: \(distractionStats.totalDistractionsAvoided)
        - Distractions avoided in last 7 days: \(distractionStats.weeklyDistractionsAvoided)
        - Distractions avoided in last 30 days: \(distractionStats.monthlyDistractionsAvoided)
        
        DETAILED DISTRACTION LOG:
        
        """
        
        let sortedLogs = distractionLogs.sorted { $0.timestamp > $1.timestamp }
        
        if sortedLogs.isEmpty {
            content += "No distractions logged yet. Great focus!\n"
        } else {
            for (index, logEntry) in sortedLogs.enumerated() {
                let entryDateFormatter = DateFormatter()
                entryDateFormatter.dateStyle = .short
                entryDateFormatter.timeStyle = .short
                
                content += """
                \(index + 1). \(entryDateFormatter.string(from: logEntry.timestamp))
                   Type: \(logEntry.distractionType.rawValue.replacingOccurrences(of: "_", with: " ").capitalized)
                   Reason: \(logEntry.reason)
                   Avoided: \(logEntry.wasAvoided ? "Yes" : "No")
                
                """
            }
        }
        
        content += """
        
        ANALYSIS PROMPT FOR CHATGPT:
        Please analyze my focus patterns based on the above data. Look for:
        1. Common distraction triggers and times
        2. Patterns in my focus behavior
        3. Suggestions for improving concentration
        4. Recommendations for better focus habits
        5. Any concerning patterns that might indicate deeper issues
        
        Please provide actionable advice based on this data.
        """
        
        return content
    }
    
    func shareAchievement(for statType: StatType) {
        let image = generateAchievementImage(for: statType)
        
        // Use NSSavePanel to let user choose where to save
        let savePanel = NSSavePanel()
        savePanel.allowedContentTypes = [.png]
        savePanel.canCreateDirectories = true
        savePanel.isExtensionHidden = false
        savePanel.allowsOtherFileTypes = false
        savePanel.title = "Save Achievement Image"
        savePanel.message = "Choose where to save your achievement image"
        savePanel.nameFieldLabel = "Save as:"
        
        let fileName = "soul-achievement-\(statType.rawValue)-\(Date().timeIntervalSince1970).png"
        savePanel.nameFieldStringValue = fileName
        
        // Set default directory to Downloads with proper error handling
        do {
            if let downloadsURL = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first {
                // Ensure Downloads directory exists and is accessible
                var isDirectory: ObjCBool = false
                if FileManager.default.fileExists(atPath: downloadsURL.path, isDirectory: &isDirectory) && isDirectory.boolValue {
                    // Check if we have write permissions
                    if FileManager.default.isWritableFile(atPath: downloadsURL.path) {
                        savePanel.directoryURL = downloadsURL
                    } else {
                        print("Warning: Downloads folder is not writable, using default location")
                    }
                } else {
                    // Try to create Downloads directory if it doesn't exist
                    try FileManager.default.createDirectory(at: downloadsURL, withIntermediateDirectories: true, attributes: nil)
                    savePanel.directoryURL = downloadsURL
                }
            }
        } catch {
            print("Warning: Could not access Downloads folder: \(error.localizedDescription)")
            // NSSavePanel will use default location if directoryURL is not set
        }
        
        savePanel.begin { response in
            if response == .OK, let url = savePanel.url {
                if let tiffData = image.tiffRepresentation,
                   let bitmapRep = NSBitmapImageRep(data: tiffData),
                   let pngData = bitmapRep.representation(using: .png, properties: [:]) {
                    do {
                        // Ensure parent directory exists
                        let parentDirectory = url.deletingLastPathComponent()
                        if !FileManager.default.fileExists(atPath: parentDirectory.path) {
                            try FileManager.default.createDirectory(at: parentDirectory, withIntermediateDirectories: true, attributes: nil)
                        }
                        
                        // Write with proper file attributes
                        try pngData.write(to: url, options: [.atomic])
                        
                        // Set proper file permissions (readable by user and group)
                        try FileManager.default.setAttributes([
                            .posixPermissions: 0o644
                        ], ofItemAtPath: url.path)
                        
                        print("Achievement image saved to: \(url.path)")
                        
                        // Show success notification
                        DispatchQueue.main.async {
                            let alert = NSAlert()
                            alert.messageText = "Achievement Shared!"
                            alert.informativeText = "Your achievement image has been saved successfully to:\n\(url.path)"
                            alert.addButton(withTitle: "OK")
                            alert.addButton(withTitle: "Show in Finder")
                            
                            let response = alert.runModal()
                            if response == .alertSecondButtonReturn {
                                NSWorkspace.shared.selectFile(url.path, inFileViewerRootedAtPath: parentDirectory.path)
                            }
                        }
                    } catch {
                        print("Failed to save achievement image: \(error)")
                        DispatchQueue.main.async {
                            let errorMessage = "Failed to save image: \(error.localizedDescription)\n\nTip: Try selecting a different folder or check your file permissions."
                            self.showErrorAlert(errorMessage)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showErrorAlert("Failed to generate achievement image. Please try again.")
                    }
                }
            }
        }
    }
    
    private func showErrorAlert(_ message: String) {
        DispatchQueue.main.async {
            let alert = NSAlert()
            alert.messageText = "Error"
            alert.informativeText = message
            alert.addButton(withTitle: "OK")
            alert.alertStyle = .warning
            alert.runModal()
        }
    }
    
    func generateAchievementImage(for statType: StatType) -> NSImage {
        let size = NSSize(width: 500, height: 300)
        let image = NSImage(size: size)
        
        image.lockFocus()
        
        // Draw macOS window-style background
        let windowRect = NSRect(origin: .zero, size: size)
        NSColor.windowBackgroundColor.setFill()
        windowRect.fill()
        
        // Draw window title bar
        let titleBarRect = NSRect(x: 0, y: size.height - 40, width: size.width, height: 40)
        NSColor.controlBackgroundColor.setFill()
        titleBarRect.fill()
        
        // Draw window controls (traffic lights)
        let controlSize: CGFloat = 12
        let controlY = size.height - 26
        
        // Red close button
        NSColor.systemRed.setFill()
        let closeButton = NSRect(x: 20, y: controlY, width: controlSize, height: controlSize)
        NSBezierPath(ovalIn: closeButton).fill()
        
        // Yellow minimize button
        NSColor.systemYellow.setFill()
        let minimizeButton = NSRect(x: 40, y: controlY, width: controlSize, height: controlSize)
        NSBezierPath(ovalIn: minimizeButton).fill()
        
        // Green maximize button
        NSColor.systemGreen.setFill()
        let maximizeButton = NSRect(x: 60, y: controlY, width: controlSize, height: controlSize)
        NSBezierPath(ovalIn: maximizeButton).fill()
        
        // Draw window title
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 14, weight: .medium),
            .foregroundColor: NSColor.labelColor
        ]
        let titleString = NSAttributedString(string: "Soul - Focus Achievement", attributes: titleAttributes)
        let titleRect = NSRect(x: 100, y: size.height - 30, width: 300, height: 20)
        titleString.draw(in: titleRect)
        
        // Draw content area
        let contentRect = NSRect(x: 0, y: 0, width: size.width, height: size.height - 40)
        NSColor.controlBackgroundColor.setFill()
        contentRect.fill()
        
        // Draw achievement content
        let number = getStatNumber(for: statType)
        let description = statType.displayName
        
        // Draw app icon area (placeholder)
        let iconRect = NSRect(x: 50, y: 180, width: 60, height: 60)
        NSColor.systemBlue.withAlphaComponent(0.3).setFill()
        NSBezierPath(roundedRect: iconRect, xRadius: 12, yRadius: 12).fill()
        
        // Draw "Soul" text in icon area
        let iconTextAttributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.boldSystemFont(ofSize: 16),
            .foregroundColor: NSColor.systemBlue
        ]
        let iconText = NSAttributedString(string: "Soul", attributes: iconTextAttributes)
        let iconTextRect = NSRect(x: 60, y: 200, width: 40, height: 20)
        iconText.draw(in: iconTextRect)
        
        // Draw number (bold and large)
        let numberAttributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.boldSystemFont(ofSize: 64),
            .foregroundColor: NSColor.labelColor
        ]
        let numberString = NSAttributedString(string: "\(number)", attributes: numberAttributes)
        let numberRect = NSRect(x: 140, y: 160, width: 300, height: 80)
        numberString.draw(in: numberRect)
        
        // Draw description
        let descriptionAttributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 18),
            .foregroundColor: NSColor.secondaryLabelColor
        ]
        let descriptionString = NSAttributedString(string: description, attributes: descriptionAttributes)
        let descriptionRect = NSRect(x: 50, y: 120, width: 400, height: 30)
        descriptionString.draw(in: descriptionRect)
        
        // Draw achievement badge
        let badgeRect = NSRect(x: 50, y: 60, width: 400, height: 40)
        NSColor.systemGreen.withAlphaComponent(0.2).setFill()
        NSBezierPath(roundedRect: badgeRect, xRadius: 8, yRadius: 8).fill()
        
        let badgeTextAttributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 16, weight: .medium),
            .foregroundColor: NSColor.systemGreen
        ]
        let badgeText = NSAttributedString(string: "🎉 Achievement Unlocked!", attributes: badgeTextAttributes)
        let badgeTextRect = NSRect(x: 60, y: 70, width: 380, height: 20)
        badgeText.draw(in: badgeTextRect)
        
        image.unlockFocus()
        
        return image
    }
    
    private func getStatNumber(for statType: StatType) -> Int {
        switch statType {
        case .total:
            return distractionStats.totalDistractionsAvoided
        case .weekly:
            return distractionStats.weeklyDistractionsAvoided
        case .monthly:
            return distractionStats.monthlyDistractionsAvoided
        }
    }
}

struct StatisticView: View {
    let number: Int
    let description: String
    let statType: StatType
    @Binding var hoveredStat: StatType?
    let onShare: (StatType) -> Void
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                // Bold number
                Text("\(number)")
                    .font(.dmSansBold(size: 36))
                    .foregroundColor(themeManager.textColor)
                
                Spacer()
                
                // Share button (only visible on hover)
                if hoveredStat == statType {
                    Button("Share your achievement") {
                        onShare(statType)
                    }
                    .font(.dmSans(size: 12))
                    .foregroundColor(themeManager.accentColor)
                    .buttonStyle(PlainButtonStyle())
                    .transition(.opacity.combined(with: .scale))
                }
            }
            
            // Description text below number on same line
            Text(description)
                .font(.dmSans(size: 14))
                .foregroundColor(themeManager.secondaryTextColor)
        }
        .padding(.vertical, 8)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                hoveredStat = hovering ? statType : nil
            }
        }
    }
}

struct DistractionLogEntryView: View {
    let logEntry: DistractionLogEntry
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Icon based on distraction type
            Image(systemName: iconForDistractionType)
                .font(.system(size: 16))
                .foregroundColor(colorForDistractionType)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                // Date and time
                HStack {
                    Text(formatDate(logEntry.timestamp))
                        .font(.dmSansMedium(size: 14))
                        .foregroundColor(themeManager.textColor)
                    
                    Text(formatTime(logEntry.timestamp))
                        .font(.dmSans(size: 14))
                        .foregroundColor(themeManager.secondaryTextColor)
                    
                    Spacer()
                }
                
                // Distraction reason
                Text(logEntry.reason)
                    .font(.dmSans(size: 13))
                    .foregroundColor(themeManager.secondaryTextColor)
            }
            
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(themeManager.cardBackgroundColor)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(themeManager.cardBorderColor, lineWidth: 1)
        )
    }
    
    private var iconForDistractionType: String {
        switch logEntry.distractionType {
        case .tabChange:
            return "arrow.left.arrow.right"
        case .customReason:
            return "exclamationmark.triangle"
        case .focusLoss:
            return "eye.slash"
        }
    }
    
    private var colorForDistractionType: Color {
        switch logEntry.distractionType {
        case .tabChange:
            return .orange
        case .customReason:
            return .red
        case .focusLoss:
            return .yellow
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        
        if calendar.isDate(date, inSameDayAs: Date()) {
            return "Today"
        } else if let yesterday = calendar.date(byAdding: .day, value: -1, to: Date()),
                  calendar.isDate(date, inSameDayAs: yesterday) {
            return "Yesterday"
        } else {
            formatter.dateStyle = .short
            return formatter.string(from: date)
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// MARK: - Data Models

struct DistractionLogEntry: Identifiable, Codable {
    let id: UUID
    let timestamp: Date
    let distractionType: DistractionType
    let reason: String
    let wasAvoided: Bool
    
    init(timestamp: Date, distractionType: DistractionType, reason: String, wasAvoided: Bool) {
        self.id = UUID()
        self.timestamp = timestamp
        self.distractionType = distractionType
        self.reason = reason
        self.wasAvoided = wasAvoided
    }
}

enum DistractionType: String, Codable, CaseIterable {
    case tabChange = "tab_change"
    case customReason = "custom_reason"
    case focusLoss = "focus_loss"
}

struct DistractionStats: Codable {
    var totalDistractionsAvoided: Int = 0
    var weeklyDistractionsAvoided: Int = 0
    var monthlyDistractionsAvoided: Int = 0
    var lastUpdated: Date = Date()
    
    mutating func updateWeeklyCount() {
        // Calculate distractions avoided in last 7 days
        // This would be implemented with actual log data
    }
    
    mutating func updateMonthlyCount() {
        // Calculate distractions avoided in last 30 days
        // This would be implemented with actual log data
    }
}

enum StatType: String, CaseIterable {
    case total, weekly, monthly
    
    var displayName: String {
        switch self {
        case .total: return "Total distractions avoided"
        case .weekly: return "Distractions avoided in last 7 days"
        case .monthly: return "Distractions avoided in last 30 days"
        }
    }
}

#Preview {
    let sampleStats = DistractionStats(
        totalDistractionsAvoided: 42,
        weeklyDistractionsAvoided: 8,
        monthlyDistractionsAvoided: 25
    )
    
    let sampleLogs = [
        DistractionLogEntry(
            timestamp: Date(),
            distractionType: .tabChange,
            reason: "Tab change",
            wasAvoided: true
        ),
        DistractionLogEntry(
            timestamp: Date().addingTimeInterval(-3600),
            distractionType: .customReason,
            reason: "Phone notification distracted me",
            wasAvoided: true
        ),
        DistractionLogEntry(
            timestamp: Date().addingTimeInterval(-7200),
            distractionType: .focusLoss,
            reason: "Tab change",
            wasAvoided: false
        )
    ]
    
    FocusLogView(distractionStats: sampleStats, distractionLogs: sampleLogs)
        .environmentObject(ThemeManager())
        .frame(width: 600, height: 700)
}