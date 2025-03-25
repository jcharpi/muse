import Foundation

// MARK: - SpotifyTrack
/// Represents a track from Spotify, including metadata and album art URLs.
/// - Note: Album art is fetched asynchronously via `SpotifyImage` URLs.
struct SpotifyTrack: Codable, Equatable {
  let uri: String // Unique Spotify identifier
  let name: String
  let artists: [SpotifyArtist]
  var album: SpotifyAlbum // Contains URLs for album art
}

// MARK: - SpotifyAlbum
/// Contains album metadata, including cover art URLs.
struct SpotifyAlbum: Codable, Equatable {
  var images: [SpotifyImage] // Ordered by size (largest first)
}

// MARK: - SpotifyArtist
/// Represents an artist associated with a track.
struct SpotifyArtist: Codable, Equatable {
  let name: String
}

// MARK: - SpotifyImage
/// Represents an image URL with optional dimensions.
struct SpotifyImage: Codable, Equatable {
  let url: URL
  let width: Int?
  let height: Int?
    
  init(url: URL, width: Int? = nil, height: Int? = nil) {
    self.url = url
    self.width = width
    self.height = height
  }
}
