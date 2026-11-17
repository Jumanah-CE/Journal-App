
import SwiftUI

struct JournalEditorView: View {

    // MARK: - Properties

    @Environment(\.dismiss) private var dismiss

    let entry: JournalEntry?
    let onSave: (String, String) -> Void

    @State private var title: String
    @State private var content: String
    @State private var showDiscardAlert = false

    @FocusState private var isContentFocused: Bool

    // MARK: - Colors

    private let backgroundColor = Color(
        red: 28.0 / 255,
        green: 28.0 / 255,
        blue: 30.0 / 255
    )

    private let primaryAccent = Color(
        red: 127.0 / 255,
        green: 129.0 / 255,
        blue: 255.0 / 255
    )

    private let primaryText = Color.white

    private let secondaryText = Color(
        red: 163.0 / 255,
        green: 154.0 / 255,
        blue: 154.0 / 255
    )

    private var hasText: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    // MARK: - Initializer

    init(
        entry: JournalEntry? = nil,
        onSave: @escaping (String, String) -> Void
    ) {
        self.entry = entry
        self.onSave = onSave

        _title = State(initialValue: entry?.title ?? "")
        _content = State(initialValue: entry?.content ?? "")
    }

    // MARK: - Body

    var body: some View {

        NavigationStack {

            ZStack {

                backgroundColor
                    .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 0) {

                    // MARK: Title

                    TextField("Title", text: $title)
                        .font(.system(size: 34, weight: .semibold))
                        .foregroundStyle(primaryText)
                        .tint(primaryAccent)
                        .padding(.top, 12)

                    // MARK: Date

                    Text(
                        entry?.dateCreated ?? Date(),
                        format: .dateTime.day().month().year()
                    )
                    .font(.system(size: 16))
                    .foregroundStyle(secondaryText)
                    .padding(.top, 12)

                    // MARK: Journal Content

                    ZStack(alignment: .topLeading) {

                        if content.isEmpty {

                            Text("Type your Journal...")
                                .font(.system(size: 18))
                                .foregroundStyle(secondaryText)
                                .padding(.top, 8)
                                .padding(.leading, 5)
                                .allowsHitTesting(false)
                        }

                        TextEditor(text: $content)
                            .font(.system(size: 18))
                            .foregroundStyle(primaryText)
                            .tint(primaryAccent)
                            .scrollContentBackground(.hidden)
                            .background(Color.clear)
                            .focused($isContentFocused)
                    }
                    .padding(.top, 18)

                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 20)
            }

            // MARK: Native Toolbar

            .toolbar {

                // MARK: Native Close Button

                ToolbarItem(placement: .cancellationAction) {

                    Button {
                        if hasText {
                            showDiscardAlert = true
                        } else {
                            dismiss()
                        }
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .accessibilityLabel("Close")
                }

                // MARK: Save Button

                ToolbarItem(placement: .confirmationAction) {

                    Button {

                        guard hasText else { return }

                        onSave(
                            title.trimmingCharacters(
                                in: .whitespacesAndNewlines
                            ),
                            content.trimmingCharacters(
                                in: .whitespacesAndNewlines
                            )
                        )

                        dismiss()

                    } label: {
                        Image(systemName: "checkmark")
                    }
                    .buttonStyle(.glassProminent)
                    .tint(primaryAccent)
                    .accessibilityLabel("Save")
                }
            }

            .toolbarBackground(backgroundColor, for: .navigationBar)
            .preferredColorScheme(.dark)

            // MARK: Discard Changes Alert

            .alert(
                "Discard Changes",
                isPresented: $showDiscardAlert,
                actions: {

                    Button("Discard Changes", role: .destructive) {
                        dismiss()
                    }

                    Button("Keep Editing", role: .cancel) {
                        showDiscardAlert = false
                    }
                },
                message: {
                    Text(
                        "Are you sure you want to discard changes on this journal?"
                    )
                }
            )
        }
        .preferredColorScheme(.dark)

        // MARK: Keyboard Focus

        .onAppear {
            isContentFocused = true
        }
    }
}

// MARK: - Preview

#Preview {
    JournalEditorView { title, content in
        print("Title: \(title)")
        print("Content: \(content)")
    }
}

