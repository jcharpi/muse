import Foundation

/// Shared shape for Spotify user accounts (User and Listener).
protocol SpotifyAccount: Codable, Equatable, Identifiable {
  var displayName: String { get }
  var id: String { get }
  var images: [SpotifyImage] { get }
}

/// An entity whose current music playback can be displayed.
protocol MusicDisplayable {
  var listeningTo: SpotifyTrack? { get }
}
