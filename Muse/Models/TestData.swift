import Foundation

// MARK: - TestData
/// Mock data for SwiftUI previews and development.
struct TestData {
  static let testUser = User(
    id: "mock-user-123",
    displayName: "Test User",
    images: [SpotifyImage(url: URL(string: "https://i.scdn.co/image/ab67616d00001e02ff9ca10b55ce82ae553c8228")!)],
    listeningTo: SpotifyTrack(
      uri: "spotify:track:0VjIjW4GlUZAMYd2vXMi3b",
      name: "Blinding Lights",
      artists: [SpotifyArtist(name: "The Weeknd")],
      album: SpotifyAlbum(images: [
        SpotifyImage(url: URL(string: "https://i.scdn.co/image/ab67616d00001e028863bc11d2aa12b54f5aeb36")!)
      ])
    )
  )

  static let testListeners: [Listener] = [
    Listener(
      id: "1",
      displayName: "Listener One",
      images: [SpotifyImage(url: URL(string: "https://i.scdn.co/image/ab67616d00001e02ff9ca10b55ce82ae553c8228")!)],
      listeningTo: SpotifyTrack(
        uri: "spotify:track:2qSkIjg1o9h3YT9RAgYN75",
        name: "Espresso",
        artists: [SpotifyArtist(name: "Sabrina Carpenter")],
        album: SpotifyAlbum(images: [
          SpotifyImage(url: URL(string: "https://i.scdn.co/image/ab67616d00001e02659cd4673230913b3918e0d5")!)
        ])
      )
    ),
    Listener(
      id: "2",
      displayName: "Listener Two",
      images: [SpotifyImage(url: URL(string: "https://example.com/user2.jpg")!)],
      listeningTo: SpotifyTrack(
        uri: "spotify:track:6AI3ezQ4o3HUoP6Dhudph3",
        name: "Not Like Us",
        artists: [SpotifyArtist(name: "Kendrick Lamar")],
        album: SpotifyAlbum(images: [
          SpotifyImage(url: URL(string: "https://i.scdn.co/image/ab67616d00001e021ea0c62b2339cbf493a999ad")!)
        ])
      )
    ),
    Listener(
      id: "3",
      displayName: "Listener Three",
      images: [SpotifyImage(url: URL(string: "https://example.com/user3.jpg")!)],
      listeningTo: SpotifyTrack(
        uri: "spotify:track:2plbrEY59IikOBgBGLjaoe",
        name: "Die With A Smile",
        artists: [SpotifyArtist(name: "Lady Gaga"), SpotifyArtist(name: "Bruno Mars")],
        album: SpotifyAlbum(images: [
          SpotifyImage(url: URL(string: "https://i.scdn.co/image/ab67616d00001e0282ea2e9e1858aa012c57cd45")!)
        ])
      )
    ),
    Listener(
      id: "4",
      displayName: "Listener Four",
      images: [SpotifyImage(url: URL(string: "https://example.com/user4.jpg")!)],
      listeningTo: SpotifyTrack(
        uri: "spotify:track:5vNRhkKd0yEAg8suGBpjeY",
        name: "APT.",
        artists: [SpotifyArtist(name: "ROSÉ"), SpotifyArtist(name: "Bruno Mars")],
        album: SpotifyAlbum(images: [
          SpotifyImage(url: URL(string: "https://i.scdn.co/image/ab67616d00001e0246085aa1855bd888abc51a5a")!)
        ])
      )
    ),
    Listener(
      id: "5",
      displayName: "Listener Five",
      images: [SpotifyImage(url: URL(string: "https://example.com/user5.jpg")!)],
      listeningTo: SpotifyTrack(
        uri: "spotify:track:6dOtVTDdiauQNBQEDOtlAB",
        name: "BIRDS OF A FEATHER",
        artists: [SpotifyArtist(name: "Billie Eilish")],
        album: SpotifyAlbum(images: [
          SpotifyImage(url: URL(string: "https://i.scdn.co/image/ab67616d00001e0271d62ea7ea8a5be92d3c1f62")!)
        ])
      )
    ),
    Listener(
      id: "6",
      displayName: "Listener Six",
      images: [SpotifyImage(url: URL(string: "https://example.com/user6.jpg")!)],
      listeningTo: SpotifyTrack(
        uri: "spotify:track:0VjIjW4GlUZAMYd2vXMi3b",
        name: "Blinding Lights",
        artists: [SpotifyArtist(name: "The Weeknd")],
        album: SpotifyAlbum(images: [
          SpotifyImage(url: URL(string: "https://i.scdn.co/image/ab67616d00001e028863bc11d2aa12b54f5aeb36")!)
        ])
      )
    )
  ]
}
