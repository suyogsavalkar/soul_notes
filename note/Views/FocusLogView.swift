//
//  FocusLogView.swift
//  note
//
//  Created by Kiro on 27/07/25.
//

import SwiftUI
import UniformTypeIdentifiers

enum LogViewTab: String, CaseIterable {
    case distractions = "Distractions"
    case focus = "Focus"
}

struct FocusLogView: View {
    let distractionStats: DistractionStats
    let distractionLogs: [DistractionLogEntry]
    let focusTimeRangeStats: FocusTimeRangeStats
    @State private var selectedTab: LogViewTab = .distractions
    @State private var hoveredStat: StatType? = nil
    @StateObject private var screenshotManager = AchievementScreenshotManager()
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss
    
    init(distractionStats: DistractionStats, distractionLogs: [DistractionLogEntry], focusTimeRangeStats: FocusTimeRangeStats, initialTab: LogViewTab = .distractions) {
        self.distractionStats = distractionStats
        self.distractionLogs = distractionLogs
        self.focusTimeRangeStats = focusTimeRangeStats
        self._selectedTab = State(initialValue: initialTab)
    }
    
    var body: some View {
        VStack(spacing: 24) {
            headerView
            tabSelectionView
            tabContentView
            Spacer()
            screenshotFeedbackView
        }
        .background(themeManager.backgroundColor)
        .frame(minWidth: 500, minHeight: 600)
    }
    
    // MARK: - View Components
    
    private var headerView: some View {
        HStack {
            Text(selectedTab == .distractions ? "Distraction Log" : "Focus Log")
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
    }
    
    private var tabSelectionView: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                tabButton(for: .distractions)
                tabButton(for: .focus)
                Spacer()
            }
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(themeManager.cardBorderColor)
        }
        .padding(.horizontal, 24)
    }
    
    private func tabButton(for tab: LogViewTab) -> some View {
        Button(action: {
            selectedTab = tab
        }) {
            VStack(spacing: 0) {
                Text(tab.rawValue)
                    .font(.dmSansMedium(size: 16))
                    .foregroundColor(selectedTab == tab ? themeManager.textColor : themeManager.secondaryTextColor)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(selectedTab == tab ? themeManager.accentColor : Color.clear)
            }
            .background(selectedTab == tab ? themeManager.cardBackgroundColor : Color.clear)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    @ViewBuilder
    private var tabContentView: some View {
        if selectedTab == .distractions {
            distractionsTabContent
        } else {
            focusTabContent
        }
    }
    
    private var distractionsTabContent: some View {
        VStack(spacing: 16) {
            statisticsSection
            
            Divider()
                .background(themeManager.dividerColor)
            
            distractionLogSection
        }
    }
    
    private var focusTabContent: some View {
        FocusStatisticsView(stats: focusTimeRangeStats)
            .environmentObject(themeManager)
    }
    
    private var statisticsSection: some View {
        VStack(spacing: 16) {
            StatisticView(
                number: distractionStats.todayDistractionsAvoided,
                description: "Distractions avoided today",
                statType: .today,
                hoveredStat: $hoveredStat,
                onShare: shareAchievement
            )
            
            StatisticView(
                number: distractionStats.weeklyDistractionsAvoided,
                description: "Distractions avoided in last 7 days",
                statType: .weekly,
                hoveredStat: $hoveredStat,
                onShare: shareAchievement
            )
            
            StatisticView(
                number: distractionStats.totalDistractionsAvoided,
                description: "Total distractions avoided",
                statType: .total,
                hoveredStat: $hoveredStat,
                onShare: shareAchievement
            )
        }
        .padding(.horizontal, 24)
    }
    
    private var distractionLogSection: some View {
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
                        emptyDistractionState
                    }
                }
                .padding(.horizontal, 24)
            }
        }
    }
    
    private var emptyDistractionState: some View {
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
    
    @ViewBuilder
    private var screenshotFeedbackView: some View {
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
    
    private var sortedDistractionLogs: [DistractionLogEntry] {
        distractionLogs.sorted { $0.timestamp > $1.timestamp }
    }
    

    
    func shareAchievement(for statType: StatType) {
        guard let image = screenshotManager.captureAchievementSection(for: statType, stats: distractionStats) else {
            screenshotManager.handleScreenshotError(NSError(domain: "ScreenshotError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to generate achievement image"]))
            return
        }
        
        if screenshotManager.openInPreview(image) {
            screenshotManager.showPreviewSuccess()
        } else {
            screenshotManager.handleScreenshotError(NSError(domain: "PreviewError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to open image in Preview"]))
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
        HStack(spacing: 16) {
            // Main content
            VStack(alignment: .leading, spacing: 4) {
                Text("\(number)")
                    .font(.dmSansBold(size: 36))
                    .foregroundColor(themeManager.textColor)
                
                Text(description)
                    .font(.dmSans(size: 14))
                    .foregroundColor(themeManager.secondaryTextColor)
            }
            
            Spacer()
            
            // Share button - always visible
            Button(action: {
                onShare(statType)
            }) {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 16))
                    .foregroundColor(themeManager.accentColor)
                    .frame(width: 32, height: 32)
                    .background(
                        Circle()
                            .fill(themeManager.accentColor.opacity(0.1))
                    )
            }
            .buttonStyle(PlainButtonStyle())
            .tooltip("Share your achievement", position: .top)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(themeManager.cardBackgroundColor)
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
        .onHover { isHovered in
            hoveredStat = isHovered ? statType : nil
        }
    }
}

struct FocusAchievementStatisticView: View {
    let focusTime: String
    let description: String
    let statType: FocusStatType
    @Binding var hoveredStat: FocusStatType?
    let onShare: (FocusStatType) -> Void
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        HStack(spacing: 16) {
            // Main content
            VStack(alignment: .leading, spacing: 4) {
                Text(focusTime)
                    .font(.dmSansBold(size: 36))
                    .foregroundColor(themeManager.textColor)
                
                Text(description)
                    .font(.dmSans(size: 14))
                    .foregroundColor(themeManager.secondaryTextColor)
            }
            
            Spacer()
            
            // Share button - always visible
            Button(action: {
                onShare(statType)
            }) {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 16))
                    .foregroundColor(themeManager.accentColor)
                    .frame(width: 32, height: 32)
                    .background(
                        Circle()
                            .fill(themeManager.accentColor.opacity(0.1))
                    )
            }
            .buttonStyle(PlainButtonStyle())
            .tooltip("Share your achievement", position: .top)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(themeManager.cardBackgroundColor)
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
        .onHover { isHovered in
            hoveredStat = isHovered ? statType : nil
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

struct FocusLogEntryView: View {
    let session: FocusSession
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Performance rating icon
            Image(systemName: iconForRating)
                .font(.system(size: 16))
                .foregroundColor(colorForRating)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                // Date and time
                HStack {
                    Text(formatDate(session.date))
                        .font(.dmSansMedium(size: 14))
                        .foregroundColor(themeManager.textColor)
                    
                    Text(formatTime(session.date))
                        .font(.dmSans(size: 14))
                        .foregroundColor(themeManager.secondaryTextColor)
                    
                    Spacer()
                }
                
                // Duration and performance
                HStack {
                    Text(formatDuration(session.duration))
                        .font(.dmSans(size: 13))
                        .foregroundColor(themeManager.secondaryTextColor)
                    
                    Text("•")
                        .font(.dmSans(size: 13))
                        .foregroundColor(themeManager.secondaryTextColor.opacity(0.5))
                    
                    Text(session.performanceRating.rawValue)
                        .font(.dmSans(size: 13))
                        .foregroundColor(colorForRating)
                }
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
    
    // MARK: - Helper Properties
    
    private var iconForRating: String {
        switch session.performanceRating {
        case .fair:
            return "exclamationmark.triangle"
        case .good:
            return "checkmark.circle"
        case .perfect:
            return "star.circle.fill"
        }
    }
    
    private var colorForRating: Color {
        switch session.performanceRating {
        case .fair:
            return .orange
        case .good:
            return .blue
        case .perfect:
            return .green
        }
    }
    
    // MARK: - Helper Methods
    
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
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        
        if minutes > 0 {
            return "\(minutes)m \(seconds)s"
        } else {
            return "\(seconds)s"
        }
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



#Preview {
    let sampleStats = DistractionStats(
        todayDistractionsAvoided: 5,
        weeklyDistractionsAvoided: 8,
        totalDistractionsAvoided: 42,
        lastUpdated: Date()
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
    
    let sampleFocusStats = FocusTimeRangeStats(
        todayFocusTime: 1800,
        lastWeekFocusTime: 7200,
        totalFocusTime: 18000,
        todaySessions: [
            FocusSession(date: Date(), duration: 600)
        ],
        lastWeekSessions: [
            FocusSession(date: Date(), duration: 600)
        ],
        allSessions: [
            FocusSession(date: Date(), duration: 600)
        ]
    )
    
    FocusLogView(distractionStats: sampleStats, distractionLogs: sampleLogs, focusTimeRangeStats: sampleFocusStats)
        .environmentObject(ThemeManager())
        .frame(width: 600, height: 700)
}