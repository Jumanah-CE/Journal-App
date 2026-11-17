
import SwiftUI
import SwiftData

struct ContentView: View {

    @Environment(\.modelContext) private var modelContext

    @State private var showSplashScreen = true
    @State private var showEditor = false
    @State private var viewModel: JournalViewModel?

    var body: some View {

        Group {

            if showSplashScreen {

                SplashScreen()

            } else if let viewModel {

                if viewModel.entries.isEmpty {

                    HomeView {
                        showEditor = true
                    }

                } else {

                    HomeJournalList(
                        entries: viewModel.entries,

                        onBookmark: { entry in
                            viewModel.toggleBookmark(entry)
                        },

                        onDelete: { entry in
                            viewModel.deleteEntry(entry)
                        },

                        onUpdate: { entry, title, content in
                            _ = viewModel.updateEntry(
                                entry,
                                title: title,
                                content: content
                            )
                        },

                        // FIX: Connect the plus button
                        onAddJournal: {
                            showEditor = true
                        }
                    )
                }
            }
        }
        .sheet(isPresented: $showEditor) {

            JournalEditorView { title, content in

                guard let viewModel else { return }

                _ = viewModel.addEntry(
                    title: title,
                    content: content
                )
            }
        }
        .task {

            if viewModel == nil {
                viewModel = JournalViewModel(
                    modelContext: modelContext
                )
            }

            try? await Task.sleep(for: .seconds(2))

            guard !Task.isCancelled else {
                return
            }

            withAnimation(.easeInOut(duration: 0.4)) {
                showSplashScreen = false
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: JournalEntry.self, inMemory: true)
}

