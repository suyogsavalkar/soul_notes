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
    @Published var distractionStats: DistractionStats = DistractionStats()
    
    private var timer: Timer?
    private var focusLogs: [FocusLogEntry] = []
    private var distractionLogs: [DistractionLogEntry] = []
    private var sessionStartTime: Date?
    private var lastTypingTime: Date = Date()
    private var typingTimer: Timer?
    private var isAppInFocus: Bool = true
    
    private let availableDurations: [TimeInterval] = [300, 600] // 5 and 10 minutes
    
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
        sessionStartTime = Date()
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
        sessionStartTime = nil
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
        
        DispatchQueue.main.async {
            let alert = NSAlert()
            alert.messageText = "Focus Session Active"
            alert.informativeText = "You still have \(timeString) minutes left to focus on yourself"
            alert.addButton(withTitle: "Return")
            alert.addButton(withTitle: "Cancel")
            alert.alertStyle = .informational
            
            // Show alert on the current active window instead of app window
            if let currentWindow = NSApp.keyWindow ?? NSApp.mainWindow {
                alert.beginSheetModal(for: currentWindow) { response in
                    if response == .alertFirstButtonReturn {
                        // Return button clicked - record as distraction avoided with tab change reason
                        self.logDistractionAvoided(type: .tabChange, reason: "Switched away from app")
                        NSApp.activate(ignoringOtherApps: true)
                    } else {
                        // Cancel button clicked - record as actual distraction
                        let distractionEntry = DistractionLogEntry(
                            timestamp: Date(),
                            distractionType: .tabChange,
                            reason: "Switched away from app",
                            wasAvoided: false
                        )
                        self.distractionLogs.append(distractionEntry)
                        self.saveDistractionData()
                        self.stopTimer()
                    }
                }
            } else {
                // Fallback to modal if no window is available
                let response = alert.runModal()
                if response == .alertFirstButtonReturn {
                    self.logDistractionAvoided(type: .tabChange, reason: "Switched away from app")
                    NSApp.activate(ignoringOtherApps: true)
                } else {
                    // Cancel button clicked - record as actual distraction
                    let distractionEntry = DistractionLogEntry(
                        timestamp: Date(),
                        distractionType: .tabChange,
                        reason: "Switched away from app",
                        wasAvoided: false
                    )
                    self.distractionLogs.append(distractionEntry)
                    self.saveDistractionData()
                    self.stopTimer()
                }
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
        if timeSinceLastTyping >= 60.0 { // Changed from 15 seconds to 1 minute
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
        // Stop typing monitoring while showing alert
        typingTimer?.invalidate()
        typingTimer = nil
        
        DispatchQueue.main.async {
            let alert = NSAlert()
            alert.messageText = "You stopped typing"
            alert.informativeText = "What's happening?"
            alert.addButton(withTitle: "I am thinking")
            alert.addButton(withTitle: "I was distracted")
            alert.alertStyle = .informational
            
            let response = alert.runModal()
            if response == .alertFirstButtonReturn {
                // "I am thinking" - continue session and restart typing monitoring
                self.lastTypingTime = Date()
                self.restartTypingMonitoring()
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
            
            // Use custom reason if provided, otherwise use a descriptive default for typing inactivity
            let reason = textField.stringValue.isEmpty ? "Stopped typing for 1 minute" : textField.stringValue
            
            if response == .alertFirstButtonReturn {
                // "Return to the note" - record as distraction avoided with custom reason
                self.logDistractionAvoided(type: .customReason, reason: reason)
                
                self.lastTypingTime = Date()
                self.restartTypingMonitoring()
            } else {
                // "End the session" - record as actual distraction with custom reason
                let distractionEntry = DistractionLogEntry(
                    timestamp: Date(),
                    distractionType: .customReason,
                    reason: reason,
                    wasAvoided: false
                )
                self.distractionLogs.append(distractionEntry)
                self.saveDistractionData()
                
                self.logSessionEnd()
                self.stopTimer()
            }
        }
    }
    
    private func restartTypingMonitoring() {
        guard isTimerRunning else { return }
        
        // Only restart typing monitoring if timer is still running
        typingTimer?.invalidate()
        typingTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.checkTypingActivity()
        }
    }
    
    // MARK: - Event Logging
    
    func logDistraction(reason: String?) {
        logEvent(.distraction, distractionReason: reason, remainingTime: remainingTime)
    }
    
    func logSessionEnd() {
        guard let startTime = sessionStartTime else { return }
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
        
        for log in focusLogs {
            switch log.eventType {
            case .sessionEnd:
                if let duration = log.sessionDuration {
                    totalFocusTime += duration
                    totalSessions += 1
                }
            default:
                break
            }
        }
        
        let averageSessionLength = totalSessions > 0 ? totalFocusTime / Double(totalSessions) : 0
        
        // Get distractions avoided count from distraction logs (single source of truth)
        let distractionsAvoided = distractionLogs.filter { $0.wasAvoided }.count
        
        return FocusStats(
            totalFocusTime: totalFocusTime,
            totalSessions: totalSessions,
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
    
    func getFocusLogs() -> [FocusLogEntry] {
        return focusLogs.sorted { $0.timestamp > $1.timestamp }
    }
    
    func getAllLogs() -> [FocusLogEntry] {
        return focusLogs
    }
    
    func getDistractionLogs() -> [DistractionLogEntry] {
        return distractionLogs.sorted { $0.timestamp > $1.timestamp }
    }
    
    // MARK: - Data Validation
    
    /// Validates and fixes any inconsistencies in the distraction counting
    func validateAndFixDistractionCounts() {
        // Recalculate all stats from source data
        updateDistractionStats()
        focusStats = calculateStats()
        
        // Save the corrected stats
        saveFocusStats()
        saveDistractionStats()
    }
    
    // MARK: - Distraction Logging
    
    func logDistractionAvoided(type: DistractionType, reason: String) {
        let entry = DistractionLogEntry(
            timestamp: Date(),
            distractionType: type,
            reason: reason,
            wasAvoided: true
        )
        distractionLogs.append(entry)
        
        // Update statistics based on actual log data (single source of truth)
        updateDistractionStats()
        saveDistractionData()
    }
    
    private func updateDistractionStats() {
        let now = Date()
        let calendar = Calendar.current
        
        // Calculate all stats from actual log data (single source of truth)
        let avoidedDistractions = distractionLogs.filter { $0.wasAvoided }
        
        // Total count
        distractionStats.totalDistractionsAvoided = avoidedDistractions.count
        
        // Calculate weekly count (last 7 days)
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: now) ?? now
        distractionStats.weeklyDistractionsAvoided = avoidedDistractions.filter { 
            $0.timestamp >= weekAgo
        }.count
        
        // Calculate monthly count (last 30 days)
        let monthAgo = calendar.date(byAdding: .day, value: -30, to: now) ?? now
        distractionStats.monthlyDistractionsAvoided = avoidedDistractions.filter { 
            $0.timestamp >= monthAgo
        }.count
        
        distractionStats.lastUpdated = now
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
        }
    }
    
    private func saveFocusStats() {
        do {
            let data = try JSONEncoder().encode(focusStats)
            let url = getDocumentsDirectory().appendingPathComponent("focus-stats.json")
            try data.write(to: url)
        } catch {
            print("Failed to save focus stats: \(error)")
        }
    }
    
    private func loadFocusData() {
        loadFocusLogs()
        loadFocusStats()
        loadDistractionData()
        
        // Recalculate stats to ensure consistency after loading
        updateDistractionStats()
        focusStats = calculateStats()
    }
    
    private func saveDistractionData() {
        saveDistractionLogs()
        saveDistractionStats()
    }
    
    private func saveDistractionLogs() {
        do {
            let data = try JSONEncoder().encode(distractionLogs)
            let url = getDocumentsDirectory().appendingPathComponent("distraction-logs.json")
            try data.write(to: url)
        } catch {
            print("Failed to save distraction logs: \(error)")
        }
    }
    
    private func saveDistractionStats() {
        do {
            let data = try JSONEncoder().encode(distractionStats)
            let url = getDocumentsDirectory().appendingPathComponent("distraction-stats.json")
            try data.write(to: url)
        } catch {
            print("Failed to save distraction stats: \(error)")
        }
    }
    
    private func loadDistractionData() {
        loadDistractionLogs()
        loadDistractionStats()
    }
    
    private func loadDistractionLogs() {
        do {
            let url = getDocumentsDirectory().appendingPathComponent("distraction-logs.json")
            let data = try Data(contentsOf: url)
            distractionLogs = try JSONDecoder().decode([DistractionLogEntry].self, from: data)
        } catch {
            print("Failed to load distraction logs: \(error)")
            distractionLogs = []
        }
    }
    
    private func loadDistractionStats() {
        do {
            let url = getDocumentsDirectory().appendingPathComponent("distraction-stats.json")
            let data = try Data(contentsOf: url)
            distractionStats = try JSONDecoder().decode(DistractionStats.self, from: data)
        } catch {
            print("Failed to load distraction stats: \(error)")
            distractionStats = DistractionStats()
        }
    }
    
    private func loadFocusLogs() {
        do {
            let url = getDocumentsDirectory().appendingPathComponent("focus-logs.json")
            let data = try Data(contentsOf: url)
            focusLogs = try JSONDecoder().decode([FocusLogEntry].self, from: data)
        } catch {
            print("Failed to load focus logs: \(error)")
            focusLogs = []
        }
    }
    
    private func loadFocusStats() {
        do {
            let url = getDocumentsDirectory().appendingPathComponent("focus-stats.json")
            let data = try Data(contentsOf: url)
            focusStats = try JSONDecoder().decode(FocusStats.self, from: data)
        } catch {
            print("Failed to load focus stats: \(error)")
            focusStats = FocusStats()
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0].appendingPathComponent("Soul")
        
        // Create directory if it doesn't exist
        try? FileManager.default.createDirectory(at: documentsDirectory, withIntermediateDirectories: true)
        
        return documentsDirectory
    }
    
    // MARK: - Notifications
    
    private func showSessionCompleteNotification() {
        DispatchQueue.main.async {
            let alert = NSAlert()
            alert.messageText = "Focus Session Complete!"
            alert.informativeText = "Great job! You completed a \(self.formattedSelectedDuration) focus session."
            alert.addButton(withTitle: "OK")
            alert.alertStyle = .informational
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
    
    var displayName: String {
        switch self {
        case .sessionStart:
            return "Session Started"
        case .sessionEnd:
            return "Session Ended"
        case .focusLoss:
            return "Focus Lost"
        case .typingPause:
            return "Typing Paused"
        case .distraction:
            return "Distraction"
        case .sessionReturn:
            return "Returned to Session"
        }
    }
}

struct FocusStats: Codable {
    var totalFocusTime: TimeInterval = 0
    var totalSessions: Int = 0
    var distractionsAvoided: Int = 0
    var averageSessionLength: TimeInterval = 0
    var lastUpdated: Date = Date()
    
    var formattedFocusTime: String {
        let hours = Int(totalFocusTime) / 3600
        let minutes = (Int(totalFocusTime) % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}