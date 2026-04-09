import SwiftUI

struct MuseHomeView: View {
  @Environment(MuseViewModel.self) private var viewModel
  @EnvironmentObject private var spotifyController: SpotifyController

  @State private var showDisconnectAlert = false

  var body: some View {
    TabView {
      nowPlaying
        .tabItem { Label("Now Playing", systemImage: "play.fill") }

      MuseNearbyView()
        .tabItem { Label("Nearby", systemImage: "wave.3.up") }
    }
    .tint(.primary)
  }

  private var nowPlaying: some View {
    VStack {
      Button { showDisconnectAlert = true } label: { HeaderView() }
        .alert("Disconnect", isPresented: $showDisconnectAlert) {
          Button("Cancel", role: .cancel) {}
          Button("Disconnect", role: .destructive) {
            spotifyController.disconnect()
            spotifyController.accessToken = nil
          }
        }

      Spacer()

      if viewModel.user.reactionCount > 0 {
        HStack(spacing: 6) {
          Image(systemName: "hand.thumbsup.fill")
          Text("\(viewModel.user.reactionCount)")
            .fontWeight(.semibold)
        }
        .font(.title3)
        .foregroundStyle(.yellow)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Capsule().fill(Color.yellow.opacity(0.15)))
      }

      MusicDisplayView(user: viewModel.user)
      Spacer()
    }
  }
}

#Preview {
  let model = MuseModel(musicService: MockMusicService())
  model.setTestData(user: TestData.testUser, listeners: TestData.testListeners)
  return MuseHomeView()
    .environment(MuseViewModel(model: model))
    .environmentObject(SpotifyController())
}
