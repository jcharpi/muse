import SwiftUI

struct MuseHomeView: View {
  @Environment(MuseViewModel.self) private var viewModel
  @State private var showHeaderAlert = false
  @State private var showSignIn = false  // New state variable

  var body: some View {
    TabView {
      nowPlaying
        .tabItem {
          Label("Now Playing", systemImage: "play.fill")
        }
            
      MuseNearbyView()
        .tabItem {
          Label("Nearby", systemImage: "wave.3.up")
        }
    }
    .tint(.primary)
    .fullScreenCover(isPresented: $showSignIn) {
      SignInView(showSignIn: $showSignIn)
    }
  }
    
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
          showSignIn = true  // Update local state
        }
      }
            
      Spacer()
      MusicDisplayView(user: viewModel.user)
      Spacer()
      // TODO: Media controls
      Spacer()
    }
  }
}

#Preview {
  MuseHomeView()
    .environment(MuseViewModel())
}
