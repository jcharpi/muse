import Foundation

// MARK: - TestData
/// Provides mock data for SwiftUI previews and testing.
struct TestData {
  /// Mock user with active listening context.
  static let testUser = User(
    id: "mock-user-123",
    displayName: "Test User",
    images: [SpotifyImage(
      url: URL(
        string: "https://i.scdn.co/image/ab67616d00001e02ff9ca10b55ce82ae553c8228"
      )!
    )],
    listeningTo: SpotifyTrack(
      uri: "spotify:track:mock123",
      name: "Sample Track",
      artists: [SpotifyArtist(name: "Sample Artist")],
      album: SpotifyAlbum(images: [])
    )
  )
    
  /// Array of listeners with varying interaction states.
  static let testListeners = [
    Listener(
      id: "1",
      displayName: "Listener One",
      images: [SpotifyImage(
        url: URL(
          string: "https://i.scdn.co/image/ab67616d00001e02ff9ca10b55ce82ae553c8228"
        )!
      )]
    ),
    Listener(
      id: "2",
      displayName: "Listener Two",
      images: [SpotifyImage(
        url: URL(
          string: "https://example.com/user2.jpg"
        )!
      )],
      listeningTo: SpotifyTrack(
        uri: "spotify:track:mock1",
        name: "Sample Listening",
        artists: [SpotifyArtist(name: "Sample Listening")],
        album: SpotifyAlbum(
images: [SpotifyImage(
  url: URL(
    string: "https://i.scdn.co/image/ab67616d00001e02ff9ca10b55ce82ae553c8228"
  )!
)]
        )
      ),
      recommendedMe: SpotifyTrack(
        uri: "spotify:track:recommended",
        name: "Recommended Track",
        artists: [SpotifyArtist(name: "Artist Three")],
        album: SpotifyAlbum(images: [])
      )
    ),
    Listener(
      id: "3",
      displayName: "Listener Three",
      images: [SpotifyImage(
        url: URL(
          string: "https://example.com/user3.jpg"
        )!
      )],
      sentRecommendation: true
    )
  ]
}
