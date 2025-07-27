// //
// //  FocusTimerManager.swift
// //  note
// //
// //  Created by Kiro on 26/07/25.
// //

// import SwiftUI
// import Combine
// import AppKit

// class FocusTimerManager: ObservableObject {
//     @Published var isTimerRunning: Bool = false
//     @Published var remainingTime: TimeInterval = 600 // 10 minutes default
//     @Published var selectedDuration: TimeInterval = 600 // 10 minutes default
//     @Published var focusStats: FocusStats = FocusStats()
    
//     private var timer: Timer?
//     private var focusLogs: [FocusLogEntry] = []
//     private var currentSessionStartTime: Date?
//     private var lastTypingTime: Date = Date()
//     private var typingTimer: Timer?
//     private var isAppInFocus: Bool = true
    
//     private let availableDurations: [TimeInterval] = [300, 600] // 5 and 10 minutes
//     private let storageKey = "FocusLogs"
//     private let statsKey = "FocusStats"
    
//     init() {
//         loadFocusData()
//         setupAppFocusMonitoring()
//     }
    
//     deinit {
//         timer?.invalidate()
//         typingTimer?.invalidate()
//         NotificationCenter.default.removeObserver(self)
//     }
    
//     // MARK: - Timer Control
    
//     func startTimer(duration: TimeInterval) {
//         selectedDuration = duration
//         remainingTime = duration
//         isTimerRunning = true
//         currentSessionStartTime = Date()
//         lastTypingTime = Date()
        
//         // Log session start
//         logEvent(.sessionStart, sessionDuration: duration)
        
//         // Start the countdown timer
//         timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
//             self.updateTimer()
//         }
        
//         // Start typing monitoring
//         startTypingMonitoring()
//     }
    
//     func stopTimer() {
//         timer?.invalidate()
//         timer = nil
//         typingTimer?.invalidate()
//         typingTimer = nil
        
//         if isTimerRunning {
//             // Log session end
//             let sessionDuration = selectedDuration - remainingTime
//             logEvent(.sessionEnd, sessionDuration: sessionDuration)
//             updateStats()
//         }
        
//         isTimerRunning = false
//         remainingTime = selectedDuration
//         currentSessionStartTime = nil
//     }
    
//     func pauseTimer() {
//         timer?.invalidate()
//         timer = nil
//         typingTimer?.invalidate()
//         typingTimer = nil
//         isTimerRunning = false
//     }
    
//     func cycleDuration() {
//         if !isTimerRunning {
//             if let currentIndex = availableDurations.firstIndex(of: selectedDuration) {
//                 let nextIndex = (currentIndex + 1) % availableDurations.count
//                 selectedDuration = availableDurations[nextIndex]
//                 remainingTime = selectedDuration
//             }
//         }
//     }
    
//     // MARK: - Timer Updates
    
//     private func updateTimer() {
//         if remainingTime > 0 {
//             remainingTime -= 1
//         } else {
//             // Timer completed
//             completeSession()
//         }
//     }
    
//     private func completeSession() {
//         let sessionDuration = selectedDuration
//         logEvent(.sessionEnd, sessionDuration: sessionDuration)
//         updateStats()
//         stopTimer()
        
//         // Show completion notification
//         showSessionCompleteNotification()
//     }
    
//     // MARK: - Focus Monitoring
    
//     private func setupAppFocusMonitoring() {
//         NotificationCenter.default.addObserver(
//             self,
//             selector: #selector(appDidBecomeActive),
//             name: NSApplication.didBecomeActiveNotification,
//             object: nil
//         )
        
//         NotificationCenter.default.addObserver(
//             self,
//             selector: #selector(appDidResignActive),
//             name: NSApplication.didResignActiveNotification,
//             object: nil
//         )
//     }
    
//     @objc private func appDidBecomeActive() {
//         isAppInFocus = true
//     }
    
//     @objc private func appDidResignActive() {
//         isAppInFocus = false
//         if isTimerRunning {
//             handleFocusLoss()
//         }
//     }
    
//     func handleFocusLoss() {
//         guard isTimerRunning else { return }
        
//         logEvent(.focusLoss, remainingTime: remainingTime)
//         showFocusLossAlert()
//     }
    
//     private func showFocusLossAlert() {
//         let minutes = Int(remainingTime) / 60
//         let seconds = Int(remainingTime) % 60
//         let timeString = String(format: "%02d:%02d", minutes, seconds)
        
//         do {
//             let alert = NSAlert()
//             alert.messageText = "Focus Session Active"
//             alert.informativeText = "You still have \(timeString) minutes left to focus on yourself"
//             alert.addButton(withTitle: "Return")
//             alert.addButton(withTitle: "Cancel")
//             alert.alertStyle = .informational
            
//             DispatchQueue.main.async {
//                 do {
//                     let response = alert.runModal()
//                     if response == .alertFirstButtonReturn {
//                         // Return button clicked
//                         self.logEvent(.sessionReturn)
//                         NSApp.activate(ignoringOtherApps: true)
//                     } else {
//                         // Cancel button clicked
//                         self.stopTimer()
//                     }
//                 } catch {
//                     print("Failed to show focus loss alert: \(error)")
//                     // Fallback: Just stop the timer
//                     self.stopTimer()
//                 }
//             }
//         } catch {
//             print("Failed to create focus loss alert: \(error)")
//             // Fallback: Stop timer without user interaction
//             stopTimer()
//         }
//     }
    
//     // MARK: - Typing Monitoring
    
//     private func startTypingMonitoring() {
//         typingTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
//             self.checkTypingActivity()
//         }
//     }
    
//     private func checkTypingActivity() {
//         guard isTimerRunning else { return }
        
//         let timeSinceLastTyping = Date().timeIntervalSince(lastTypingTime)
//         if timeSinceLastTyping >= 15.0 {
//             handleTypingPause()
//         }
//     }
    
//     func updateLastTypingTime() {
//         lastTypingTime = Date()
//     }
    
//     func handleTypingPause() {
//         guard isTimerRunning else { return }
        
//         logEvent(.typingPause, remainingTime: remainingTime)
//         showTypingPauseAlert()
//     }
    
//     private func showTypingPauseAlert() {
//         do {
//             let alert = NSAlert()
//             alert.messageText = "You stopped typing"
//             alert.informativeText = "What's happening?"
//             alert.addButton(withTitle: "I am thinking")
//             alert.addButton(withTitle: "I was distracted")
//             alert.alertStyle = .informational
            
//             DispatchQueue.main.async {
//                 do {
//                     let response = alert.runModal()
//                     if response == .alertFirstButtonReturn {
//                         // "I am thinking" - continue session
//                         self.lastTypingTime = Date()
//                     } else {
//                         // "I was distracted" - show distraction dialog
//                         self.showDistractionDialog()
//                     }
//                 } catch {
//                     print("Failed to show typing pause alert: \(error)")
//                     // Fallback: Assume user is thinking and continue
//                     self.lastTypingTime = Date()
//                 }
//             }
//         } catch {
//             print("Failed to create typing pause alert: \(error)")
//             // Fallback: Continue session
//             lastTypingTime = Date()
//         }
//     }
    
//     private func showDistractionDialog() {
//         let alert = NSAlert()
//         alert.messageText = "Distraction Noted"
//         alert.informativeText = "What were you distracted by? (Optional)"
        
//         let textField = NSTextField(frame: NSRect(x: 0, y: 0, width: 300, height: 24))
//         textField.placeholderString = "Enter distraction reason..."
//         alert.accessoryView = textField
        
//         alert.addButton(withTitle: "Return to the note")
//         alert.addButton(withTitle: "End the session")
//         alert.alertStyle = .informational
        
//         DispatchQueue.main.async {
//             let response = alert.runModal()
//             let reason = textField.stringValue.isEmpty ? nil : textField.stringValue
            
//             if response == .alertFirstButtonReturn {
//                 // "Return to the note"
//                 self.logDistraction(reason: reason)
//                 self.lastTypingTime = Date()
//             } else {
//                 // "End the session"
//                 self.logDistraction(reason: reason)
//                 self.logSessionEnd()
//                 self.stopTimer()
//             }
//         }
//     }
    
//     // MARK: - Event Logging
    
//     func logDistraction(reason: String?) {
//         logEvent(.distraction, distractionReason: reason, remainingTime: remainingTime)
//     }
    
//     func logSessionEnd() {
//         guard let startTime = currentSessionStartTime else { return }
//         let sessionDuration = Date().timeIntervalSince(startTime)
//         logEvent(.sessionEnd, sessionDuration: sessionDuration)
//         updateStats()
//     }
    
//     private func logEvent(_ eventType: FocusEventType, sessionDuration: TimeInterval? = nil, distractionReason: String? = nil, remainingTime: TimeInterval? = nil) {
//         let logEntry = FocusLogEntry(
//             timestamp: Date(),
//             eventType: eventType,
//             sessionDuration: sessionDuration,
//             distractionReason: distractionReason,
//             remainingTime: remainingTime
//         )
        
//         focusLogs.append(logEntry)
//         saveFocusLogs()
//     }
    
//     // MARK: - Statistics
    
//     func calculateStats() -> FocusStats {
//         var totalFocusTime: TimeInterval = 0
//         var totalSessions = 0
//         var distractionsAvoided = 0
        
//         for log in focusLogs {
//             switch log.eventType {
//             case .sessionEnd:
//                 if let duration = log.sessionDuration {
//                     totalFocusTime += duration
//                     totalSessions += 1
//                 }
//             case .sessionReturn:
//                 distractionsAvoided += 1
//             default:
//                 break
//             }
//         }
        
//         let averageSessionLength = totalSessions > 0 ? totalFocusTime / Double(totalSessions) : 0
        
//         return FocusStats(
//             totalFocusTime: totalFocusTime,
//             totalSessions: totalSessions,
//             distractionsAvoided: distractionsAvoided,
//             averageSessionLength: averageSessionLength,
//             lastUpdated: Date()
//         )
//     }
    
//     private func updateStats() {
//         focusStats = calculateStats()
//         saveFocusStats()
//     }
    
//     // MARK: - Public Access Methods
    
//     func getAllLogs() -> [FocusLogEntry] {
//         return focusLogs
//     }
    
//     // MARK: - Computed Properties
    
//     var formattedRemainingTime: String {
//         let minutes = Int(remainingTime) / 60
//         let seconds = Int(remainingTime) % 60
//         return String(format: "%02d:%02d", minutes, seconds)
//     }
    
//     var formattedSelectedDuration: String {
//         let minutes = Int(selectedDuration) / 60
//         return "\(minutes) min"
//     }
    
//     var formattedTotalFocusTime: String {
//         let hours = focusStats.totalFocusTime / 3600
//         return String(format: "%.1f", hours)
//     }
    
//     // MARK: - Persistence
    
//     private func saveFocusLogs() {
//         do {
//             let data = try JSONEncoder().encode(focusLogs)
//             let url = getDocumentsDirectory().appendingPathComponent("focus-logs.json")
//             try data.write(to: url)
//         } catch {
//             print("Failed to save focus logs: \(error)")
//             // Try backup location
//             saveFocusLogsBackup()
//         }
//     }
    
//     private func saveFocusLogsBackup() {
//         do {
//             let data = try JSONEncoder().encode(focusLogs)
//             let backupURL = getDocumentsDirectory().appendingPathComponent("focus-logs-backup.json")
//             try data.write(to: backupURL)
//             print("Focus logs saved to backup location")
//         } catch {
//             print("Failed to save focus logs backup: \(error)")
//             // Log corruption - truncate to last 100 entries to prevent file size issues
//             if focusLogs.count > 100 {
//                 focusLogs = Array(focusLogs.suffix(100))
//                 saveFocusLogs() // Try again with smaller dataset
//             }
//         }
//     }
    
//     private func saveFocusStats() {
//         do {
//             let data = try JSONEncoder().encode(focusStats)
//             let url = getDocumentsDirectory().appendingPathComponent("focus-stats.json")
//             try data.write(to: url)
//         } catch {
//             print("Failed to save focus stats: \(error)")
//             // Try backup location
//             saveFocusStatsBackup()
//         }
//     }
    
//     private func saveFocusStatsBackup() {
//         do {
//             let data = try JSONEncoder().encode(focusStats)
//             let backupURL = getDocumentsDirectory().appendingPathComponent("focus-stats-backup.json")
//             try data.write(to: backupURL)
//             print("Focus stats saved to backup location")
//         } catch {
//             print("Failed to save focus stats backup: \(error)")
//             // Reset stats if corruption is severe
//             focusStats = FocusStats()
//         }
//     }
    
//     private func loadFocusData() {
//         loadFocusLogs()
//         loadFocusStats()
//     }
    
//     private func loadFocusLogs() {
//         do {
//             let url = getDocumentsDirectory().appendingPathComponent("focus-logs.json")
//             let data = try Data(contentsOf: url)
//             focusLogs = try JSONDecoder().decode([FocusLogEntry].self, from: data)
//         } catch {
//             print("Failed to load focus logs: \(error)")
//             // Try backup
//             if loadFocusLogsBackup() {
//                 return
//             }
//             // Default to empty
//             focusLogs = []
//         }
//     }
    
//     private func loadFocusLogsBackup() -> Bool {
//         do {
//             let backupURL = getDocumentsDirectory().appendingPathComponent("focus-logs-backup.json")
//             let data = try Data(contentsOf: backupURL)
//             focusLogs = try JSONDecoder().decode([FocusLogEntry].self, from: data)
//             print("Focus logs loaded from backup")
//             // Try to restore main file
//             saveFocusLogs()
//             return true
//         } catch {
//             return false
//         }
//     }
    
//     private func loadFocusStats() {
//         do {
//             let url = getDocumentsDirectory().appendingPathComponent("focus-stats.json")
//             let data = try Data(contentsOf: url)
//             focusStats = try JSONDecoder().decode(FocusStats.self, from: data)
//         } catch {
//             print("Failed to load focus stats: \(error)")
//             // Try backup
//             if loadFocusStatsBackup() {
//                 return
//             }
//             // Default to empty stats
//             focusStats = FocusStats()
//         }
//     }
    
//     private func loadFocusStatsBackup() -> Bool {
//         do {
//             let backupURL = getDocumentsDirectory().appendingPathComponent("focus-stats-backup.json")
//             let data = try Data(contentsOf: url)
//             focusStats = try JSONDecoder().decode(FocusStats.self, from: data)
//             print("Focus stats loaded from backup")
//             // Try to restore main file
//             saveFocusStats()
//             return true
//         } catch {
//             return false
//         }
//     }
    
//     private func getDocumentsDirectory() -> URL {
//         let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//         let documentsDirectory = paths[0].appendingPathComponent("NotesApp")
        
//         // Create directory if it doesn't exist
//         try? FileManager.default.createDirectory(at: documentsDirectory, withIntermediateDirectories: true)
        
//         return documentsDirectory
//     }
    
//     // MARK: - Notifications
    
//     private func showSessionCompleteNotification() {
//         let alert = NSAlert()
//         alert.messageText = "Focus Session Complete!"
//         alert.informativeText = "Great job! You completed a \(formattedSelectedDuration) focus session."
//         alert.addButton(withTitle: "OK")
//         alert.alertStyle = .informational
        
//         DispatchQueue.main.async {
//             alert.runModal()
//         }
//     }
// }

// // MARK: - Data Models

// struct FocusLogEntry: Identifiable, Codable {
//     let id: UUID
//     let timestamp: Date
//     let eventType: FocusEventType
//     let sessionDuration: TimeInterval?
//     let distractionReason: String?
//     let remainingTime: TimeInterval?
    
//     init(timestamp: Date, eventType: FocusEventType, sessionDuration: TimeInterval? = nil, distractionReason: String? = nil, remainingTime: TimeInterval? = nil) {
//         self.id = UUID()
//         self.timestamp = timestamp
//         self.eventType = eventType
//         self.sessionDuration = sessionDuration
//         self.distractionReason = distractionReason
//         self.remainingTime = remainingTime
//     }
// }

// enum FocusEventType: String, Codable, CaseIterable {
//     case sessionStart = "session_start"
//     case sessionEnd = "session_end"
//     case focusLoss = "focus_loss"
//     case typingPause = "typing_pause"
//     case distraction = "distraction"
//     case sessionReturn = "session_return"
// }

// struct FocusStats: Codable {
//     var totalFocusTime: TimeInterval = 0
//     var totalSessions: Int = 0
//     var distractionsAvoided: Int = 0
//     var averageSessionLength: TimeInterval = 0
//     var lastUpdated: Date = Date()
// }imer()
//             }
//         }
//     }
    
//     // MARK: - Typing Activity Monitoring
    
//     /// Handles when user stops typing for extended period
//     func handleTypingPause() {
//         guard isTimerRunning else { return }
        
//         logEvent(.typingPause, remainingTime: remainingTime)
//         showTypingPauseAlert()
//     }
    
//     private func showTypingPauseAlert() {
//         let alert = NSAlert()
//         alert.messageText = "You stopped typing"
//         alert.informativeText = "What's happening?"
//         alert.alertStyle = .informational
        
//         alert.addButton(withTitle: "I am thinking")
//         alert.addButton(withTitle: "I was distracted")
        
//         DispatchQueue.main.async {
//             let response = alert.runModal()
            
//             if response == .alertFirstButtonReturn {
//                 // User chose "I am thinking" - continue session
//                 return
//             } else {
//                 // User chose "I was distracted" - show distraction dialog
//                 self.showDistractionDialog()
//             }
//         }
//     }
    
//     private func showDistractionDialog() {
//         let alert = NSAlert()
//         alert.messageText = "What were you distracted by?"
//         alert.informativeText = "Optional - help us understand your focus patterns"
//         alert.alertStyle = .informational
        
//         // Add text field for distraction reason
//         let textField = NSTextField(frame: NSRect(x: 0, y: 0, width: 300, height: 24))
//         textField.placeholderString = "Enter distraction reason (optional)"
//         alert.accessoryView = textField
        
//         alert.addButton(withTitle: "Return to the note")
//         alert.addButton(withTitle: "End the session")
        
//         DispatchQueue.main.async {
//             let response = alert.runModal()
//             let distractionReason = textField.stringValue.isEmpty ? nil : textField.stringValue
            
//             if response == .alertFirstButtonReturn {
//                 // User chose "Return to the note"
//                 self.logDistraction(reason: distractionReason)
//             } else {
//                 // User chose "End the session"
//                 self.logDistraction(reason: distractionReason)
//                 self.stopTimer()
//             }
//         }
//     }
    
//     // MARK: - Logging
    
//     /// Logs a distraction event with optional reason
//     func logDistraction(reason: String?) {
//         logEvent(.distraction, distractionReason: reason, remainingTime: remainingTime)
        
//         // Update stats - this counts as a distraction
//         focusStats.totalDistractions += 1
//         saveFocusStats()
//     }
    
//     /// Logs session end event
//     func logSessionEnd() {
//         if let startTime = sessionStartTime {
//             let sessionDuration = Date().timeIntervalSince(startTime)
//             logEvent(.sessionEnd, sessionDuration: sessionDuration)
//             updateFocusStats(sessionDuration: sessionDuration)
//         }
//     }
    
//     private func logEvent(
//         _ eventType: FocusEventType,
//         sessionDuration: TimeInterval? = nil,
//         distractionReason: String? = nil,
//         remainingTime: TimeInterval? = nil
//     ) {
//         let logEntry = FocusLogEntry(
//             timestamp: Date(),
//             eventType: eventType,
//             sessionDuration: sessionDuration,
//             distractionReason: distractionReason,
//             remainingTime: remainingTime
//         )
        
//         focusLogs.append(logEntry)
//         saveFocusLogs()
//     }
    
//     // MARK: - Statistics
    
//     private func updateFocusStats(sessionDuration: TimeInterval) {
//         focusStats.totalFocusTime += sessionDuration
//         focusStats.totalSessions += 1
//         focusStats.averageSessionLength = focusStats.totalFocusTime / Double(focusStats.totalSessions)
//         focusStats.lastUpdated = Date()
        
//         saveFocusStats()
//     }
    
//     /// Calculates and returns current focus statistics
//     func calculateStats() -> FocusStats {
//         return focusStats
//     }
    
//     // MARK: - Data Persistence
    
//     private func saveFocusStats() {
//         do {
//             let data = try JSONEncoder().encode(focusStats)
//             let url = getFocusStatsURL()
//             try data.write(to: url)
//         } catch {
//             print("Failed to save focus stats: \(error)")
//         }
//     }
    
//     private func loadFocusStats() {
//         do {
//             let url = getFocusStatsURL()
//             let data = try Data(contentsOf: url)
//             focusStats = try JSONDecoder().decode(FocusStats.self, from: data)
//         } catch {
//             // Use default stats if loading fails
//             focusStats = FocusStats()
//             print("Failed to load focus stats, using default: \(error)")
//         }
//     }
    
//     private func saveFocusLogs() {
//         do {
//             let data = try JSONEncoder().encode(focusLogs)
//             let url = getFocusLogsURL()
//             try data.write(to: url)
//         } catch {
//             print("Failed to save focus logs: \(error)")
//         }
//     }
    
//     private func loadFocusLogs() {
//         do {
//             let url = getFocusLogsURL()
//             let data = try Data(contentsOf: url)
//             focusLogs = try JSONDecoder().decode([FocusLogEntry].self, from: data)
//         } catch {
//             // Use empty logs if loading fails
//             focusLogs = []
//             print("Failed to load focus logs, using empty: \(error)")
//         }
//     }
    
//     private func getFocusStatsURL() -> URL {
//         let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//         let notesAppPath = documentsPath.appendingPathComponent("NotesApp")
        
//         // Create directory if it doesn't exist
//         try? FileManager.default.createDirectory(at: notesAppPath, withIntermediateDirectories: true)
        
//         return notesAppPath.appendingPathComponent("focus-stats.json")
//     }
    
//     private func getFocusLogsURL() -> URL {
//         let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//         let notesAppPath = documentsPath.appendingPathComponent("NotesApp")
        
//         // Create directory if it doesn't exist
//         try? FileManager.default.createDirectory(at: notesAppPath, withIntermediateDirectories: true)
        
//         return notesAppPath.appendingPathComponent("focus-logs.json")
//     }
    
//     // MARK: - Utility
    
//     /// Returns available timer durations
//     var availableTimerDurations: [TimeInterval] {
//         return availableDurations
//     }
    
//     /// Formats time interval to MM:SS format
//     func formatTime(_ timeInterval: TimeInterval) -> String {
//         let minutes = Int(timeInterval) / 60
//         let seconds = Int(timeInterval) % 60
//         return String(format: "%02d:%02d", minutes, seconds)
//     }
    
//     /// Returns focus logs for display
//     func getFocusLogs() -> [FocusLogEntry] {
//         return focusLogs.sorted { $0.timestamp > $1.timestamp }
//     }
// }

// // MARK: - Data Models

// /// Data model for focus session logs
// struct FocusLogEntry: Identifiable, Codable {
//     let id: UUID
//     let timestamp: Date
//     let eventType: FocusEventType
//     let sessionDuration: TimeInterval?
//     let distractionReason: String?
//     let remainingTime: TimeInterval?
    
//     init(
//         timestamp: Date,
//         eventType: FocusEventType,
//         sessionDuration: TimeInterval? = nil,
//         distractionReason: String? = nil,
//         remainingTime: TimeInterval? = nil
//     ) {
//         self.id = UUID()
//         self.timestamp = timestamp
//         self.eventType = eventType
//         self.sessionDuration = sessionDuration
//         self.distractionReason = distractionReason
//         self.remainingTime = remainingTime
//     }
// }

// /// Types of focus events that can be logged
// enum FocusEventType: String, Codable, CaseIterable {
//     case sessionStart = "session_start"
//     case sessionEnd = "session_end"
//     case focusLoss = "focus_loss"
//     case typingPause = "typing_pause"
//     case distraction = "distraction"
//     case sessionReturn = "session_return"
    
//     var displayName: String {
//         switch self {
//         case .sessionStart:
//             return "Session Started"
//         case .sessionEnd:
//             return "Session Ended"
//         case .focusLoss:
//             return "Focus Lost"
//         case .typingPause:
//             return "Typing Paused"
//         case .distraction:
//             return "Distraction"
//         case .sessionReturn:
//             return "Returned to Session"
//         }
//     }
// }

// /// Aggregated focus statistics
// struct FocusStats: Codable {
//     var totalFocusTime: TimeInterval = 0
//     var totalSessions: Int = 0
//     var totalDistractions: Int = 0
//     var distractionsAvoided: Int = 0
//     var averageSessionLength: TimeInterval = 0
//     var lastUpdated: Date = Date()
    
//     /// Returns total focus time in hours
//     var totalFocusHours: Double {
//         return totalFocusTime / 3600
//     }
    
//     /// Returns formatted focus time string
//     var formattedFocusTime: String {
//         let hours = Int(totalFocusTime) / 3600
//         let minutes = (Int(totalFocusTime) % 3600) / 60
        
//         if hours > 0 {
//             return "\(hours)h \(minutes)m"
//         } else {
//             return "\(minutes)m"
//         }
//     }
// }

//
//  FocusTimerManager.swift
//  note
//
//  Created by Kiro on 26/07/25.
//

import SwiftUI
import Combine
import AppKit

class FocusTimerManager: ObservableObject {
    @Published var isTimerRunning: Bool = false
    @Published var remainingTime: TimeInterval = 600 // 10 minutes default
    @Published var selectedDuration: TimeInterval = 600 // 10 minutes default
    @Published var focusStats: FocusStats = FocusStats()
    
    private var timer: Timer?
    private var focusLogs: [FocusLogEntry] = []
    private var currentSessionStartTime: Date?
    private var lastTypingTime: Date = Date()
    private var typingTimer: Timer?
    private var isAppInFocus: Bool = true
    
    private let availableDurations: [TimeInterval] = [300, 600] // 5 and 10 minutes
    private let storageKey = "FocusLogs"
    private let statsKey = "FocusStats"
    
    init() {
        loadFocusData()
        setupAppFocusMonitoring()
    }
    
    deinit {
        timer?.invalidate()
        typingTimer?.invalidate()
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Timer Control
    
    func startTimer(duration: TimeInterval) {
        selectedDuration = duration
        remainingTime = duration
        isTimerRunning = true
        currentSessionStartTime = Date()
        lastTypingTime = Date()
        
        // Log session start
        logEvent(.sessionStart, sessionDuration: duration)
        
        // Start the countdown timer
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.updateTimer()
        }
        
        // Start typing monitoring
        startTypingMonitoring()
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        typingTimer?.invalidate()
        typingTimer = nil
        
        if isTimerRunning {
            // Log session end
            let sessionDuration = selectedDuration - remainingTime
            logEvent(.sessionEnd, sessionDuration: sessionDuration)
            updateStats()
        }
        
        isTimerRunning = false
        remainingTime = selectedDuration
        currentSessionStartTime = nil
    }
    
    func pauseTimer() {
        timer?.invalidate()
        timer = nil
        typingTimer?.invalidate()
        typingTimer = nil
        isTimerRunning = false
    }
    
    func cycleDuration() {
        if !isTimerRunning {
            if let currentIndex = availableDurations.firstIndex(of: selectedDuration) {
                let nextIndex = (currentIndex + 1) % availableDurations.count
                selectedDuration = availableDurations[nextIndex]
                remainingTime = selectedDuration
            }
        }
    }
    
    // MARK: - Timer Updates
    
    private func updateTimer() {
        if remainingTime > 0 {
            remainingTime -= 1
        } else {
            // Timer completed
            completeSession()
        }
    }
    
    private func completeSession() {
        let sessionDuration = selectedDuration
        logEvent(.sessionEnd, sessionDuration: sessionDuration)
        updateStats()
        stopTimer()
        
        // Show completion notification
        showSessionCompleteNotification()
    }
    
    // MARK: - Focus Monitoring
    
    private func setupAppFocusMonitoring() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidBecomeActive),
            name: NSApplication.didBecomeActiveNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidResignActive),
            name: NSApplication.didResignActiveNotification,
            object: nil
        )
    }
    
    @objc private func appDidBecomeActive() {
        isAppInFocus = true
    }
    
    @objc private func appDidResignActive() {
        isAppInFocus = false
        if isTimerRunning {
            handleFocusLoss()
        }
    }
    
    func handleFocusLoss() {
        guard isTimerRunning else { return }
        
        logEvent(.focusLoss, remainingTime: remainingTime)
        showFocusLossAlert()
    }
    
    private func showFocusLossAlert() {
        let minutes = Int(remainingTime) / 60
        let seconds = Int(remainingTime) % 60
        let timeString = String(format: "%02d:%02d", minutes, seconds)
        
        let alert = NSAlert()
        alert.messageText = "Focus Session Active"
        alert.informativeText = "You still have \(timeString) minutes left to focus on yourself"
        alert.addButton(withTitle: "Return")
        alert.addButton(withTitle: "Cancel")
        alert.alertStyle = .informational
        
        DispatchQueue.main.async {
            let response = alert.runModal()
            if response == .alertFirstButtonReturn {
                // Return button clicked
                self.logEvent(.sessionReturn)
                NSApp.activate(ignoringOtherApps: true)
            } else {
                // Cancel button clicked
                self.stopTimer()
            }
        }
    }
    
    // MARK: - Typing Monitoring
    
    private func startTypingMonitoring() {
        typingTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.checkTypingActivity()
        }
    }
    
    private func checkTypingActivity() {
        guard isTimerRunning else { return }
        
        let timeSinceLastTyping = Date().timeIntervalSince(lastTypingTime)
        if timeSinceLastTyping >= 15.0 {
            handleTypingPause()
        }
    }
    
    func updateLastTypingTime() {
        lastTypingTime = Date()
    }
    
    func handleTypingPause() {
        guard isTimerRunning else { return }
        
        logEvent(.typingPause, remainingTime: remainingTime)
        showTypingPauseAlert()
    }
    
    private func showTypingPauseAlert() {
        let alert = NSAlert()
        alert.messageText = "You stopped typing"
        alert.informativeText = "What's happening?"
        alert.addButton(withTitle: "I am thinking")
        alert.addButton(withTitle: "I was distracted")
        alert.alertStyle = .informational
        
        DispatchQueue.main.async {
            let response = alert.runModal()
            if response == .alertFirstButtonReturn {
                // "I am thinking" - continue session
                self.lastTypingTime = Date()
            } else {
                // "I was distracted" - show distraction dialog
                self.showDistractionDialog()
            }
        }
    }
    
    private func showDistractionDialog() {
        let alert = NSAlert()
        alert.messageText = "Distraction Noted"
        alert.informativeText = "What were you distracted by? (Optional)"
        
        let textField = NSTextField(frame: NSRect(x: 0, y: 0, width: 300, height: 24))
        textField.placeholderString = "Enter distraction reason..."
        alert.accessoryView = textField
        
        alert.addButton(withTitle: "Return to the note")
        alert.addButton(withTitle: "End the session")
        alert.alertStyle = .informational
        
        DispatchQueue.main.async {
            let response = alert.runModal()
            let reason = textField.stringValue.isEmpty ? nil : textField.stringValue
            
            if response == .alertFirstButtonReturn {
                // "Return to the note"
                self.logDistraction(reason: reason)
                self.lastTypingTime = Date()
            } else {
                // "End the session"
                self.logDistraction(reason: reason)
                self.logSessionEnd()
                self.stopTimer()
            }
        }
    }
    
    // MARK: - Event Logging
    
    func logDistraction(reason: String?) {
        logEvent(.distraction, distractionReason: reason, remainingTime: remainingTime)
    }
    
    func logSessionEnd() {
        guard let startTime = currentSessionStartTime else { return }
        let sessionDuration = Date().timeIntervalSince(startTime)
        logEvent(.sessionEnd, sessionDuration: sessionDuration)
        updateStats()
    }
    
    private func logEvent(_ eventType: FocusEventType, sessionDuration: TimeInterval? = nil, distractionReason: String? = nil, remainingTime: TimeInterval? = nil) {
        let logEntry = FocusLogEntry(
            timestamp: Date(),
            eventType: eventType,
            sessionDuration: sessionDuration,
            distractionReason: distractionReason,
            remainingTime: remainingTime
        )
        
        focusLogs.append(logEntry)
        saveFocusLogs()
    }
    
    // MARK: - Statistics
    
    func calculateStats() -> FocusStats {
        var totalFocusTime: TimeInterval = 0
        var totalSessions = 0
        var distractionsAvoided = 0
        var totalDistractions = 0
        
        for log in focusLogs {
            switch log.eventType {
            case .sessionEnd:
                if let duration = log.sessionDuration {
                    totalFocusTime += duration
                    totalSessions += 1
                }
            case .sessionReturn:
                distractionsAvoided += 1
            case .distraction:
                totalDistractions += 1
            default:
                break
            }
        }
        
        let averageSessionLength = totalSessions > 0 ? totalFocusTime / Double(totalSessions) : 0
        
        return FocusStats(
            totalFocusTime: totalFocusTime,
            totalSessions: totalSessions,
            totalDistractions: totalDistractions,
            distractionsAvoided: distractionsAvoided,
            averageSessionLength: averageSessionLength,
            lastUpdated: Date()
        )
    }
    
    private func updateStats() {
        focusStats = calculateStats()
        saveFocusStats()
    }
    
    // MARK: - Public Access Methods
    
    func getAllLogs() -> [FocusLogEntry] {
        return focusLogs
    }
    
    // MARK: - Computed Properties
    
    var formattedRemainingTime: String {
        let minutes = Int(remainingTime) / 60
        let seconds = Int(remainingTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var formattedSelectedDuration: String {
        let minutes = Int(selectedDuration) / 60
        return "\(minutes) min"
    }
    
    var formattedTotalFocusTime: String {
        let hours = focusStats.totalFocusTime / 3600
        return String(format: "%.1f", hours)
    }
    
    // MARK: - Persistence
    
    private func saveFocusLogs() {
        do {
            let data = try JSONEncoder().encode(focusLogs)
            let url = getDocumentsDirectory().appendingPathComponent("focus-logs.json")
            try data.write(to: url)
        } catch {
            print("Failed to save focus logs: \(error)")
            // Try backup location
            saveFocusLogsBackup()
        }
    }
    
    private func saveFocusLogsBackup() {
        do {
            let data = try JSONEncoder().encode(focusLogs)
            let backupURL = getDocumentsDirectory().appendingPathComponent("focus-logs-backup.json")
            try data.write(to: backupURL)
            print("Focus logs saved to backup location")
        } catch {
            print("Failed to save focus logs backup: \(error)")
            // Log corruption - truncate to last 100 entries to prevent file size issues
            if focusLogs.count > 100 {
                focusLogs = Array(focusLogs.suffix(100))
                saveFocusLogs() // Try again with smaller dataset
            }
        }
    }
    
    private func saveFocusStats() {
        do {
            let data = try JSONEncoder().encode(focusStats)
            let url = getDocumentsDirectory().appendingPathComponent("focus-stats.json")
            try data.write(to: url)
        } catch {
            print("Failed to save focus stats: \(error)")
            // Try backup location
            saveFocusStatsBackup()
        }
    }
    
    private func saveFocusStatsBackup() {
        do {
            let data = try JSONEncoder().encode(focusStats)
            let backupURL = getDocumentsDirectory().appendingPathComponent("focus-stats-backup.json")
            try data.write(to: backupURL)
            print("Focus stats saved to backup location")
        } catch {
            print("Failed to save focus stats backup: \(error)")
            // Reset stats if corruption is severe
            focusStats = FocusStats()
        }
    }
    
    private func loadFocusData() {
        loadFocusLogs()
        loadFocusStats()
    }
    
    private func loadFocusLogs() {
        do {
            let url = getDocumentsDirectory().appendingPathComponent("focus-logs.json")
            let data = try Data(contentsOf: url)
            focusLogs = try JSONDecoder().decode([FocusLogEntry].self, from: data)
        } catch {
            print("Failed to load focus logs: \(error)")
            // Try backup
            if loadFocusLogsBackup() {
                return
            }
            // Default to empty
            focusLogs = []
        }
    }
    
    private func loadFocusLogsBackup() -> Bool {
        do {
            let backupURL = getDocumentsDirectory().appendingPathComponent("focus-logs-backup.json")
            let data = try Data(contentsOf: backupURL)
            focusLogs = try JSONDecoder().decode([FocusLogEntry].self, from: data)
            print("Focus logs loaded from backup")
            // Try to restore main file
            saveFocusLogs()
            return true
        } catch {
            return false
        }
    }
    
    private func loadFocusStats() {
        do {
            let url = getDocumentsDirectory().appendingPathComponent("focus-stats.json")
            let data = try Data(contentsOf: url)
            focusStats = try JSONDecoder().decode(FocusStats.self, from: data)
        } catch {
            print("Failed to load focus stats: \(error)")
            // Try backup
            if loadFocusStatsBackup() {
                return
            }
            // Default to empty stats
            focusStats = FocusStats()
        }
    }
    
    private func loadFocusStatsBackup() -> Bool {
        do {
            let backupURL = getDocumentsDirectory().appendingPathComponent("focus-stats-backup.json")
            let data = try Data(contentsOf: backupURL)
            focusStats = try JSONDecoder().decode(FocusStats.self, from: data)
            print("Focus stats loaded from backup")
            // Try to restore main file
            saveFocusStats()
            return true
        } catch {
            return false
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0].appendingPathComponent("NotesApp")
        
        // Create directory if it doesn't exist
        try? FileManager.default.createDirectory(at: documentsDirectory, withIntermediateDirectories: true)
        
        return documentsDirectory
    }
    
    // MARK: - Notifications
    
    private func showSessionCompleteNotification() {
        let alert = NSAlert()
        alert.messageText = "Focus Session Complete!"
        alert.informativeText = "Great job! You completed a \(formattedSelectedDuration) focus session."
        alert.addButton(withTitle: "OK")
        alert.alertStyle = .informational
        
        DispatchQueue.main.async {
            alert.runModal()
        }
    }
}

// MARK: - Data Models

struct FocusLogEntry: Identifiable, Codable {
    let id: UUID
    let timestamp: Date
    let eventType: FocusEventType
    let sessionDuration: TimeInterval?
    let distractionReason: String?
    let remainingTime: TimeInterval?
    
    init(timestamp: Date, eventType: FocusEventType, sessionDuration: TimeInterval? = nil, distractionReason: String? = nil, remainingTime: TimeInterval? = nil) {
        self.id = UUID()
        self.timestamp = timestamp
        self.eventType = eventType
        self.sessionDuration = sessionDuration
        self.distractionReason = distractionReason
        self.remainingTime = remainingTime
    }
}

enum FocusEventType: String, Codable, CaseIterable {
    case sessionStart = "session_start"
    case sessionEnd = "session_end"
    case focusLoss = "focus_loss"
    case typingPause = "typing_pause"
    case distraction = "distraction"
    case sessionReturn = "session_return"
}

struct FocusStats: Codable {
    var totalFocusTime: TimeInterval = 0
    var totalSessions: Int = 0
    var totalDistractions: Int = 0
    var distractionsAvoided: Int = 0
    var averageSessionLength: TimeInterval = 0
    var lastUpdated: Date = Date()
}