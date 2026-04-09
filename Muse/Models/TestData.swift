import Foundation

// MARK: - TestData
/// Mock data for SwiftUI previews and development.
struct TestData {
  static let testUser = User(
    id: "mock-user-123",
    displayName: "Test User",
    images: [SpotifyImage(url: URL(string: "https://i.scdn.co/image/ab67616d00001e02ff9ca10b55ce82ae553c8228")!)],
    listeningTo: SpotifyTrack(
      uri: "spotify:track:mock123",
      name: "Sample Track",
      artists: [SpotifyArtist(name: "Sample Artist")],
      album: SpotifyAlbum(images: [])
    ),
    reactionCount: 3
  )

  static let testListeners: [Listener] = [
    // 2 reactions, not yet reacted by current user
    Listener(
      id: "1",
      displayName: "Listener One",
      images: [SpotifyImage(url: URL(string: "https://i.scdn.co/image/ab67616d00001e02ff9ca10b55ce82ae553c8228")!)],
      listeningTo: SpotifyTrack(
        uri: "spotify:track:mock1",
        name: "Sample Listening",
        artists: [SpotifyArtist(name: "Sample Artist")],
        album: SpotifyAlbum(images: [
          SpotifyImage(url: URL(string: "https://i.scdn.co/image/ab67616d00001e02ff9ca10b55ce82ae553c8228")!)
        ])
      ),
      reactionCount: 2,
      hasReacted: false
    ),
    // 5 reactions, already reacted
    Listener(
      id: "2",
      displayName: "Listener Two",
      images: [SpotifyImage(url: URL(string: "https://example.com/user2.jpg")!)],
      listeningTo: SpotifyTrack(
        uri: "spotify:track:mock2",
        name: "Another Track",
        artists: [SpotifyArtist(name: "Artist Two")],
        album: SpotifyAlbum(images: [])
      ),
      reactionCount: 5,
      hasReacted: true
    ),
    // 0 reactions, no track playing
    Listener(
      id: "3",
      displayName: "Listener Three",
      images: [SpotifyImage(url: URL(string: "https://example.com/user3.jpg")!)],
      reactionCount: 0,
      hasReacted: false
    )
  ]
}
