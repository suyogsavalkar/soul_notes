//
//  NaturalTextEditor.swift
//  note
//
//  Created by Kiro on 28/07/25.
//

import SwiftUI
import AppKit

struct NaturalTextEditor: NSViewRepresentable {
    @Binding var text: String
    let fontSize: CGFloat
    let textColor: Color
    let minHeight: CGFloat
    let onTextChange: (String, String) -> Void
    
    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSScrollView()
        let textView = NSTextView()
        
        // Configure scroll view
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.autohidesScrollers = true
        scrollView.borderType = .noBorder
        scrollView.documentView = textView
        
        // Configure text view
        textView.isEditable = true
        textView.isSelectable = true
        textView.isRichText = false
        textView.allowsUndo = true
        textView.usesFontPanel = false
        textView.usesRuler = false
        textView.isAutomaticQuoteSubstitutionEnabled = false
        textView.isAutomaticDashSubstitutionEnabled = false
        textView.isAutomaticTextReplacementEnabled = false
        textView.isAutomaticSpellingCorrectionEnabled = false
        textView.isContinuousSpellCheckingEnabled = false
        textView.isGrammarCheckingEnabled = false
        textView.isAutomaticLinkDetectionEnabled = false
        textView.isAutomaticDataDetectionEnabled = false
        
        // Set up text container
        textView.textContainer?.containerSize = NSSize(width: 0, height: CGFloat.greatestFiniteMagnitude)
        textView.textContainer?.widthTracksTextView = true
        textView.textContainer?.heightTracksTextView = false
        textView.maxSize = NSSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        textView.isVerticallyResizable = true
        textView.isHorizontallyResizable = false
        
        // Set delegate
        textView.delegate = context.coordinator
        
        // Apply initial styling
        updateTextView(textView, context: context)
        
        return scrollView
    }
    
    func updateNSView(_ nsView: NSScrollView, context: Context) {
        guard let textView = nsView.documentView as? NSTextView else { return }
        
        // Update text if it changed externally (but preserve cursor position)
        if textView.string != text {
            let selectedRange = textView.selectedRange()
            textView.string = text
            
            // Restore cursor position if it's still valid
            let newLength = textView.string.count
            if selectedRange.location <= newLength {
                let newRange = NSRange(location: min(selectedRange.location, newLength), length: 0)
                textView.setSelectedRange(newRange)
            }
        }
        
        // Update styling
        updateTextView(textView, context: context)
        
        // Update minimum height
        let clipView = nsView.contentView
        let currentHeight = clipView.frame.height
        if currentHeight < minHeight {
            nsView.frame.size.height = minHeight
        }
    }
    
    private func updateTextView(_ textView: NSTextView, context: Context) {
        // Use DM Sans Regular font with the provided size
        let nsFont = NSFont(name: "DMSans-Regular", size: fontSize) ?? NSFont.systemFont(ofSize: fontSize)
        textView.font = nsFont
        
        // Set text color - use system colors for simplicity
        textView.textColor = NSColor.textColor
        textView.insertionPointColor = NSColor.textColor
        
        // Set background to clear
        textView.backgroundColor = NSColor.clear
        textView.drawsBackground = false
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, NSTextViewDelegate {
        let parent: NaturalTextEditor
        
        init(_ parent: NaturalTextEditor) {
            self.parent = parent
        }
        
        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }
            
            let oldText = parent.text
            let newText = textView.string
            
            // Update binding without interfering with cursor position
            DispatchQueue.main.async {
                self.parent.text = newText
                self.parent.onTextChange(oldText, newText)
            }
        }
        
        // This method is called when the user clicks in the text view
        func textViewDidChangeSelection(_ notification: Notification) {
            // Don't interfere with selection changes - let NSTextView handle cursor positioning naturally
        }
        
        // Allow all text changes
        func textView(_ textView: NSTextView, shouldChangeTextIn affectedCharRange: NSRange, replacementString: String?) -> Bool {
            return true
        }
    }
}



