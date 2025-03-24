import SwiftUI

/// A view that presents the Spotify authentication screen and app introduction
struct SignInView: View {
  @Binding var showSignIn: Bool
  @Environment(\.dismiss) private var dismiss
  @EnvironmentObject private var spotifyController: SpotifyController
    
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
    
  // MARK: - View Components
  /// Contains the main promotional text and description
  private var featureDescription: some View {
    Group {
      Text("Discover the Music Around You")
        .font(.largeTitle)
        .fontWeight(.bold)
        .multilineTextAlignment(.center)
        .padding(.horizontal)
            
      Text(
        "Sign in with Spotify to explore and share what you're listening to with those nearby."
      )
      .font(.body)
      .multilineTextAlignment(.center)
      .foregroundStyle(.secondary)
      .padding(.horizontal)
    }
  }
    
  /// The primary Spotify authentication button
  private var spotifySignInButton: some View {
    Button(action: signInWithSpotify) {
      HStack {
        Image(systemName: "music.note")
        Text("Sign in with Spotify")
          .fontWeight(.medium)
      }
      .padding(.vertical, Constants.verticalPadding)
      .padding(.horizontal, Constants.horizontalPadding)
      .background(.green)
      .foregroundColor(.black)
      .cornerRadius(Constants.cornerRadius)
    }
  }
    
  // MARK: - Actions
  /// Handles the Spotify authentication flow
  private func signInWithSpotify() {
    spotifyController.authorize()
    showSignIn = false
    dismiss()
  }
    
  // MARK: - Constants
  /// Contains all visual constants for the view
  private struct Constants {
    static let verticalPadding: CGFloat = 12
    static let horizontalPadding: CGFloat = 24
    static let cornerRadius: CGFloat = 20
    static let vStackSpacing: CGFloat = 24
  }
}

// MARK: - Previews
#Preview {
  // Preview with active state binding
  SignInView(showSignIn: .constant(true))
}
