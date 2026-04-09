import SwiftUI

struct MusicDisplayView: View {
  let displayTarget: DisplayTarget

  init(listener: Listener) { self.displayTarget = .listener(listener) }
  init(user: User)         { self.displayTarget = .user(user) }

  var body: some View {
    switch displayTarget {
    case .listener(let listener): listenerContent(listener)
    case .user(let user):         userContent(user)
    }
  }

  @ViewBuilder
  private func listenerContent(_ listener: Listener) -> some View {
    SongTabView(track: listener.listeningTo, headerTitle: "")
      .frame(maxHeight: 550)
  }

  @ViewBuilder
  private func userContent(_ user: User) -> some View {
    SongTabView(track: user.listeningTo, headerTitle: user.nowPlayingHeader)
  }

  enum DisplayTarget {
    case listener(Listener)
    case user(User)
  }
}

#Preview("Listener with track") {
  let model = MuseModel(musicService: MockMusicService())
  model.setTestData(user: TestData.testUser, listeners: TestData.testListeners)
  return MusicDisplayView(listener: TestData.testListeners[0])
    .environment(MuseViewModel(model: model))
    .environmentObject(SpotifyController())
}

#Preview("User now playing") {
  let model = MuseModel(musicService: MockMusicService())
  model.setTestData(user: TestData.testUser, listeners: TestData.testListeners)
  return MusicDisplayView(user: TestData.testUser)
    .environment(MuseViewModel(model: model))
    .environmentObject(SpotifyController())
}
