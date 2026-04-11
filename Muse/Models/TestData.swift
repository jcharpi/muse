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
    )
  )

  static let testListeners: [Listener] = [
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
      )
    ),
    Listener(
      id: "2",
      displayName: "Listener Two",
      images: [SpotifyImage(url: URL(string: "https://example.com/user2.jpg")!)],
      listeningTo: SpotifyTrack(
        uri: "spotify:track:mock2",
        name: "Another Track",
        artists: [SpotifyArtist(name: "Artist Two")],
        album: SpotifyAlbum(images: [])
      )
    ),
    Listener(
      id: "3",
      displayName: "Listener Three",
      images: [SpotifyImage(url: URL(string: "https://example.com/user3.jpg")!)],
      listeningTo: SpotifyTrack(
        uri: "spotify:track:mock3",
        name: "Blinding Lights",
        artists: [SpotifyArtist(name: "The Weeknd")],
        album: SpotifyAlbum(images: [])
      )
    ),
    Listener(
      id: "4",
      displayName: "Listener Four",
      images: [SpotifyImage(url: URL(string: "https://example.com/user4.jpg")!)],
      listeningTo: SpotifyTrack(
        uri: "spotify:track:mock4",
        name: "Espresso",
        artists: [SpotifyArtist(name: "Sabrina Carpenter")],
        album: SpotifyAlbum(images: [])
      )
    ),
    Listener(
      id: "5",
      displayName: "Listener Five",
      images: [SpotifyImage(url: URL(string: "https://example.com/user5.jpg")!)],
      listeningTo: SpotifyTrack(
        uri: "spotify:track:mock5",
        name: "Not Like Us",
        artists: [SpotifyArtist(name: "Kendrick Lamar")],
        album: SpotifyAlbum(images: [])
      )
    ),
    Listener(
      id: "6",
      displayName: "Listener Six",
      images: [SpotifyImage(url: URL(string: "https://example.com/user6.jpg")!)],
      listeningTo: SpotifyTrack(
        uri: "spotify:track:mock6",
        name: "Die With A Smile",
        artists: [SpotifyArtist(name: "Lady Gaga"), SpotifyArtist(name: "Bruno Mars")],
        album: SpotifyAlbum(images: [])
      )
    )
  ]
}
