//
//  FocusStatisticsView.swift
//  note
//
//  Created by Kiro on 29/07/25.
//

import SwiftUI

struct FocusStatisticsView: View {
    let stats: FocusTimeRangeStats
    @State private var hoveredStat: FocusStatType? = nil
    @StateObject private var screenshotManager = AchievementScreenshotManager()
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 24) {
            // Focus achievement statistics
            VStack(spacing: 16) {
                FocusAchievementStatisticView(
                    focusTime: stats.formattedTodayFocusTime,
                    description: "Focused time today",
                    statType: .todayFocus,
                    hoveredStat: $hoveredStat,
                    onShare: shareFocusAchievement
                )
                
                FocusAchievementStatisticView(
                    focusTime: stats.formattedLastWeekFocusTime,
                    description: "Focused time last week",
                    statType: .weeklyFocus,
                    hoveredStat: $hoveredStat,
                    onShare: shareFocusAchievement
                )
                
                FocusAchievementStatisticView(
                    focusTime: stats.formattedTotalFocusTime,
                    description: "Total focused time",
                    statType: .totalFocus,
                    hoveredStat: $hoveredStat,
                    onShare: shareFocusAchievement
                )
            }
            .padding(.horizontal, 24)
            
            Divider()
                .background(themeManager.dividerColor)
            
            // Focus sessions
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Recent Focus Sessions")
                        .font(.dmSansMedium(size: 18))
                        .foregroundColor(themeManager.textColor)
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(stats.allSessions.sorted { $0.date > $1.date }) { session in
                            FocusLogEntryView(session: session)
                                .environmentObject(themeManager)
                        }
                        
                        if stats.allSessions.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: "clock")
                                    .font(.system(size: 48))
                                    .foregroundColor(themeManager.accentColor.opacity(0.5))
                                
                                Text("No focus sessions yet")
                                    .font(.dmSansMedium(size: 16))
                                    .foregroundColor(themeManager.secondaryTextColor)
                                
                                Text("Start a focus timer to see your sessions here!")
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
            screenshotFeedbackView
        }
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
    
    // MARK: - Helper Methods
    
    func shareFocusAchievement(for statType: FocusStatType) {
        guard let image = screenshotManager.captureFocusAchievementSection(for: statType, stats: stats) else {
            screenshotManager.handleScreenshotError(NSError(domain: "ScreenshotError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to generate focus achievement image"]))
            return
        }
        
        if screenshotManager.openInPreview(image) {
            screenshotManager.showPreviewSuccess()
        } else {
            screenshotManager.handleScreenshotError(NSError(domain: "PreviewError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to open image in Preview"]))
        }
    }
}

#Preview {
    let sampleStats = FocusTimeRangeStats(
        todayFocusTime: 1800, // 30 minutes
        lastWeekFocusTime: 7200, // 2 hours
        totalFocusTime: 18000, // 5 hours
        todaySessions: [
            FocusSession(date: Date(), duration: 600),
            FocusSession(date: Date().addingTimeInterval(-3600), duration: 1200)
        ],
        lastWeekSessions: [
            FocusSession(date: Date(), duration: 600),
            FocusSession(date: Date().addingTimeInterval(-86400), duration: 900)
        ],
        allSessions: [
            FocusSession(date: Date(), duration: 600),
            FocusSession(date: Date().addingTimeInterval(-86400), duration: 900),
            FocusSession(date: Date().addingTimeInterval(-172800), duration: 300)
        ]
    )
    
    FocusStatisticsView(stats: sampleStats)
        .environmentObject(ThemeManager())
        .frame(width: 500, height: 600)
}