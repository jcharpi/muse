import Foundation

// MARK: - Listener
/// A nearby user whose music activity can be seen.
struct Listener: SpotifyAccount, MusicDisplayable {
  let id: String
  let displayName: String
  let images: [SpotifyImage]
  var listeningTo: SpotifyTrack?
}
