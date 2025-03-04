import Foundation

protocol SpotifyAccount: Codable, Equatable, Identifiable {
  var displayName: String { get }
  var images: [SpotifyImage] { get }
  var id: String { get }
}

protocol MusicDisplayable {
  var listeningTo: SpotifyTrack? { get }
}
