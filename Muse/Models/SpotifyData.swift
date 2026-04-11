import Foundation

struct SpotifyTrack: Codable, Equatable {
  let uri: String
  let name: String
  let artists: [SpotifyArtist]
  var album: SpotifyAlbum
}

struct SpotifyAlbum: Codable, Equatable {
  var images: [SpotifyImage] // ordered largest to smallest
}

struct SpotifyArtist: Codable, Equatable {
  let name: String
}

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
