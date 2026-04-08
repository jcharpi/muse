import SwiftUI

@main
struct MuseApp: App {
  @StateObject private var spotifyController = SpotifyController()
  @State private var viewModel = MuseViewModel()

  var body: some Scene {
    WindowGroup {
      Group {
        if spotifyController.accessToken != nil {
          MuseHomeView()
            .environment(viewModel)
            .environmentObject(spotifyController)
        } else {
          SignInView()
            .environmentObject(spotifyController)
        }
      }
      .onOpenURL { url in
        spotifyController.setAccessToken(from: url)
      }
      .onAppear {
        viewModel.spotifyController = spotifyController
      }
    }
  }
}
