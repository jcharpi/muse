import Foundation

// MARK: - User
/// The authenticated app user.
struct User: SpotifyAccount, MusicDisplayable {
  let id: String
  let displayName: String
  let images: [SpotifyImage]
  var listeningTo: SpotifyTrack?

  init(
    id: String,
    displayName: String,
    images: [SpotifyImage],
    listeningTo: SpotifyTrack? = nil
  ) {
    self.id = id
    self.displayName = displayName
    self.images = images
    self.listeningTo = listeningTo
  }

  /// Header shown above the album art on the Now Playing tab.
  var nowPlayingHeader: String {
    listeningTo != nil ? "Now Playing" : ""
  }
}
