
import Foundation
import SwiftData
import Observation

@MainActor
@Observable
final class JournalViewModel {

    private let modelContext: ModelContext

    private(set) var entries: [JournalEntry] = []

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchEntries()
    }

    // MARK: Fetch Entries

    func fetchEntries() {
        let descriptor = FetchDescriptor<JournalEntry>(
            sortBy: [SortDescriptor(\.dateCreated, order: .reverse)]
        )

        do {
            entries = try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch journals: \(error)")
        }
    }

    // MARK: Add Entry

    func addEntry(title: String, content: String) -> Bool {
        let entry = JournalEntry(
            title: title,
            content: content
        )

        modelContext.insert(entry)

        do {
            try modelContext.save()
            fetchEntries()
            return true
        } catch {
            print("Failed to save journal: \(error)")
            modelContext.delete(entry)
            return false
        }
    }

    // MARK: Update Entry

    func updateEntry(
        _ entry: JournalEntry,
        title: String,
        content: String
    ) -> Bool {

        let oldTitle = entry.title
        let oldContent = entry.content

        entry.title = title
        entry.content = content

        do {
            try modelContext.save()
            fetchEntries()
            return true
        } catch {
            entry.title = oldTitle
            entry.content = oldContent
            print("Failed to update journal: \(error)")
            return false
        }
    }

    // MARK: Delete Entry

    func deleteEntry(_ entry: JournalEntry) {
        modelContext.delete(entry)

        do {
            try modelContext.save()
            fetchEntries()
        } catch {
            print("Failed to delete journal: \(error)")
        }
    }

    // MARK: Toggle Bookmark

    func toggleBookmark(_ entry: JournalEntry) {
        entry.isBookmarked.toggle()

        do {
            try modelContext.save()
            fetchEntries()
        } catch {
            entry.isBookmarked.toggle()
            print("Failed to update bookmark: \(error)")
        }
    }
}

