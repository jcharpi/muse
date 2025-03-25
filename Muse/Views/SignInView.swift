import SwiftUI

// MARK: - SignInView
/// Authentication gateway with Spotify OAuth2 integration
struct SignInView: View {
  // MARK: - Properties
  @Binding var showSignIn: Bool // Controls view visibility
  @Environment(\.dismiss) private var dismiss
  @EnvironmentObject private var spotifyController: SpotifyController

  // MARK: - Body
  var body: some View {
    VStack(spacing: Constants.vStackSpacing) {
      Spacer()
      featureDescription
      Spacer()
      spotifySignInButton
      Spacer()
    }
    .padding()
  }

  // MARK: - Subviews
  /// Marketing copy explaining app value proposition
  private var featureDescription: some View {
    Group {
      Text("Discover the Music Around You")
        .font(.largeTitle)
        .fontWeight(.bold)
        .multilineTextAlignment(.center)
      
      Text(
        "Sign in with Spotify to explore and share what you're listening to with those nearby."
      )
      .font(.body)
      .foregroundStyle(.secondary)
      .multilineTextAlignment(.center)
    }
    .padding(.horizontal)
  }

  /// Primary authentication CTA
  private var spotifySignInButton: some View {
    Button(action: signInWithSpotify) {
      HStack {
        Image(systemName: "music.note")
        Text("Connect with Spotify")
      }
      .buttonStyling()
    }
  }

  // MARK: - Actions
  /// Initiates Spotify authentication flow
  private func signInWithSpotify() {
    spotifyController.authorize()
    showSignIn = false
    dismiss()
  }

  // MARK: - Constants
  private struct Constants {
    static let vStackSpacing: CGFloat = 24
  }
}

// MARK: - Button Styling
private extension View {
  /// Standard styling for authentication button
  func buttonStyling() -> some View {
    self
      .fontWeight(.medium)
      .padding(.vertical, 12)
      .padding(.horizontal, 24)
      .background(.green)
      .foregroundColor(.black)
      .cornerRadius(20)
  }
}

// MARK: - Previews
#Preview {
  SignInView(showSignIn: .constant(true))
    .environmentObject(SpotifyController())
}
