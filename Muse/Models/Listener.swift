import Foundation

// MARK: - Listener
/// A nearby user whose music activity can be seen and reacted to.
struct Listener: SpotifyAccount, MusicDisplayable {
  let id: String
  let displayName: String
  let images: [SpotifyImage]
  var listeningTo: SpotifyTrack?
  var reactionCount: Int
  var hasReacted: Bool

  init(
    id: String,
    displayName: String,
    images: [SpotifyImage],
    listeningTo: SpotifyTrack? = nil,
    reactionCount: Int = 0,
    hasReacted: Bool = false
  ) {
    self.id = id
    self.displayName = displayName
    self.images = images
    self.listeningTo = listeningTo
    self.reactionCount = reactionCount
    self.hasReacted = hasReacted
  }

  var buttonToShow: ButtonType {
    hasReacted ? .reacted : .react
  }
}
