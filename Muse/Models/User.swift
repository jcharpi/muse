import Foundation

// MARK: - User
/// The authenticated app user.
struct User: SpotifyAccount, MusicDisplayable {
  let id: String
  let displayName: String
  let images: [SpotifyImage]
  var listeningTo: SpotifyTrack?

  /// Header shown above the album art on the Now Playing section.
  var nowPlayingHeader: String {
    listeningTo != nil ? "Now Playing" : ""
  }
}
