import SwiftUI

struct MusicDisplayView: View {
  let displayTarget: DisplayTarget
  @Environment(MuseViewModel.self) private var viewModel
    
  init(listener: Listener) {
    self.displayTarget = .listener(listener)
  }
    
  init(user: User) {
    self.displayTarget = .user(user)
  }
    
  var body: some View {
    Group {
      switch displayTarget {
      case .listener(let listener):
        listenerContent(listener)
      case .user(let user):
        userContent(user)
      }
    }
  }
    
  // MARK: - View Components
  @ViewBuilder
  private func listenerContent(_ listener: Listener) -> some View {
    let tracks = viewModel.listenerTracks(listener)
        
    if viewModel.shouldShowCarousel(for: listener) {
      TabView {
        ForEach(tracks, id: \.header) { track, header in
          SongTabView(track: track, headerTitle: header)
        }
      }
      .tabViewStyle(.page(indexDisplayMode: .always))
    } else {
      SongTabView(
        track: tracks.first?.track,
        headerTitle: tracks.first?.header ?? "No Track"
      )
    }
  }
    
  @ViewBuilder
  private func userContent(_ user: User) -> some View {
    SongTabView(
      track: user.listeningTo,
      headerTitle: viewModel.userHeader(user)
    )
  }
    
  // MARK: - Display Target
  enum DisplayTarget {
    case listener(Listener)
    case user(User)
  }
}

// MARK: - Preview
#Preview {
  let model = MuseModel(musicService: MockMusicService())
  model.setTestData(
    user: TestData.testUser,
    listeners: TestData.testListeners
  )
  let viewModel = MuseViewModel(model: model)
    
  return MusicDisplayView(listener: TestData.testListeners[0])
    .environment(viewModel)
}

#Preview {
  let model = MuseModel(musicService: MockMusicService())
  model.setTestData(
    user: TestData.testUser,
    listeners: TestData.testListeners
  )
  let viewModel = MuseViewModel(model: model)
    
  return MusicDisplayView(listener: TestData.testListeners[1])
    .environment(viewModel)
}

#Preview {
  let model = MuseModel(musicService: MockMusicService())
  model.setTestData(
    user: TestData.testUser,
    listeners: TestData.testListeners
  )
  let viewModel = MuseViewModel(model: model)
    
  return MusicDisplayView(user: TestData.testUser)
    .environment(viewModel)
}
