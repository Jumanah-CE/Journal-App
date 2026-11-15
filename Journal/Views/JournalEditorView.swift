
import SwiftUI

struct JournalEditorView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var title: String
    @State private var content: String
    @State private var showDiscardAlert = false

    @FocusState private var isTitleFocused: Bool

    let entry: JournalEntry?
    let onSave: (String, String) -> Void

    // MARK: Colors

    private let accentColor = Color(
        red: 127.0 / 255,
        green: 129.0 / 255,
        blue: 255.0 / 255
    )

    private let surfaceColor = Color(
        red: 28.0 / 255,
        green: 28.0 / 255,
        blue: 30.0 / 255
    )

    private let secondaryText = Color(
        red: 163.0 / 255,
        green: 154.0 / 255,
        blue: 154.0 / 255
    )

    private let destructiveColor = Color(
        red: 253.0 / 255,
        green: 69.0 / 255,
        blue: 60.0 / 255
    )

    // MARK: Initializer

    init(
        entry: JournalEntry? = nil,
        onSave: @escaping (String, String) -> Void
    ) {
        self.entry = entry
        self.onSave = onSave

        _title = State(initialValue: entry?.title ?? "")
        _content = State(initialValue: entry?.content ?? "")
    }

    // MARK: Changes Detection

    private var hasChanges: Bool {
        title != (entry?.title ?? "") ||
        content != (entry?.content ?? "")
    }

    // MARK: Body

    var body: some View {

        ZStack {

            Color.black
                .ignoresSafeArea()

            VStack(spacing: 0) {

                // MARK: Drag Handle

                Capsule()
                    .fill(secondaryText.opacity(0.5))
                    .frame(width: 36, height: 4)
                    .padding(.top, 8)
                    .padding(.bottom, 12)

                // MARK: Header

                HStack {

                    Button {
                        cancelEditing()
                    } label: {

                        Image(systemName: "xmark")
                            .font(.system(size: 16))
                            .foregroundStyle(.white)
                            .frame(width: 32, height: 32)
                            .background(surfaceColor)
                            .clipShape(Circle())
                    }
                    .accessibilityLabel("Cancel")

                    Spacer()

                    Button {
                        saveJournal()
                    } label: {

                        Image(systemName: "checkmark")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(.black)
                            .frame(width: 36, height: 36)
                            .background(accentColor)
                            .clipShape(Circle())
                    }
                    .accessibilityLabel("Save journal")
                }
                .padding(.horizontal, 14)

                // MARK: Title

                TextField("Title", text: $title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.white)
                    .tint(accentColor)
                    .focused($isTitleFocused)
                    .padding(.top, 12)

                // MARK: Date

                Text(
                    entry?.dateCreated ?? .now,
                    format: .dateTime.day().month().year()
                )
                .font(.system(size: 12))
                .foregroundStyle(secondaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 6)

                // MARK: Journal Content

                TextEditor(text: $content)
                    .font(.system(size: 16))
                    .foregroundStyle(.white)
                    .tint(accentColor)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .overlay(alignment: .topLeading) {

                        if content.isEmpty {
                            Text("Type your Journal...")
                                .font(.system(size: 16))
                                .foregroundStyle(secondaryText)
                                .padding(.top, 8)
                                .padding(.leading, 5)
                                .allowsHitTesting(false)
                        }
                    }
                    .padding(.top, 12)

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 14)

            // MARK: Discard Confirmation

            if showDiscardAlert {
                discardConfirmation
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
        .preferredColorScheme(.dark)
        .toolbar(.hidden, for: .navigationBar)
        .animation(
            .easeInOut(duration: 0.2),
            value: showDiscardAlert
        )
        .task {
            try? await Task.sleep(for: .milliseconds(300))

            guard !Task.isCancelled else {
                return
            }

            isTitleFocused = true
        }
    }

    // MARK: Save Journal

    private func saveJournal() {

        let trimmedTitle = title.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        let trimmedContent = content.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !trimmedTitle.isEmpty || !trimmedContent.isEmpty else {
            return
        }

        onSave(trimmedTitle, trimmedContent)
        dismiss()
    }

    // MARK: Cancel Editing

    private func cancelEditing() {

        if hasChanges {
            showDiscardAlert = true
        } else {
            dismiss()
        }
    }

    // MARK: Discard Confirmation

    private var discardConfirmation: some View {

        ZStack {

            Color.black.opacity(0.65)
                .ignoresSafeArea()

            VStack(spacing: 12) {

                Text(
                    "Are you sure you want to discard changes on this journal?"
                )
                .font(.system(size: 14))
                .foregroundStyle(.white.opacity(0.85))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 6)

                // Discard Changes

                Button {
                    dismiss()
                } label: {

                    Text("Discard Changes")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(destructiveColor)
                        .frame(maxWidth: .infinity)
                        .frame(height: 42)
                        .background(Color.gray.opacity(0.35))
                        .clipShape(Capsule())
                }

                // Keep Editing

                Button {
                    showDiscardAlert = false
                } label: {

                    Text("Keep Editing")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 42)
                        .background(Color.gray.opacity(0.35))
                        .clipShape(Capsule())
                }
            }
            .padding(16)
            .frame(maxWidth: 280)
            .background(surfaceColor)
            .clipShape(RoundedRectangle(cornerRadius: 24))
        }
    }
}

