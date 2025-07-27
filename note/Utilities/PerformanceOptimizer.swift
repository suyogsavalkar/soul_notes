//
//  PerformanceOptimizer.swift
//  note
//
//  Created by Kiro on 26/07/25.
//

import Foundation
import SwiftUI

/// Performance optimization utilities for the notes app
class PerformanceOptimizer {
    
    /// Debounce utility for reducing frequent operations
    class Debouncer {
        private let delay: TimeInterval
        private var workItem: DispatchWorkItem?
        
        init(delay: TimeInterval) {
            self.delay = delay
        }
        
        func debounce(action: @escaping () -> Void) {
            workItem?.cancel()
            workItem = DispatchWorkItem(block: action)
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: workItem!)
        }
        
        func cancel() {
            workItem?.cancel()
        }
    }
    
    /// Memory-efficient text truncation
    static func efficientTruncate(_ text: String, maxLength: Int = 100) -> String {
        guard text.count > maxLength else { return text }
        
        let truncated = String(text.prefix(maxLength))
        
        // Find last space to avoid cutting words
        if let lastSpaceIndex = truncated.lastIndex(of: " ") {
            return String(truncated[..<lastSpaceIndex]) + "..."
        }
        
        return truncated + "..."
    }
    
    /// Lazy loading helper for large collections
    static func shouldLoadMore<T>(items: [T], currentIndex: Int, threshold: Int = 10) -> Bool {
        return currentIndex >= items.count - threshold
    }
    
    /// Memory usage monitoring
    static func getCurrentMemoryUsage() -> UInt64 {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
        
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_,
                         task_flavor_t(MACH_TASK_BASIC_INFO),
                         $0,
                         &count)
            }
        }
        
        if kerr == KERN_SUCCESS {
            return info.resident_size
        }
        
        return 0
    }
}