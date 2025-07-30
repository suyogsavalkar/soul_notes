//
//  FocusTimerControl.swift
//  note
//
//  Created by Kiro on 26/07/25.
//

import SwiftUI

struct FocusTimerControl: View {
    @EnvironmentObject var focusTimerManager: FocusTimerManager
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        Button(action: {
            if focusTimerManager.isTimerRunning {
                focusTimerManager.stopTimer()
            } else {
                focusTimerManager.startTimer(duration: focusTimerManager.selectedDuration)
            }
        }) {
            HStack(spacing: 4) {
                Image(systemName: focusTimerManager.isTimerRunning ? "pause.circle" : "play.circle")
                    .font(.system(size: 16))
                    .foregroundColor(focusTimerManager.isTimerRunning ? themeManager.accentColor : themeManager.textColor)
                
                Text(focusTimerManager.isTimerRunning ? focusTimerManager.formattedRemainingTime : focusTimerManager.formattedSelectedDuration)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(themeManager.secondaryTextColor)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(focusTimerManager.isTimerRunning ? themeManager.accentColor.opacity(0.1) : themeManager.secondaryTextColor.opacity(0.1))
            )
        }
        .buttonStyle(HoverButtonStyle())
        .tooltip(
            focusTimerManager.isTimerRunning ? "Stop focus session" : "Start a focused session",
            position: .top
        )
        .accessibilityLabel(focusTimerManager.isTimerRunning ? "Stop focus timer" : "Start focus timer")
        .accessibilityHint("Current duration: \(focusTimerManager.formattedSelectedDuration)")
        .onLongPressGesture {
            // Long press to change duration (only when timer is not running)
            if !focusTimerManager.isTimerRunning {
                focusTimerManager.cycleDuration()
            }
        }
    }
}

#Preview {
    HStack {
        FocusTimerControl()
            .environmentObject(FocusTimerManager())
            .environmentObject(ThemeManager())
    }
    .padding()
}