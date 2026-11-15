
import SwiftUI

struct SplashScreen: View {

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black
                    .ignoresSafeArea()

                VStack(spacing: 12) {

                    Image("splash")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 78, height: 101)

                    Text("Journali")
                        .font(.system(size: 42, weight: .black))
                        .foregroundColor(.white)
                        .fixedSize()

                    Text("Your thoughts, your story")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(Color.white.opacity(0.75))
                        .fixedSize()
                }
                .position(
                    x: geometry.size.width / 2,
                    y: geometry.size.height / 2
                )
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    SplashScreen()
}

