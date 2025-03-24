import Foundation

struct SpotifyTrack: Codable, Equatable {
  let uri: String // Spotify URI for playback/actions
  let name: String
  let artists: [SpotifyArtist]
  let album: SpotifyAlbum // Contains cover art images
}

struct SpotifyAlbum: Codable, Equatable {
  let images: [SpotifyImage]  // First image is typically largest cover art
}

struct SpotifyArtist: Codable, Equatable {
  let name: String
}

struct SpotifyImage: Codable, Equatable {
  let url: URL
  let width: Int? // Optional for mock data/flexible API responses
  let height: Int?
    
  init(url: URL, width: Int? = nil, height: Int? = nil) {
    self.url = url
    self.width = width
    self.height = height
  }
}
