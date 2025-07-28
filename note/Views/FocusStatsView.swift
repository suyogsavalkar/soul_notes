//
//  FocusStatsView.swift
//  note
//
//  Created by Kiro on 26/07/25.
//

import SwiftUI

struct FocusStatsView: View {
    let focusStats: FocusStats
    let distractionStats: DistractionStats
    let onTapStats: () -> Void
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 8) {
            // Focus time stat
            Button(action: onTapStats) {
                HStack(spacing: 8) {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 14))
                        .foregroundColor(themeManager.accentColor)
                    
                    Text("\(focusStats.formattedFocusTime) focus")
                        .font(.dmSans(size: 12))
                        .foregroundColor(themeManager.secondaryTextColor)
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.clear)
                )
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
            
            // Distractions avoided stat
            Button(action: onTapStats) {
                HStack(spacing: 8) {
                    Image(systemName: "shield.fill")
                        .font(.system(size: 14))
                        .foregroundColor(themeManager.accentColor)
                    
                    Text("\(distractionStats.totalDistractionsAvoided) distractions avoided")
                        .font(.dmSans(size: 12))
                        .foregroundColor(themeManager.secondaryTextColor)
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.clear)
                )
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
        }
        .accessibilityLabel("Focus statistics")
        .accessibilityHint("Tap to view detailed focus logs")
    }
}

#Preview {
    let sampleStats = FocusStats(
        totalFocusTime: 3600, // 1 hour
        totalSessions: 5,
        distractionsAvoided: 7,
        averageSessionLength: 720, // 12 minutes
        lastUpdated: Date()
    )
    
    FocusStatsView(
        focusStats: sampleStats,
        distractionStats: DistractionStats(totalDistractionsAvoided: 7),
        onTapStats: { print("Stats tapped") }
    )
    .environmentObject(ThemeManager())
    .frame(width: 250, height: 100)
    .padding()
}