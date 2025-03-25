import SwiftUI

struct MusicDisplayView: View {
  // Determines whether to display content for a listener or a user.
  let displayTarget: DisplayTarget
  
  @Environment(MuseViewModel.self) private var viewModel
    
  // Initialize view for a listener display mode.
  init(listener: Listener) {
    self.displayTarget = .listener(listener)
  }
    
  // Initialize view for a user display mode.
  init(user: User) {
    self.displayTarget = .user(user)
  }
    
  var body: some View {
    Group {
      // Selects the appropriate content based on the display target.
      switch displayTarget {
      case .listener(let listener):
        listenerContent(listener)
      case .user(let user):
        userContent(user)
      }
    }
  }
    
  // MARK: - View Components

  // Builds the view for a listener, including a carousel if needed.
  @ViewBuilder
  private func listenerContent(_ listener: Listener) -> some View {
    let tracks = viewModel.listenerTracks(listener)
        
    if viewModel.shouldShowCarousel(for: listener) {
      // Uses a TabView for a paginated display of multiple tracks.
      TabView {
        ForEach(tracks, id: \.header) { track, header in
          SongTabView(track: track, headerTitle: header)
        }
      }
      .tabViewStyle(.page(indexDisplayMode: .never))
      // Ensure consistent height with single track view
      .frame(maxHeight: Constants.maxHeight)
    } else {
      // Fallback to a single track display when listener hasn't recommended a song.
      SongTabView(
        track: tracks.first?.track,
        headerTitle: tracks.first?.header ?? ""
      )
      // Match height with carousel display
      .frame(maxHeight: Constants.maxHeight)
    }
  }
    
  // Builds the view for a user, showing their current listening state.
  @ViewBuilder
  private func userContent(_ user: User) -> some View {
    SongTabView(
      track: user.listeningTo,
      headerTitle: viewModel.userHeader(user)
    )
  }
    
  // MARK: - Display Target
  
  // Enumerates the two display modes: for a listener or for a user.
  enum DisplayTarget {
    case listener(Listener)
    case user(User)
  }
  
  // MARK: - Constants
  private struct Constants {
    static let maxHeight: CGFloat = 550
  }
}

// MARK: - Previews

#Preview {
  // Preview for a listener (first test listener).
  let model = MuseModel(musicService: MockMusicService())
  model.setTestData(
    user: TestData.testUser,
    listeners: TestData.testListeners
  )
  let viewModel = MuseViewModel(model: model)
    
  return MusicDisplayView(listener: TestData.testListeners[0])
    .environment(viewModel)
    .environmentObject(SpotifyController())
}

#Preview {
  // Preview for a listener (second test listener).
  let model = MuseModel(musicService: MockMusicService())
  model.setTestData(
    user: TestData.testUser,
    listeners: TestData.testListeners
  )
  let viewModel = MuseViewModel(model: model)
    
  return MusicDisplayView(listener: TestData.testListeners[1])
    .environment(viewModel)
    .environmentObject(SpotifyController())
}

#Preview {
  // Preview for a user display mode.
  let model = MuseModel(musicService: MockMusicService())
  model.setTestData(
    user: TestData.testUser,
    listeners: TestData.testListeners
  )
  let viewModel = MuseViewModel(model: model)
    
  return MusicDisplayView(user: TestData.testUser)
    .environment(viewModel)
    .environmentObject(SpotifyController())
}
