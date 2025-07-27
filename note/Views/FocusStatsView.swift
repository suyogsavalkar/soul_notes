//
//  FocusStatsView.swift
//  note
//
//  Created by Kiro on 26/07/25.
//

import SwiftUI

struct FocusStatsView: View {
    let onTapStats: () -> Void
    @EnvironmentObject var focusTimerManager: FocusTimerManager
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        Button(action: onTapStats) {
            VStack(spacing: 8) {
                HStack(spacing: 16) {
                    // Focus time stat
                    HStack(spacing: 6) {
                        Image(systemName: "clock")
                            .font(.system(size: 14))
                            .foregroundColor(themeManager.accentColor)
                        
                        Text("\(focusTimerManager.formattedTotalFocusTime) hours focus")
                            .font(.dmSans(size: 12))
                            .foregroundColor(themeManager.secondaryTextColor)
                    }
                    
                    Spacer()
                }
                
                HStack(spacing: 16) {
                    // Distractions avoided stat
                    HStack(spacing: 6) {
                        Image(systemName: "shield.checkered")
                            .font(.system(size: 14))
                            .foregroundColor(themeManager.accentColor)
                        
                        Text("\(focusTimerManager.focusStats.distractionsAvoided) distractions avoided")
                            .font(.dmSans(size: 12))
                            .foregroundColor(themeManager.secondaryTextColor)
                    }
                    
                    Spacer()
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.clear)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel("Focus Statistics")
        .accessibilityHint("View detailed focus session logs")
    }
}

#Preview {
    FocusStatsView(onTapStats: {})
        .environmentObject(FocusTimerManager())
        .environmentObject(ThemeManager())
        .frame(width: 250)
        .padding()
}//
//  FocusStatsView.swift
//  note
//
//  Created by Kiro on 26/07/25.
//

import SwiftUI

struct FocusStatsView: View {
    let focusStats: FocusStats
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
                    
                    Text("\(focusStats.distractionsAvoided) distractions avoided")
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
        totalDistractions: 3,
        distractionsAvoided: 7,
        averageSessionLength: 720, // 12 minutes
        lastUpdated: Date()
    )
    
    FocusStatsView(
        focusStats: sampleStats,
        onTapStats: { print("Stats tapped") }
    )
    .environmentObject(ThemeManager())
    .frame(width: 250, height: 100)
    .padding()
}