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
    @StateObject private var screenshotManager = AchievementScreenshotManager()
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
            
            // Screenshot result feedback
            if !screenshotManager.lastScreenshotResult.isEmpty {
                VStack(spacing: 12) {
                    Text(screenshotManager.lastScreenshotResult)
                        .font(.dmSansMedium(size: 14))
                        .foregroundColor(themeManager.textColor)
                        .multilineTextAlignment(.center)
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(themeManager.cardBackgroundColor)
                        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 2)
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 12)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.easeInOut(duration: 0.3), value: !screenshotManager.lastScreenshotResult.isEmpty)
            }
            

        }
        .background(themeManager.backgroundColor)
        .frame(minWidth: 500, minHeight: 600) // Proper window sizing
    }
    
    private var sortedDistractionLogs: [DistractionLogEntry] {
        distractionLogs.sorted { $0.timestamp > $1.timestamp }
    }
    

    
    func shareAchievement(for statType: StatType) {
        guard let image = screenshotManager.captureAchievementSection(for: statType, stats: distractionStats) else {
            screenshotManager.handleScreenshotError(NSError(domain: "ScreenshotError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to generate achievement image"]))
            return
        }
        
        if screenshotManager.copyToClipboard(image) {
            screenshotManager.showClipboardSuccess()
        } else {
            screenshotManager.handleScreenshotError(NSError(domain: "ClipboardError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to copy image to clipboard"]))
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