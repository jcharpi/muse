import SwiftUI

// MARK: - MuseApp
/// Main application entry point conforming to SwiftUI's App protocol
@main
struct MuseApp: App {
  // MARK: - Properties
  /// Shared Spotify controller managing authentication and playback
  @StateObject private var spotifyController = SpotifyController()
    
  /// Primary view model for business logic and data flow
  @State private var viewModel = MuseViewModel()
    
  // MARK: - Body
  var body: some Scene {
    WindowGroup {
      Group {
        if spotifyController.accessToken != nil {
          // Authenticated state - show main interface
          MuseHomeView()
            .environment(viewModel)
            .environmentObject(spotifyController)
        } else {
          // Unauthenticated state - show sign-in flow
          SignInView(showSignIn: .constant(false))
            .environmentObject(spotifyController)
        }
      }
      .onOpenURL { url in
        // Handle Spotify authentication callback
        spotifyController.setAccessToken(from: url)
      }
      .onAppear {
        // Link Spotify controller to view model
        viewModel.spotifyController = spotifyController
      }
    }
  }
    
  // MARK: - Constants
  /// Shared visual constants for the application
  private struct Constants {
    static let backgroundColor: Color = .black.opacity(0.8)
  }
}
