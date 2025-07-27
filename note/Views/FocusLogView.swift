//
//  FocusLogView.swift
//  note
//
//  Created by Kiro on 26/07/25.
//

import SwiftUI

struct FocusLogView: View {
    @EnvironmentObject var focusTimerManager: FocusTimerManager
    @EnvironmentObject var themeManager: ThemeManager
    @State private var searchText: String = ""
    @State private var selectedFilter: LogFilter = .all
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header with search and filter
                VStack(spacing: 12) {
                    HStack {
                        Text("Focus Session Logs")
                            .font(.dmSansBold(size: 24))
                            .foregroundColor(themeManager.textColor)
                        
                        Spacer()
                        
                        Button("Done") {
                            dismiss()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    
                    // Search and filter controls
                    HStack(spacing: 12) {
                        // Search field
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(themeManager.secondaryTextColor)
                            
                            TextField("Search logs...", text: $searchText)
                                .textFieldStyle(PlainTextFieldStyle())
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(themeManager.secondaryTextColor.opacity(0.1))
                        )
                        
                        // Filter picker
                        Picker("Filter", selection: $selectedFilter) {
                            ForEach(LogFilter.allCases, id: \.self) { filter in
                                Text(filter.displayName).tag(filter)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(width: 120)
                    }
                }
                .padding(16)
                .background(themeManager.backgroundColor)
                
                Divider()
                    .background(themeManager.dividerColor)
                
                // Log entries list
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(filteredLogs) { logEntry in
                            FocusLogEntryView(logEntry: logEntry)
                                .environmentObject(themeManager)
                        }
                        
                        if filteredLogs.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: "clock.badge.questionmark")
                                    .font(.system(size: 48))
                                    .foregroundColor(themeManager.secondaryTextColor.opacity(0.5))
                                
                                Text("No focus sessions found")
                                    .font(.dmSansMedium(size: 18))
                                    .foregroundColor(themeManager.secondaryTextColor)
                                
                                Text("Start a focus session to see your activity here")
                                    .font(.dmSans(size: 14))
                                    .foregroundColor(themeManager.secondaryTextColor.opacity(0.7))
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.top, 60)
                        }
                    }
                    .padding(16)
                }
                .background(themeManager.backgroundColor)
            }
        }
        .background(themeManager.backgroundColor)
    }
    
    private var filteredLogs: [FocusLogEntry] {
        // Get logs from focus timer manager (we'll need to add this property)
        let allLogs = focusTimerManager.getAllLogs()
        
        var filtered = allLogs
        
        // Apply filter
        if selectedFilter != .all {
            if selectedFilter == .sessions {
                filtered = filtered.filter { $0.eventType == .sessionStart || $0.eventType == .sessionEnd }
            } else if let eventType = selectedFilter.eventType {
                filtered = filtered.filter { $0.eventType == eventType }
            }
        }
        
        // Apply search
        if !searchText.isEmpty {
            filtered = filtered.filter { logEntry in
                let searchLower = searchText.lowercased()
                return logEntry.eventType.rawValue.lowercased().contains(searchLower) ||
                       (logEntry.distractionReason?.lowercased().contains(searchLower) ?? false)
            }
        }
        
        // Sort by timestamp (most recent first)
        return filtered.sorted { $0.timestamp > $1.timestamp }
    }
}

struct FocusLogEntryView: View {
    let logEntry: FocusLogEntry
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Event type icon
            Image(systemName: eventIcon)
                .font(.system(size: 16))
                .foregroundColor(eventColor)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                // Event description
                Text(eventDescription)
                    .font(.dmSansMedium(size: 14))
                    .foregroundColor(themeManager.textColor)
                
                // Additional details
                if let details = eventDetails {
                    Text(details)
                        .font(.dmSans(size: 12))
                        .foregroundColor(themeManager.secondaryTextColor)
                }
                
                // Timestamp
                Text(formatTimestamp(logEntry.timestamp))
                    .font(.dmSans(size: 11))
                    .foregroundColor(themeManager.secondaryTextColor.opacity(0.7))
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
    
    private var eventIcon: String {
        switch logEntry.eventType {
        case .sessionStart:
            return "play.circle"
        case .sessionEnd:
            return "stop.circle"
        case .focusLoss:
            return "eye.slash"
        case .typingPause:
            return "pause.circle"
        case .distraction:
            return "exclamationmark.triangle"
        case .sessionReturn:
            return "arrow.uturn.left.circle"
        }
    }
    
    private var eventColor: Color {
        switch logEntry.eventType {
        case .sessionStart:
            return .green
        case .sessionEnd:
            return .blue
        case .focusLoss:
            return .orange
        case .typingPause:
            return .yellow
        case .distraction:
            return .red
        case .sessionReturn:
            return .green
        }
    }
    
    private var eventDescription: String {
        switch logEntry.eventType {
        case .sessionStart:
            return "Focus session started"
        case .sessionEnd:
            return "Focus session completed"
        case .focusLoss:
            return "App focus lost"
        case .typingPause:
            return "Typing paused"
        case .distraction:
            return "Distraction noted"
        case .sessionReturn:
            return "Returned to session"
        }
    }
    
    private var eventDetails: String? {
        switch logEntry.eventType {
        case .sessionStart, .sessionEnd:
            if let duration = logEntry.sessionDuration {
                let minutes = Int(duration) / 60
                let seconds = Int(duration) % 60
                return "Duration: \(minutes)m \(seconds)s"
            }
        case .focusLoss, .typingPause:
            if let remaining = logEntry.remainingTime {
                let minutes = Int(remaining) / 60
                let seconds = Int(remaining) % 60
                return "Time remaining: \(minutes)m \(seconds)s"
            }
        case .distraction:
            if let reason = logEntry.distractionReason, !reason.isEmpty {
                return "Reason: \(reason)"
            } else {
                return "No reason provided"
            }
        case .sessionReturn:
            return "Resumed focus session"
        }
        return nil
    }
    
    private func formatTimestamp(_ date: Date) -> String {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        
        if calendar.isDate(date, inSameDayAs: Date()) {
            formatter.timeStyle = .short
            return "Today at \(formatter.string(from: date))"
        } else if let yesterday = calendar.date(byAdding: .day, value: -1, to: Date()),
                  calendar.isDate(date, inSameDayAs: yesterday) {
            formatter.timeStyle = .short
            return "Yesterday at \(formatter.string(from: date))"
        } else {
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
    }
}

enum LogFilter: CaseIterable {
    case all
    case sessions
    case distractions
    case focusLoss
    
    var displayName: String {
        switch self {
        case .all:
            return "All Events"
        case .sessions:
            return "Sessions"
        case .distractions:
            return "Distractions"
        case .focusLoss:
            return "Focus Loss"
        }
    }
    
    var eventType: FocusEventType? {
        switch self {
        case .all:
            return nil
        case .sessions:
            return .sessionStart // We'll handle both start and end in filtering
        case .distractions:
            return .distraction
        case .focusLoss:
            return .focusLoss
        }
    }
}

#Preview {
    FocusLogView(focusLogs: sampleLogs)
        .environmentObject(ThemeManager())
        .frame(width: 600, height: 500)
}

struct FocusLogView: View {
    let focusLogs: [FocusLogEntry]
    @State private var searchText: String = ""
    @State private var selectedFilter: LogFilter = .all
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss
    
    var filteredLogs: [FocusLogEntry] {
        var logs = focusLogs
        
        // Apply filter
        switch selectedFilter {
        case .all:
            break
        case .sessions:
            logs = logs.filter { $0.eventType == .sessionStart || $0.eventType == .sessionEnd }
        case .distractions:
            logs = logs.filter { $0.eventType == .distraction || $0.eventType == .typingPause }
        case .focusLoss:
            logs = logs.filter { $0.eventType == .focusLoss || $0.eventType == .sessionReturn }
        }
        
        // Apply search
        if !searchText.isEmpty {
            logs = logs.filter { log in
                log.eventType.displayName.localizedCaseInsensitiveContains(searchText) ||
                (log.distractionReason?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
        
        return logs.sorted { $0.timestamp > $1.timestamp }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Focus Log")
                    .font(.dmSansBold(size: 18))
                    .foregroundColor(themeManager.textColor)
                
                Spacer()
                
                Button("Done") {
                    dismiss()
                }
                .buttonStyle(PlainButtonStyle())
                .foregroundColor(themeManager.accentColor)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(themeManager.backgroundColor)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(themeManager.dividerColor),
                alignment: .bottom
            )
            
            // Search and filter controls
            VStack(spacing: 12) {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 14))
                        .foregroundColor(themeManager.secondaryTextColor)
                    
                    TextField("Search logs...", text: $searchText)
                        .font(.dmSans(size: 14))
                        .foregroundColor(themeManager.textColor)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(themeManager.secondaryTextColor.opacity(0.1))
                )
                
                // Filter buttons
                HStack(spacing: 8) {
                    ForEach(LogFilter.allCases, id: \.self) { filter in
                        Button(filter.displayName) {
                            selectedFilter = filter
                        }
                        .font(.dmSans(size: 12))
                        .foregroundColor(selectedFilter == filter ? Color.white : themeManager.textColor)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(selectedFilter == filter ? themeManager.accentColor : themeManager.secondaryTextColor.opacity(0.1))
                        )
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    Spacer()
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(themeManager.backgroundColor)
            
            // Log entries
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(filteredLogs) { logEntry in
                        FocusLogEntryView(logEntry: logEntry)
                            .environmentObject(themeManager)
                    }
                    
                    if filteredLogs.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "clock.badge.questionmark")
                                .font(.system(size: 32))
                                .foregroundColor(themeManager.secondaryTextColor.opacity(0.5))
                            
                            Text(searchText.isEmpty ? "No focus sessions yet" : "No matching logs found")
                                .font(.dmSans(size: 14))
                                .foregroundColor(themeManager.secondaryTextColor)
                            
                            if searchText.isEmpty {
                                Text("Start a focus session to see your activity here")
                                    .font(.dmSans(size: 12))
                                    .foregroundColor(themeManager.secondaryTextColor.opacity(0.7))
                            }
                        }
                        .padding(.top, 40)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .background(themeManager.backgroundColor)
        }
        .frame(minWidth: 500, minHeight: 400)
        .background(themeManager.backgroundColor)
    }
}

struct FocusLogEntryView: View {
    let logEntry: FocusLogEntry
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Event icon
            Image(systemName: iconForEventType(logEntry.eventType))
                .font(.system(size: 16))
                .foregroundColor(colorForEventType(logEntry.eventType))
                .frame(width: 20)
            
            // Event details
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(logEntry.eventType.displayName)
                        .font(.dmSansMedium(size: 14))
                        .foregroundColor(themeManager.textColor)
                    
                    Spacer()
                    
                    Text(formatTimestamp(logEntry.timestamp))
                        .font(.dmSans(size: 12))
                        .foregroundColor(themeManager.secondaryTextColor)
                }
                
                // Additional details based on event type
                if let sessionDuration = logEntry.sessionDuration {
                    Text("Duration: \(formatDuration(sessionDuration))")
                        .font(.dmSans(size: 12))
                        .foregroundColor(themeManager.secondaryTextColor)
                }
                
                if let remainingTime = logEntry.remainingTime {
                    Text("Remaining: \(formatDuration(remainingTime))")
                        .font(.dmSans(size: 12))
                        .foregroundColor(themeManager.secondaryTextColor)
                }
                
                if let reason = logEntry.distractionReason, !reason.isEmpty {
                    Text("Reason: \(reason)")
                        .font(.dmSans(size: 12))
                        .foregroundColor(themeManager.secondaryTextColor)
                        .italic()
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(themeManager.cardBackgroundColor)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(themeManager.cardBorderColor, lineWidth: 1)
        )
    }
    
    private func iconForEventType(_ eventType: FocusEventType) -> String {
        switch eventType {
        case .sessionStart:
            return "play.circle.fill"
        case .sessionEnd:
            return "stop.circle.fill"
        case .focusLoss:
            return "eye.slash.fill"
        case .typingPause:
            return "pause.circle.fill"
        case .distraction:
            return "exclamationmark.triangle.fill"
        case .sessionReturn:
            return "arrow.uturn.left.circle.fill"
        }
    }
    
    private func colorForEventType(_ eventType: FocusEventType) -> Color {
        switch eventType {
        case .sessionStart:
            return .green
        case .sessionEnd:
            return .blue
        case .focusLoss:
            return .orange
        case .typingPause:
            return .yellow
        case .distraction:
            return .red
        case .sessionReturn:
            return .green
        }
    }
    
    private func formatTimestamp(_ date: Date) -> String {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        
        if calendar.isDate(date, inSameDayAs: Date()) {
            formatter.timeStyle = .short
            return formatter.string(from: date)
        } else if let yesterday = calendar.date(byAdding: .day, value: -1, to: Date()),
                  calendar.isDate(date, inSameDayAs: yesterday) {
            formatter.timeStyle = .short
            return "Yesterday, \(formatter.string(from: date))"
        } else {
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
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

#Preview {
    let sampleLogs = [
        FocusLogEntry(
            timestamp: Date(),
            eventType: .sessionStart,
            sessionDuration: 600
        ),
        FocusLogEntry(
            timestamp: Date().addingTimeInterval(-300),
            eventType: .distraction,
            distractionReason: "Phone notification",
            remainingTime: 300
        ),
        FocusLogEntry(
            timestamp: Date().addingTimeInterval(-600),
            eventType: .sessionEnd,
            sessionDuration: 480
        )
    ]
    
    FocusLogView(focusLogs: sampleLogs)
        .environmentObject(ThemeManager())
        .frame(width: 600, height: 500)
}