
import SwiftUI

private enum JournalColors {
    static let background = Color.black
    static let primaryAccent = Color(red: 127.0/255, green: 129.0/255, blue: 1.0)
    static let textAccent = Color(red: 175.0/255, green: 153.0/255, blue: 253.0/255)
    static let textPrimary = Color.white
    static let textSecondary = Color(red: 163.0/255, green: 154.0/255, blue: 154.0/255)
    static let surfaceCard = Color(red: 28.0/255, green: 28.0/255, blue: 30.0/255)
}

struct HomeView: View {

    @State private var searchText = ""

    var body: some View {
        ZStack {
            JournalColors.background
                .ignoresSafeArea()

            VStack(spacing: 0) {

                // MARK: Header

                HStack {
                    Text("Journal")
                        .font(.system(size: 42, weight: .black))
                        .foregroundStyle(JournalColors.textPrimary)

                    Spacer()

                    HStack(spacing: 28) {

                        Button {
                            // Filter action will be connected later
                        } label: {
                            Image(systemName: "line.3.horizontal.decrease")
                        }
                        .accessibilityLabel("Filter journals")

                        NavigationLink(value: "addJournal") {
                            Image(systemName: "plus")
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("Add journal")
                    }
                    .font(.system(size: 24, weight: .regular))
                    .foregroundStyle(JournalColors.textPrimary)
                    .frame(width: 104, height: 48)
                    .background(JournalColors.surfaceCard)
                    .clipShape(Capsule())
                }
                .padding(.horizontal, 21)
                .padding(.top, 16)

                Spacer()

                // MARK: Empty State

                VStack(spacing: 0) {
                    Image("Book")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 151.39, height: 97.32)
                        .padding(.bottom, 30)

                    Text("Begin Your Journal")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(JournalColors.textAccent)
                        .padding(.bottom, 14)

                    Text("Craft your personal diary, tap the\nplus icon to begin")
                        .font(.system(size: 20, weight: .regular))
                        .foregroundStyle(JournalColors.textPrimary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(2)
                }
                .offset(y: -20)

                Spacer()

                // MARK: Search Bar

                searchBar
                    .padding(.horizontal, 21)
                    .padding(.bottom, 6)
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: Search Bar

    private var searchBar: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 25, weight: .regular))
                .foregroundStyle(JournalColors.textSecondary)

            TextField("Search", text: $searchText)
                .font(.system(size: 18))
                .foregroundStyle(JournalColors.textPrimary)
                .tint(JournalColors.primaryAccent)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .submitLabel(.search)

            Button {
                // Voice search action will be connected later
            } label: {
                Image(systemName: "mic")
                    .font(.system(size: 24, weight: .regular))
                    .foregroundStyle(JournalColors.textSecondary)
            }
            .accessibilityLabel("Voice search")
        }
        .padding(.horizontal, 14)
        .frame(height: 64)
        .background(JournalColors.surfaceCard)
        .clipShape(Capsule())
        .overlay {
            Capsule()
                .stroke(Color.white.opacity(0.18), lineWidth: 1)
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}

