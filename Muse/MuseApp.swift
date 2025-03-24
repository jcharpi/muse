import SwiftUI

@main
struct MuseApp: App {
  @StateObject private var spotifyController = SpotifyController()
  @State private var viewModel = MuseViewModel()
    
  var body: some Scene {
    WindowGroup {
      if spotifyController.accessToken != nil {
        MuseHomeView()
          .environment(viewModel)
          .environmentObject(spotifyController)
          .onOpenURL { url in
            spotifyController.setAccessToken(from: url)
          }
      } else {
        SignInView(showSignIn: .constant(false)) // Binding not needed here
          .environmentObject(spotifyController)
      }
    }
  }
    
  private struct Constants {
    static let backgroundColor: Color = Color.black.opacity(0.8)
  }
}
