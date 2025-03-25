import SwiftUI

// MARK: - MuseHomeView
/// Primary application interface with tabbed navigation for:
/// - Current playback view
/// - Nearby listener discovery
struct MuseHomeView: View {
  // MARK: - Dependencies
  @Environment(MuseViewModel.self) private var viewModel
  @EnvironmentObject private var spotifyController: SpotifyController

  // MARK: - State
  @State private var showHeaderAlert = false // Controls logout confirmation dialog
  @State private var showSignIn = false // Toggles full-screen sign-in overlay

  // MARK: - Body
  var body: some View {
    TabView {
      nowPlaying
        .tabItem { Label("Now Playing", systemImage: "play.fill") }
      
      MuseNearbyView()
        .tabItem { Label("Nearby", systemImage: "wave.3.up") }
    }
    .tint(.primary)
    .fullScreenCover(isPresented: $showSignIn) {
      SignInView(showSignIn: $showSignIn)
    }
  }

  // MARK: - Subviews
  /// Current user's playback interface with logout controls
  private var nowPlaying: some View {
    VStack {
      // Profile header with logout capability
      Button { showHeaderAlert = true } label: { HeaderView() }
        .alert("Logout", isPresented: $showHeaderAlert) {
          Button("Cancel", role: .cancel) { }
          Button("Logout", role: .destructive) {
            spotifyController.disconnect()
            spotifyController.accessToken = nil
            showSignIn = true // Trigger auth flow
          }
        }
      
      Spacer()
      MusicDisplayView(user: viewModel.user) // Current track visualization
      Spacer()
      Spacer()
    }
  }
}

// MARK: - Previews
#Preview {
  let model = MuseModel(musicService: MockMusicService())
  model.setTestData(user: TestData.testUser, listeners: TestData.testListeners)
  return MuseHomeView()
    .environment(MuseViewModel(model: model))  
    .environmentObject(SpotifyController())

}
