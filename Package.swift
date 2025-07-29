// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Soul",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "Soul", targets: ["note"])
    ],
    targets: [
        .executableTarget(
            name: "Soul",
            path: "soul",
            sources: [
                "noteApp.swift",
                "Views/MainView.swift",
                "Services/NoteManager.swift",
                "Models/Note.swift",
                "Models/Category.swift",
                "Services/ErrorHandler.swift",
                "Services/ThemeManager.swift",
                "Services/FontSizeManager.swift",
                "Services/FocusTimerManager.swift",
                "Utilities/PerformanceOptimizer.swift",
                "Utilities/FontLoader.swift",
                "Extensions/Color+Theme.swift",
                "Extensions/Font+DMSans.swift",
                "Views/SidebarView.swift",
                "Views/NotesGridView.swift",
                "Views/NoteEditorView.swift",
                "Views/NotePreviewCard.swift",
                "Views/WelcomeView.swift",
                "Views/CategoryCreationView.swift",
                "Views/SFSymbolPicker.swift",
                "Views/FocusLogView.swift",
                "Views/FocusStatsView.swift",
                "Views/FocusTimerControl.swift"
            ]
        )
    ]
)