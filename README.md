# Soul

A clean, distraction-free note-taking application for macOS built with SwiftUI. Soul focuses on providing a minimal interface that promotes productivity and deep focus while writing.

## Features

### 📝 Clean Editor Interface
- Distraction-free note editing with a minimal, elegant design
- Hidden title bar for maximum screen real estate
- Focus management to help you stay in the writing flow
- Real-time word count for both titles and body content

### 🗂️ Category Organization
- Organize notes into customizable categories
- Choose from SF Symbol icons for visual category identification
- Default categories include Personal, Work, Ideas, and Projects
- Easy category creation and management

### ⏱️ Focus Timer System
- Built-in focus timer to track writing sessions
- Productivity statistics and focus session history
- Visual focus log to monitor your writing habits
- Achievement system to celebrate productivity milestones

### 🤖 AI Reflection
- Reflect on your notes with AI assistance
- Minimum 150-word requirement for meaningful reflections
- Integrated seamlessly into the note editing experience

### 🎨 Theme Support
- Beautiful light and dark mode themes
- Custom color schemes optimized for readability
- Automatic theme switching based on system preferences
- Custom DM Sans typography throughout the interface

### 💾 Auto-save & Reliability
- Automatic saving with visual indicators for unsaved changes
- Reliable data persistence using JSON encoding
- Local file system storage for privacy and control

## Requirements

- **macOS 13.0+**
- **Xcode 14.0+** (for building from source)
- **Swift 5.9+**

## Installation

### Clone the Repository

```bash
git clone <repository-url>
cd soul
```

### Build with Xcode

1. **Open the project in Xcode:**
   ```bash
   open note.xcodeproj
   ```

2. **Build and run from Xcode:**
   - Select the `note` scheme
   - Choose your target device (Mac)
   - Press `Cmd + R` to build and run

### Build from Command Line

```bash
# Build the project
xcodebuild -project note.xcodeproj -scheme note -configuration Release build

# Build and run
xcodebuild -project note.xcodeproj -scheme note -configuration Release -destination 'platform=macOS' run
```

### Alternative: Swift Package Manager

```bash
# Build using Swift Package Manager
swift build

# Run the executable
swift run
```

## Development

### Project Structure

- `note/` - Main application source code
- `note/Models/` - Data models (Note, Category)
- `note/Views/` - SwiftUI views and components
- `note/Services/` - Business logic and state management
- `note/Resources/` - Fonts and static assets
- `noteTests/` - Unit tests
- `noteUITests/` - UI automation tests

### Running Tests

```bash
# Run all tests
swift test

# Run tests in Xcode
xcodebuild test -project note.xcodeproj -scheme note -destination 'platform=macOS'
```

### Key Technologies

- **SwiftUI** - Modern declarative UI framework
- **Combine** - Reactive programming for state management
- **Swift Package Manager** - Dependency management and build system
- **Custom Typography** - DM Sans font family
- **SF Symbols** - Apple's icon system

## Usage

1. **Launch Soul** and you'll see the welcome screen on first run
2. **Create categories** to organize your notes using the sidebar
3. **Start writing** by creating a new note in any category
4. **Use the focus timer** to track your writing sessions
5. **Reflect on your notes** using the AI reflection feature
6. **Switch themes** between light and dark mode as needed

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Architecture

Soul follows the MVVM (Model-View-ViewModel) pattern with:
- **Models** - Data structures (Note, Category)
- **Views** - SwiftUI components
- **Services** - Business logic managers (NoteManager, ThemeManager, etc.)
- **Environment Objects** - Shared state management

## License

[Add your license information here]

## Support

[Add support information or contact details here]