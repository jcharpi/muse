import SwiftUI

/// A view that presents the Spotify authentication screen and app introduction
struct SignInView: View {
  // MARK: - Properties
  @Binding var showSignIn: Bool
  /// Environment property to access view dismissal functionality
  @Environment(\.dismiss) private var dismiss
    
  // MARK: - Main View
  var body: some View {
    VStack(spacing: Constants.vStackSpacing) {
      Spacer()
            
      // Header Section
      featureDescription
            
      Spacer()
            
      // Sign In Button
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
    // 1. Initiate authentication through shared manager
    AuthManager.shared.login()
        
    // 2. Update presentation state
    showSignIn = false
        
    // 3. Dismiss the view
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
