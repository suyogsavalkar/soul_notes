//
//  noteApp.swift
//  note
//
//  Created by Suyog Savalkar on 23/07/25.
//

import SwiftUI

@main
struct SoulApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 1200, height: 800)
    }
}
