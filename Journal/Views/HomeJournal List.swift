
import SwiftUI

private enum JournalListColors {

    static let primaryAccent = Color(
        red: 127.0 / 255,
        green: 129.0 / 255,
        blue: 255.0 / 255
    )

    static let textAccent = Color(
        red: 175.0 / 255,
        green: 153.0 / 255,
        blue: 253.0 / 255
    )

    static let textPrimary = Color.white

    static let textSecondary = Color(
        red: 163.0 / 255,
        green: 154.0 / 255,
        blue: 154.0 / 255
    )

    static let surfaceCard = Color(
        red: 28.0 / 255,
        green: 28.0 / 255,
        blue: 30.0 / 255
    )

    static let destructive = Color(
        red: 253.0 / 255,
        green: 69.0 / 255,
        blue: 60.0 / 255
    )
}

private enum JournalSortOption {
    case bookmark
    case entryDate
}

struct HomeJournalList: View {

    let entries: [JournalEntry]
    let onBookmark: (JournalEntry) -> Void
    let onDelete: (JournalEntry) -> Void
    let onUpdate: (JournalEntry, String, String) -> Void

    // Opens the Add Journal editor
    let onAddJournal: () -> Void

    @State private var searchText = ""
    @State private var entryToDelete: JournalEntry?
    @State private var showDeleteAlert = false
    @State private var sortOption: JournalSortOption = .entryDate
    @State private var entryToEdit: JournalEntry?

    private var filteredEntries: [JournalEntry] {

        guard !searchText.isEmpty else {
            return entries
        }

        return entries.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.content.localizedCaseInsensitiveContains(searchText)
        }
    }

    private var sortedEntries: [JournalEntry] {

        switch sortOption {

        case .bookmark:
            return filteredEntries.sorted {
                if $0.isBookmarked != $1.isBookmarked {
                    return $0.isBookmarked
                }

                return $0.dateCreated > $1.dateCreated
            }

        case .entryDate:
            return filteredEntries.sorted {
                $0.dateCreated > $1.dateCreated
            }
        }
    }

    var body: some View {

        ZStack {

            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {

                header
                    .padding(.horizontal, 21)
                    .padding(.top, 16)

                ScrollView {

                    LazyVStack(spacing: 14) {

                        ForEach(sortedEntries) { entry in

                            journalCard(entry)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    entryToEdit = entry
                                }
                                .swipeActions(
                                    edge: .trailing,
                                    allowsFullSwipe: false
                                ) {

                                    Button(role: .destructive) {
                                        entryToDelete = entry
                                        showDeleteAlert = true
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 24)
                    .padding(.bottom, 20)
                }

                searchBar
                    .padding(.horizontal, 21)
                    .padding(.bottom, 6)
            }

            if showDeleteAlert {
                deleteConfirmation
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
        .preferredColorScheme(.dark)
        .animation(.easeInOut(duration: 0.2), value: showDeleteAlert)

        // MARK: Edit Existing Journal
        .sheet(item: $entryToEdit) { entry in

            JournalEditorView(entry: entry) { title, content in
                onUpdate(entry, title, content)
            }
        }
    }

    // MARK: Header

    private var header: some View {

        HStack {

            Text("Journal")
                .font(.system(size: 42, weight: .black))
                .foregroundStyle(JournalListColors.textPrimary)

            Spacer()

            HStack(spacing: 28) {

                Menu {

                    Button("Sort by Bookmark") {
                        sortOption = .bookmark
                    }

                    Button("Sort by Entry Date") {
                        sortOption = .entryDate
                    }

                } label: {

                    Image(systemName: "line.3.horizontal.decrease")
                }
                .accessibilityLabel("Sort journals")

                // FIX: Use a normal Button instead of NavigationLink
                Button {
                    onAddJournal()
                } label: {
                    Image(systemName: "plus")
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Add journal")
            }
            .font(.system(size: 24))
            .foregroundStyle(JournalListColors.textPrimary)
            .padding(.horizontal, 22)
            .frame(height: 48)
            .glassEffect(.regular, in: Capsule())
        }
    }

    // MARK: Journal Card

    private func journalCard(_ entry: JournalEntry) -> some View {

        VStack(alignment: .leading, spacing: 12) {

            HStack {

                Text(entry.title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(JournalListColors.textAccent)

                Spacer()

                Button {
                    onBookmark(entry)
                } label: {

                    Image(
                        systemName: entry.isBookmarked
                            ? "bookmark.fill"
                            : "bookmark"
                    )
                    .font(.system(size: 20))
                    .foregroundStyle(JournalListColors.textAccent)
                }
                .buttonStyle(.borderless)
                .accessibilityLabel(
                    entry.isBookmarked
                        ? "Remove bookmark"
                        : "Bookmark journal"
                )
            }

            Text(
                entry.dateCreated,
                format: .dateTime.day().month().year()
            )
            .font(.system(size: 12))
            .foregroundStyle(JournalListColors.textSecondary)

            Text(entry.content)
                .font(.system(size: 14))
                .foregroundStyle(JournalListColors.textPrimary)
                .lineLimit(5)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(JournalListColors.surfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }

    // MARK: Search Bar

    private var searchBar: some View {

        HStack(spacing: 12) {

            Image(systemName: "magnifyingglass")
                .font(.system(size: 25))
                .foregroundStyle(JournalListColors.textSecondary)

            TextField("Search", text: $searchText)
                .font(.system(size: 18))
                .foregroundStyle(JournalListColors.textPrimary)
                .tint(JournalListColors.primaryAccent)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .submitLabel(.search)

            Button {
                // Voice search will be connected later
            } label: {

                Image(systemName: "mic")
                    .font(.system(size: 24))
                    .foregroundStyle(JournalListColors.textSecondary)
            }
            .accessibilityLabel("Voice search")
        }
        .padding(.horizontal, 14)
        .frame(height: 64)
        .background(JournalListColors.surfaceCard)
        .clipShape(Capsule())
        .overlay {
            Capsule().stroke(Color.white.opacity(0.18), lineWidth: 1)
        }
    }

    // MARK: Delete Confirmation

    private var deleteConfirmation: some View {

        ZStack {

            Color.black.opacity(0.65)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {

                Text("Delete Journal?")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)

                Text("Are you sure you want to delete this journal?")
                    .font(.system(size: 14))
                    .foregroundStyle(.white.opacity(0.7))

                HStack(spacing: 8) {

                    Button {
                        entryToDelete = nil
                        showDeleteAlert = false
                    } label: {

                        Text("Cancel")
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(Color.gray.opacity(0.35))
                            .clipShape(Capsule())
                    }

                    Button {

                        if let entry = entryToDelete {
                            onDelete(entry)
                        }

                        entryToDelete = nil
                        showDeleteAlert = false

                    } label: {

                        Text("Delete")
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(JournalListColors.destructive)
                            .clipShape(Capsule())
                    }
                }
            }
            .padding(20)
            .frame(maxWidth: 300)
            .background(JournalListColors.surfaceCard)
            .clipShape(RoundedRectangle(cornerRadius: 24))
        }
    }
}

