import SwiftUI

struct SignInView: View {
  @EnvironmentObject private var spotifyController: SpotifyController

  var body: some View {
    VStack(spacing: 24) {
      Spacer()
      featureDescription
      Spacer()
      spotifySignInButton
      Spacer()
    }
    .padding()
  }

  private var featureDescription: some View {
    Group {
      Text("Discover the Music Around You")
        .font(.largeTitle)
        .fontWeight(.bold)
        .multilineTextAlignment(.center)

      Text("Sign in with Spotify to explore and share what you're listening to with those nearby.")
        .font(.body)
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.center)
    }
    .padding(.horizontal)
  }

  private var spotifySignInButton: some View {
    Button(action: { spotifyController.authorize() }) {
      HStack {
        Image(systemName: "music.note")
        Text("Connect with Spotify")
      }
      .fontWeight(.medium)
      .padding(.vertical, 12)
      .padding(.horizontal, 24)
      .background(.green)
      .foregroundColor(.black)
      .cornerRadius(20)
    }
  }
}

#Preview {
  SignInView()
    .environmentObject(SpotifyController())
}
