import Foundation

// MARK: - SpotifyAccount
/// Defines properties required for a Spotify user account.
/// - Conforming Types: `User`, `Listener`
protocol SpotifyAccount: Codable, Equatable, Identifiable {
  var displayName: String { get }
  var images: [SpotifyImage] { get }
  var id: String { get }
}

// MARK: - MusicDisplayable
/// Indicates an entity can display current music playback.
/// - Conforming Types: `User`, `Listener`
protocol MusicDisplayable {
  var listeningTo: SpotifyTrack? { get }
}
