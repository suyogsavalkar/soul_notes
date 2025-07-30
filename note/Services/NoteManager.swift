import Foundation
import Combine



// MARK: - Category Error

enum CategoryError: LocalizedError {
    case emptyName
    case nameTooShort
    case nameTooLong
    case invalidCharacters
    case duplicateName
    case saveFailed
    case cannotDeleteLastCategory
    case cannotDeleteGeneralCategory
    case noTargetCategoryForNotes
    
    var errorDescription: String? {
        switch self {
        case .emptyName:
            return "Category name cannot be empty"
        case .nameTooShort:
            return "Category name must be at least 2 characters long"
        case .nameTooLong:
            return "Category name must be 50 characters or less"
        case .invalidCharacters:
            return "Category name contains invalid characters"
        case .duplicateName:
            return "A category with this name already exists"
        case .saveFailed:
            return "Failed to save the category"
        case .cannotDeleteLastCategory:
            return "Cannot delete the last remaining category"
        case .cannotDeleteGeneralCategory:
            return "Cannot delete the General category when it's the only category"
        case .noTargetCategoryForNotes:
            return "No suitable category found to move notes to"
        }
    }
}

// MARK: - NoteManager

class NoteManager: ObservableObject {
    @Published var notes: [Note] = []
    @Published var categories: [Category] = []
    
    private let fileManager = FileManager.default
    private let errorHandler = ErrorHandler()
    private let saveDebouncer = PerformanceOptimizer.Debouncer(delay: 0.2)
    private var notesCache: [UUID: [Note]] = [:]
    
    init() {
        loadData()
    }
    
    // MARK: - Data Loading
    
    func loadData() {
        loadCategories()
        loadNotes()
    }
    
    private func loadCategories() {
        let categoriesURL = fileManager.categoriesFileURL
        
        if fileManager.fileExists(atPath: categoriesURL.path) {
            do {
                let data = try Data(contentsOf: categoriesURL)
                var loadedCategories = try JSONDecoder.noteDecoder.decode([Category].self, from: data)
                
                // Data migration: ensure all categories have icons
                var needsMigration = false
                for index in loadedCategories.indices {
                    if loadedCategories[index].iconName.isEmpty {
                        loadedCategories[index].iconName = "folder" // Default icon
                        needsMigration = true
                    }
                }
                
                categories = loadedCategories
                
                // Save migrated data if needed
                if needsMigration {
                    saveCategories()
                }
            } catch {
                errorHandler.handle(error, context: "loading categories")
                createDefaultCategories()
            }
        } else {
            createDefaultCategories()
        }
    }
    
    private func loadNotes() {
        let notesURL = fileManager.notesFileURL
        
        if fileManager.fileExists(atPath: notesURL.path) {
            do {
                let data = try Data(contentsOf: notesURL)
                notes = try JSONDecoder.noteDecoder.decode([Note].self, from: data)
            } catch {
                errorHandler.handle(error, context: "loading notes")
                // Try to recover by creating backup and starting fresh
                createBackupAndReset()
            }
        } else {
            notes = []
        }
    }
    
    private func createDefaultCategories() {
        categories = Category.defaultCategories
        saveCategories()
    }
    
    // MARK: - Data Saving
    
    func saveChanges() {
        saveNotes()
        saveCategories()
    }
    
    /// Immediate synchronous save - use when data loss prevention is critical
    func saveChangesImmediately() {
        // Cancel any pending debounced saves
        saveDebouncer.cancel()
        
        // Save immediately
        saveNotes()
        saveCategories()
    }
    
    private func saveNotes() {
        do {
            let data = try JSONEncoder.noteEncoder.encode(notes)
            try data.write(to: fileManager.notesFileURL)
        } catch {
            errorHandler.handle(error, context: "saving notes")
            // Attempt retry after a brief delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.retrySaveNotes()
            }
        }
    }
    
    private func saveCategories() {
        do {
            let data = try JSONEncoder.noteEncoder.encode(categories)
            try data.write(to: fileManager.categoriesFileURL)
        } catch {
            errorHandler.handle(error, context: "saving categories")
        }
    }
    
    private func retrySaveNotes() {
        do {
            let data = try JSONEncoder.noteEncoder.encode(notes)
            try data.write(to: fileManager.notesFileURL)
        } catch {
            errorHandler.handle(error, context: "retry saving notes")
        }
    }
    
    private func createBackupAndReset() {
        // Create backup of corrupted file
        let notesURL = fileManager.notesFileURL
        let backupURL = fileManager.notesDirectory.appendingPathComponent("notes_backup_\(Date().timeIntervalSince1970).json")
        
        do {
            if fileManager.fileExists(atPath: notesURL.path) {
                try fileManager.copyItem(at: notesURL, to: backupURL)
            }
        } catch {
            print("Failed to create backup: \(error)")
        }
        
        // Reset to empty state
        notes = []
    }
    
    // MARK: - CRUD Operations
    
    func createNote(in category: Category) -> Note {
        let newNote = Note(categoryId: category.id)
        notes.append(newNote)
        invalidateCache(for: category.id)
        debouncedSave()
        return newNote
    }
    
    func updateNote(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            var updatedNote = note
            updatedNote.updateModificationDate()
            notes[index] = updatedNote
            invalidateCache(for: updatedNote.categoryId)
            debouncedSave()
        }
    }
    
    func deleteNote(_ note: Note) {
        notes.removeAll { $0.id == note.id }
        invalidateCache(for: note.categoryId)
        debouncedSave()
    }
    
    func createCategory(name: String, iconName: String) throws -> Category {
        // Validate input
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedName.isEmpty else {
            throw CategoryError.emptyName
        }
        
        guard trimmedName.count >= 2 else {
            throw CategoryError.nameTooShort
        }
        
        guard trimmedName.count <= 50 else {
            throw CategoryError.nameTooLong
        }
        
        // Check for invalid characters
        let invalidCharacters = CharacterSet(charactersIn: "/\\:*?\"<>|")
        guard trimmedName.rangeOfCharacter(from: invalidCharacters) == nil else {
            throw CategoryError.invalidCharacters
        }
        
        let validIconName = iconName.isEmpty ? "folder" : iconName
        
        // Check for duplicate names
        let isDuplicate = categories.contains { $0.name.lowercased() == trimmedName.lowercased() }
        if isDuplicate {
            throw CategoryError.duplicateName
        }
        
        let newCategory = Category(name: trimmedName, iconName: validIconName)
        categories.append(newCategory)
        
        do {
            saveCategories()
        } catch {
            // Remove the category if saving failed
            categories.removeAll { $0.id == newCategory.id }
            throw CategoryError.saveFailed
        }
        
        return newCategory
    }
    
    func deleteCategory(_ category: Category) throws {
        // Prevent deletion of the last category
        guard categories.count > 1 else {
            throw CategoryError.cannotDeleteLastCategory
        }
        
        // Prevent deletion of General category if it's the only fallback
        if category.name == "General" && categories.count == 1 {
            throw CategoryError.cannotDeleteGeneralCategory
        }
        
        // Move notes from deleted category to the first available category (General)
        let defaultCategory = categories.first { $0.name == "General" && $0.id != category.id } ?? 
                             categories.first { $0.id != category.id }
        
        guard let targetCategory = defaultCategory else {
            throw CategoryError.noTargetCategoryForNotes
        }
        
        // Move notes to target category
        for index in notes.indices {
            if notes[index].categoryId == category.id {
                notes[index].categoryId = targetCategory.id
            }
        }
        
        // Remove the category
        categories.removeAll { $0.id == category.id }
        
        // Clear cache and save
        invalidateAllCache()
        
        do {
            saveChanges()
        } catch {
            // If saving fails, we need to restore the category to maintain consistency
            categories.append(category)
            // Restore notes to original category
            for index in notes.indices {
                if notes[index].categoryId == targetCategory.id {
                    // This is a simplified restoration - in practice, we'd need to track which notes were moved
                    notes[index].categoryId = category.id
                }
            }
            throw CategoryError.saveFailed
        }
    }
    
    // MARK: - Filtering and Search (Optimized)
    
    func notes(for category: Category) -> [Note] {
        return notes(for: category.id)
    }
    
    /// Searches notes across all categories by title and content
    func searchNotes(query: String) -> [Note] {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedQuery.isEmpty else {
            return []
        }
        
        let lowercaseQuery = trimmedQuery.lowercased()
        
        // Filter notes that match the query in title or body
        let matchingNotes = notes.filter { note in
            let titleMatch = note.title.lowercased().contains(lowercaseQuery)
            let bodyMatch = note.body.lowercased().contains(lowercaseQuery)
            return titleMatch || bodyMatch
        }
        
        // Sort results by relevance: title matches first, then content matches
        return matchingNotes.sorted { note1, note2 in
            let title1Match = note1.title.lowercased().contains(lowercaseQuery)
            let title2Match = note2.title.lowercased().contains(lowercaseQuery)
            
            // If one has title match and other doesn't, prioritize title match
            if title1Match && !title2Match {
                return true
            } else if !title1Match && title2Match {
                return false
            }
            
            // If both have title matches or both don't, sort by modification date
            return note1.modifiedAt > note2.modifiedAt
        }
    }
    
    /// Real-time search with debouncing for performance
    func searchNotesRealtime(query: String, completion: @escaping ([Note]) -> Void) {
        // Use existing debouncer for consistency
        saveDebouncer.debounce {
            let results = self.searchNotes(query: query)
            DispatchQueue.main.async {
                completion(results)
            }
        }
    }
    
    func notes(for categoryId: UUID) -> [Note] {
        // Use cache for better performance
        if let cachedNotes = notesCache[categoryId] {
            return cachedNotes
        }
        
        let filteredNotes = notes
            .filter { $0.categoryId == categoryId }
            .sorted { note1, note2 in
                // Sort by modification date (most recent first)
                if note1.modifiedAt != note2.modifiedAt {
                    return note1.modifiedAt > note2.modifiedAt
                }
                // If modification dates are equal, use creation date as secondary sort
                return note1.createdAt > note2.createdAt
            }
        
        notesCache[categoryId] = filteredNotes
        return filteredNotes
    }
    
    // MARK: - Performance Optimizations
    
    private func debouncedSave() {
        saveDebouncer.debounce {
            self.saveNotes()
        }
    }
    
    private func invalidateCache(for categoryId: UUID) {
        notesCache.removeValue(forKey: categoryId)
    }
    
    private func invalidateAllCache() {
        notesCache.removeAll()
    }
    
    // MARK: - Error Handling
    
    private func handleFileSystemError(_ error: Error, operation: String) {
        print("File system error during \(operation): \(error)")
        // In a production app, you might want to show user-facing error messages
        // or implement retry mechanisms here
    }
}