import SwiftUI

/// The main interface for the Muse app, managing tab navigation and sign-in flow.
struct MuseHomeView: View {
  // Injects a view model from the environment to supply user data and business logic.
  @Environment(MuseViewModel.self) private var viewModel
  @EnvironmentObject private var spotifyController: SpotifyController

  // Controls the display of the logout alert when interacting with the header.
  @State private var showHeaderAlert = false
  
  // Flags whether the sign-in screen should be presented (typically after a logout).
  @State private var showSignIn = false

  var body: some View {
    TabView {
      // Primary music playback interface.
      nowPlaying
        .tabItem {
          Label("Now Playing", systemImage: "play.fill")
        }
      
      // Interface for localized or interactive content.
      MuseNearbyView()
        .tabItem {
          Label("Nearby", systemImage: "wave.3.up")
        }
    }
    .tint(
      .primary
    )
    // Presents the sign-in screen as a full screen overlay when triggered.
    .fullScreenCover(isPresented: $showSignIn) {
      SignInView(showSignIn: $showSignIn)
    }
  }
    
  // Encapsulates the components for the "Now Playing" section.
  var nowPlaying: some View {
    VStack {
      Button {
        showHeaderAlert = true
      } label: {
        HeaderView()
      }
      .alert("Logout", isPresented: $showHeaderAlert) {
        Button("Cancel", role: .cancel) { }
        Button("Logout", role: .destructive) {
          spotifyController.disconnect()
          spotifyController.accessToken = nil
          showSignIn = true
        }
      }
      
      Spacer()
      // Displays current music information, driven by user data from the view model.
      MusicDisplayView(user: viewModel.user)
      Spacer()
      // Placeholder for additional media controls to be integrated.
      Spacer()
    }
  }
}

// SwiftUI preview setup using a mock model to simulate realistic app data.
#Preview {
  let model = MuseModel(musicService: MockMusicService())
  model.setTestData(
    user: TestData.testUser,
    listeners: TestData.testListeners
  )
  let viewModel = MuseViewModel(model: model)
    
  return MuseHomeView()
    .environment(viewModel)
}
