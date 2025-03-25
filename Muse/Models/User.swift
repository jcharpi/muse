import Foundation

// MARK: - User
/// Represents the current application user, conforming to Spotify and music display protocols.
struct User: SpotifyAccount, MusicDisplayable {
  // MARK: Properties
  let id: String
  let displayName: String
  let images: [SpotifyImage]
  var listeningTo: SpotifyTrack? // Current playback track
    
  // MARK: Initialization
  public init(
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
}
