import Foundation

struct TestData {
  // Base user profile with active listening context
  static let testUser = User(
    id: "mock-user-123",
    displayName: "Test User",
    images: [SpotifyImage(
      url: URL(  // Actual Spotify CDN URL pattern for image validation
        string: "https://i.scdn.co/image/ab67616d00001e02ff9ca10b55ce82ae553c8228"
              )!
    )],
    listeningTo: SpotifyTrack(
      uri: "spotify:track:mock123",
      name: "Sample Track",
      artists: [SpotifyArtist(id: "artist1", name: "Sample Artist")],
      album: SpotifyAlbum(images: [])
    )
  )
    
  // Spectrum of listener interaction states
  static let testListeners = [
    // Basic listener without activity
    Listener(
      id: "1",
      displayName: "Listener One",
      images: [SpotifyImage(
        url: URL(
          string: "https://i.scdn.co/image/ab67616d00001e02ff9ca10b55ce82ae553c8228"
        )!
      )],
      listeningTo: nil
    ),
    // Fully engaged listener with recommendations
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
        artists: [SpotifyArtist(id: "listening", name: "Sample Listening")],
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
        artists: [SpotifyArtist(id: "artist3", name: "Artist Three")],
        album: SpotifyAlbum(images: [])
      )
    ),
    // Sent recommendation to this listener without current activity
    Listener(
      id: "3",
      displayName: "Listener Three",
      images: [SpotifyImage(
        url: URL(
          string: "https://example.com/user3.jpg"
        )!
      )],
      listeningTo: nil,
      sentRecommendation: true
    )
  ]
}
