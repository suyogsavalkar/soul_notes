//
//  FocusSystemEnhancementTests.swift
//  noteTests
//
//  Created by Kiro on 29/07/25.
//

import XCTest
import SwiftUI
@testable import note

final class FocusSessionTests: XCTestCase {
    
    func testFocusSessionCreation() {
        // Test that focus sessions are created with correct data
        let testDate = Date()
        let testDuration: TimeInterval = 600 // 10 minutes
        
        let session = FocusSession(date: testDate, duration: testDuration)
        
        XCTAssertNotNil(session.id)
        XCTAssertEqual(session.date, testDate)
        XCTAssertEqual(session.duration, testDuration)
        XCTAssertEqual(session.performanceRating, .perfect) // 10 minutes = perfect
    }
    
    func testPerformanceRatingCalculation() {
        // Test performance rating calculation for different durations
        
        // Test fair rating (< 5 minutes)
        let shortSession = FocusSession(date: Date(), duration: 240) // 4 minutes
        XCTAssertEqual(shortSession.performanceRating, .fair)
        
        // Test good rating (5-9 minutes)
        let mediumSession = FocusSession(date: Date(), duration: 480) // 8 minutes
        XCTAssertEqual(mediumSession.performanceRating, .good)
        
        // Test perfect rating (10+ minutes)
        let longSession = FocusSession(date: Date(), duration: 720) // 12 minutes
        XCTAssertEqual(longSession.performanceRating, .perfect)
        
        // Test edge cases
        let exactlyFiveMinutes = FocusSession(date: Date(), duration: 300) // 5 minutes
        XCTAssertEqual(exactlyFiveMinutes.performanceRating, .good)
        
        let exactlyTenMinutes = FocusSession(date: Date(), duration: 600) // 10 minutes
        XCTAssertEqual(exactlyTenMinutes.performanceRating, .perfect)
    }
    
    func testPerformanceRatingStaticMethod() {
        // Test the static rating method directly
        XCTAssertEqual(FocusPerformanceRating.rating(for: 240), .fair) // 4 minutes
        XCTAssertEqual(FocusPerformanceRating.rating(for: 300), .good) // 5 minutes
        XCTAssertEqual(FocusPerformanceRating.rating(for: 480), .good) // 8 minutes
        XCTAssertEqual(FocusPerformanceRating.rating(for: 600), .perfect) // 10 minutes
        XCTAssertEqual(FocusPerformanceRating.rating(for: 900), .perfect) // 15 minutes
    }
    
    func testPerformanceRatingColors() {
        // Test that performance ratings have correct colors
        XCTAssertEqual(FocusPerformanceRating.fair.color, "orange")
        XCTAssertEqual(FocusPerformanceRating.good.color, "blue")
        XCTAssertEqual(FocusPerformanceRating.perfect.color, "green")
    }
}

final class FocusTimeRangeStatsTests: XCTestCase {
    
    func testFocusTimeRangeStatsInitialization() {
        // Test that FocusTimeRangeStats initializes correctly
        let stats = FocusTimeRangeStats()
        
        XCTAssertEqual(stats.todayFocusTime, 0)
        XCTAssertEqual(stats.lastWeekFocusTime, 0)
        XCTAssertEqual(stats.totalFocusTime, 0)
        XCTAssertTrue(stats.todaySessions.isEmpty)
        XCTAssertTrue(stats.lastWeekSessions.isEmpty)
        XCTAssertTrue(stats.allSessions.isEmpty)
        XCTAssertNotNil(stats.lastUpdated)
    }
    
    func testTimeRangeCalculations() {
        // Test time range calculations
        var stats = FocusTimeRangeStats()
        
        // Add some test data
        stats.todayFocusTime = 1800 // 30 minutes
        stats.lastWeekFocusTime = 7200 // 2 hours
        stats.totalFocusTime = 18000 // 5 hours
        
        // Test formatted strings
        XCTAssertEqual(stats.formattedTodayFocusTime, "30 minutes")
        XCTAssertEqual(stats.formattedLastWeekFocusTime, "120 minutes")
        XCTAssertEqual(stats.formattedTotalFocusTime, "5h 0m")
        
        // Test with different values
        stats.totalFocusTime = 3900 // 1 hour 5 minutes
        XCTAssertEqual(stats.formattedTotalFocusTime, "1h 5m")
        
        stats.totalFocusTime = 300 // 5 minutes
        XCTAssertEqual(stats.formattedTotalFocusTime, "5m")
    }
    
    func testSessionCategorization() {
        // Test that sessions are properly categorized by time range
        let now = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: now)!
        let lastWeek = Calendar.current.date(byAdding: .day, value: -8, to: now)!
        
        let todaySession = FocusSession(date: now, duration: 600)
        let yesterdaySession = FocusSession(date: yesterday, duration: 480)
        let oldSession = FocusSession(date: lastWeek, duration: 300)
        
        var stats = FocusTimeRangeStats()
        stats.todaySessions = [todaySession]
        stats.lastWeekSessions = [todaySession, yesterdaySession]
        stats.allSessions = [todaySession, yesterdaySession, oldSession]
        
        XCTAssertEqual(stats.todaySessions.count, 1)
        XCTAssertEqual(stats.lastWeekSessions.count, 2)
        XCTAssertEqual(stats.allSessions.count, 3)
    }
}

final class FocusTimerManagerEnhancementTests: XCTestCase {
    
    var focusTimerManager: FocusTimerManager!
    
    override func setUp() {
        super.setUp()
        focusTimerManager = FocusTimerManager()
    }
    
    override func tearDown() {
        focusTimerManager = nil
        super.tearDown()
    }
    
    func testFocusSessionRecording() {
        // Test that focus sessions are recorded when timer completes
        let initialSessionCount = focusTimerManager.focusTimeRangeStats.allSessions.count
        
        // Start and immediately complete a timer session
        focusTimerManager.startTimer(duration: 600) // 10 minutes
        focusTimerManager.stopTimer()
        
        // Verify session was recorded
        XCTAssertEqual(focusTimerManager.focusTimeRangeStats.allSessions.count, initialSessionCount + 1)
        
        let lastSession = focusTimerManager.focusTimeRangeStats.allSessions.last
        XCTAssertNotNil(lastSession)
        XCTAssertEqual(lastSession?.duration, 600)
        XCTAssertEqual(lastSession?.performanceRating, .perfect)
    }
    
    func testFocusStatsCalculation() {
        // Test that focus statistics are calculated correctly
        let initialStats = focusTimerManager.calculateStats()
        let initialTotalTime = initialStats.totalFocusTime
        let initialSessionCount = initialStats.totalSessions
        
        // Simulate a completed session
        focusTimerManager.startTimer(duration: 300) // 5 minutes
        focusTimerManager.stopTimer()
        
        let updatedStats = focusTimerManager.calculateStats()
        
        // Verify stats were updated
        XCTAssertEqual(updatedStats.totalSessions, initialSessionCount + 1)
        XCTAssertEqual(updatedStats.totalFocusTime, initialTotalTime + 300)
    }
    
    func testTimeRangeStatsUpdate() {
        // Test that time range stats are updated correctly
        let initialTotalTime = focusTimerManager.focusTimeRangeStats.totalFocusTime
        let initialTodayTime = focusTimerManager.focusTimeRangeStats.todayFocusTime
        
        // Complete a session
        focusTimerManager.startTimer(duration: 480) // 8 minutes
        focusTimerManager.stopTimer()
        
        // Verify time range stats were updated
        XCTAssertEqual(focusTimerManager.focusTimeRangeStats.totalFocusTime, initialTotalTime + 480)
        XCTAssertEqual(focusTimerManager.focusTimeRangeStats.todayFocusTime, initialTodayTime + 480)
        
        // Verify session was added to appropriate collections
        XCTAssertTrue(focusTimerManager.focusTimeRangeStats.allSessions.contains { $0.duration == 480 })
        XCTAssertTrue(focusTimerManager.focusTimeRangeStats.todaySessions.contains { $0.duration == 480 })
    }
    
    func testFormattedFocusTime() {
        // Test formatted focus time display
        focusTimerManager.focusStats.totalFocusTime = 3600 // 1 hour
        XCTAssertEqual(focusTimerManager.formattedTotalFocusTime, "1.0")
        
        focusTimerManager.focusStats.totalFocusTime = 7200 // 2 hours
        XCTAssertEqual(focusTimerManager.formattedTotalFocusTime, "2.0")
        
        focusTimerManager.focusStats.totalFocusTime = 5400 // 1.5 hours
        XCTAssertEqual(focusTimerManager.formattedTotalFocusTime, "1.5")
    }
    
    func testSessionEndLogging() {
        // Test that session end is properly logged
        let initialLogCount = focusTimerManager.getAllLogs().count
        
        focusTimerManager.startTimer(duration: 600)
        focusTimerManager.logSessionEnd()
        
        let updatedLogCount = focusTimerManager.getAllLogs().count
        XCTAssertEqual(updatedLogCount, initialLogCount + 2) // sessionStart + sessionEnd
        
        let logs = focusTimerManager.getAllLogs()
        let sessionEndLog = logs.last { $0.eventType == .sessionEnd }
        XCTAssertNotNil(sessionEndLog)
        XCTAssertNotNil(sessionEndLog?.sessionDuration)
    }
}

final class FocusLogDisplayTests: XCTestCase {
    
    func testFocusTimeRangeFormatting() {
        // Test that focus time ranges are formatted correctly
        let timeRange = FocusTimeRange.today
        XCTAssertEqual(timeRange.rawValue, "Focused time today")
        
        let lastWeekRange = FocusTimeRange.lastWeek
        XCTAssertEqual(lastWeekRange.rawValue, "Focused time last week")
        
        let totalRange = FocusTimeRange.total
        XCTAssertEqual(totalRange.rawValue, "Total focused time")
    }
    
    func testLogViewTabEnum() {
        // Test that log view tabs are defined correctly
        let distractionsTab = LogViewTab.distractions
        XCTAssertEqual(distractionsTab.rawValue, "Distractions")
        
        let focusTab = LogViewTab.focus
        XCTAssertEqual(focusTab.rawValue, "Focus")
        
        // Test that all cases are available
        let allCases = LogViewTab.allCases
        XCTAssertEqual(allCases.count, 2)
        XCTAssertTrue(allCases.contains(.distractions))
        XCTAssertTrue(allCases.contains(.focus))
    }
    
    func testSessionSorting() {
        // Test that sessions are sorted correctly (most recent first)
        let now = Date()
        let earlier = now.addingTimeInterval(-3600) // 1 hour ago
        let earliest = now.addingTimeInterval(-7200) // 2 hours ago
        
        let session1 = FocusSession(date: earliest, duration: 300)
        let session2 = FocusSession(date: now, duration: 600)
        let session3 = FocusSession(date: earlier, duration: 480)
        
        let sessions = [session1, session2, session3]
        let sortedSessions = sessions.sorted { $0.date > $1.date }
        
        XCTAssertEqual(sortedSessions[0].date, now)
        XCTAssertEqual(sortedSessions[1].date, earlier)
        XCTAssertEqual(sortedSessions[2].date, earliest)
    }
}

final class FocusDataPersistenceTests: XCTestCase {
    
    func testFocusSessionCodable() {
        // Test that FocusSession can be encoded and decoded
        let originalSession = FocusSession(date: Date(), duration: 600)
        
        do {
            let encodedData = try JSONEncoder().encode(originalSession)
            let decodedSession = try JSONDecoder().decode(FocusSession.self, from: encodedData)
            
            XCTAssertEqual(decodedSession.id, originalSession.id)
            XCTAssertEqual(decodedSession.date.timeIntervalSince1970, originalSession.date.timeIntervalSince1970, accuracy: 1.0)
            XCTAssertEqual(decodedSession.duration, originalSession.duration)
            XCTAssertEqual(decodedSession.performanceRating, originalSession.performanceRating)
        } catch {
            XCTFail("Failed to encode/decode FocusSession: \(error)")
        }
    }
    
    func testFocusTimeRangeStatsCodable() {
        // Test that FocusTimeRangeStats can be encoded and decoded
        var originalStats = FocusTimeRangeStats()
        originalStats.todayFocusTime = 1800
        originalStats.lastWeekFocusTime = 7200
        originalStats.totalFocusTime = 18000
        originalStats.todaySessions = [FocusSession(date: Date(), duration: 600)]
        
        do {
            let encodedData = try JSONEncoder().encode(originalStats)
            let decodedStats = try JSONDecoder().decode(FocusTimeRangeStats.self, from: encodedData)
            
            XCTAssertEqual(decodedStats.todayFocusTime, originalStats.todayFocusTime)
            XCTAssertEqual(decodedStats.lastWeekFocusTime, originalStats.lastWeekFocusTime)
            XCTAssertEqual(decodedStats.totalFocusTime, originalStats.totalFocusTime)
            XCTAssertEqual(decodedStats.todaySessions.count, originalStats.todaySessions.count)
        } catch {
            XCTFail("Failed to encode/decode FocusTimeRangeStats: \(error)")
        }
    }
    
    func testPerformanceRatingCodable() {
        // Test that FocusPerformanceRating can be encoded and decoded
        let ratings: [FocusPerformanceRating] = [.fair, .good, .perfect]
        
        for rating in ratings {
            do {
                let encodedData = try JSONEncoder().encode(rating)
                let decodedRating = try JSONDecoder().decode(FocusPerformanceRating.self, from: encodedData)
                
                XCTAssertEqual(decodedRating, rating)
                XCTAssertEqual(decodedRating.rawValue, rating.rawValue)
            } catch {
                XCTFail("Failed to encode/decode FocusPerformanceRating \(rating): \(error)")
            }
        }
    }
}