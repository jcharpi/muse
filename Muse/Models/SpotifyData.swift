import Foundation

protocol SpotifyAccount: Codable, Equatable, Identifiable {
  var displayName: String { get }
  var images: [SpotifyImage] { get }
  var id: String { get }
}

struct SpotifyTrack: Codable, Equatable {
  let uri: String
  let name: String
  let artists: [SpotifyArtist]
  let album: SpotifyAlbum
}

struct SpotifyAlbum: Codable, Equatable {
  let images: [SpotifyImage]
}

struct SpotifyArtist: Codable, Equatable {
  let id: String
  let name: String
}

struct SpotifyImage: Codable, Equatable {
  let url: URL
  var width: Int = 300
  var height: Int = 300
}


