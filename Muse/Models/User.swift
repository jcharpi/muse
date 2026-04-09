import Foundation

// MARK: - User
/// The authenticated app user.
struct User: SpotifyAccount, MusicDisplayable {
  let id: String
  let displayName: String
  let images: [SpotifyImage]
  var listeningTo: SpotifyTrack?
  var reactionCount: Int

  init(
    id: String,
    displayName: String,
    images: [SpotifyImage],
    listeningTo: SpotifyTrack? = nil,
    reactionCount: Int = 0
  ) {
    self.id = id
    self.displayName = displayName
    self.images = images
    self.listeningTo = listeningTo
    self.reactionCount = reactionCount
  }

  /// Header shown above the album art on the Now Playing tab.
  var nowPlayingHeader: String {
    listeningTo != nil ? "Now Playing" : ""
  }
}
