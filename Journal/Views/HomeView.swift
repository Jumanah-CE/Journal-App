
import SwiftUI

struct HomeView: View {

    let onAddJournal: () -> Void

    @State private var searchText = ""

    var body: some View {

        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {

                // Header
                HStack {

                    Text("Journal")
                        .font(.system(size: 42, weight: .black))
                        .foregroundStyle(.white)

                    Spacer()

                    HStack(spacing: 28) {

                        Button {
                            // Filter will be connected later.
                        } label: {
                            Image(systemName: "line.3.horizontal.decrease")
                        }

                        Button {
                            onAddJournal()
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                    .font(.system(size: 24))
                    .foregroundStyle(.white)
                    .frame(width: 104, height: 48)
                    .glassEffect(.regular, in: Capsule())
                }
                .padding(.horizontal, 21)
                .padding(.top, 16)

                Spacer()

                // Empty State
                VStack(spacing: 0) {

                    Image("Book")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 151.39, height: 97.32)
                        .padding(.bottom, 30)

                    Text("Begin Your Journal")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(
                            Color(red: 175/255, green: 153/255, blue: 253/255)
                        )
                        .padding(.bottom, 14)

                    Text("Craft your personal diary, tap the\nplus icon to begin")
                        .font(.system(size: 20))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                }
                .offset(y: -20)

                Spacer()

                // Search Bar
                searchBar
                    .padding(.horizontal, 21)
                    .padding(.bottom, 6)
            }
        }
        .preferredColorScheme(.dark)
    }

    private var searchBar: some View {

        HStack(spacing: 12) {

            Image(systemName: "magnifyingglass")
                .font(.system(size: 25))
                .foregroundStyle(.gray)

            TextField("Search", text: $searchText)
                .font(.system(size: 18))
                .foregroundStyle(.white)

            Image(systemName: "mic")
                .font(.system(size: 24))
                .foregroundStyle(.gray)
        }
        .padding(.horizontal, 14)
        .frame(height: 64)
        .background(Color(red: 28/255, green: 28/255, blue: 30/255))
        .clipShape(Capsule())
    }
}

#Preview {
    HomeView {
        print("Add journal tapped")
    }
}

