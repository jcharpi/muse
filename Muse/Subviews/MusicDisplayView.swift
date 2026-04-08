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
    if listener.showsCarousel {
      TabView {
        ForEach(listener.tracks, id: \.header) { track, header in
          SongTabView(track: track, headerTitle: header)
        }
      }
      .tabViewStyle(.page(indexDisplayMode: .never))
      .frame(maxHeight: 550)
    } else {
      SongTabView(
        track: listener.tracks.first?.track,
        headerTitle: listener.tracks.first?.header ?? ""
      )
      .frame(maxHeight: 550)
    }
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

#Preview {
  let model = MuseModel(musicService: MockMusicService())
  model.setTestData(user: TestData.testUser, listeners: TestData.testListeners)
  return MusicDisplayView(listener: TestData.testListeners[1])
    .environment(MuseViewModel(model: model))
    .environmentObject(SpotifyController())
}

#Preview {
  let model = MuseModel(musicService: MockMusicService())
  model.setTestData(user: TestData.testUser, listeners: TestData.testListeners)
  return MusicDisplayView(user: TestData.testUser)
    .environment(MuseViewModel(model: model))
    .environmentObject(SpotifyController())
}
