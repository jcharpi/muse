import Foundation

// MARK: - Listener
/// Represents a nearby user who can share/receive music recommendations.
/// Conforms to:
/// - `SpotifyAccount`: Provides Spotify profile data.
/// - `MusicDisplayable`: Allows display of current listening activity.
struct Listener: SpotifyAccount, MusicDisplayable {
  // MARK: Properties
  let id: String
  let displayName: String
  let images: [SpotifyImage]
  var listeningTo: SpotifyTrack? // Current playback track
  var recommendedMe: SpotifyTrack? // Track recommended to the current user
  var sentRecommendation: Bool // Flag if a recommendation was sent to this listener
    
  // MARK: Initialization
  /// Public initializer for testing and SwiftUI previews.
  public init(
    id: String,
    displayName: String,
    images: [SpotifyImage],
    listeningTo: SpotifyTrack? = nil,
    recommendedMe: SpotifyTrack? = nil,
    sentRecommendation: Bool = false
  ) {
    self.id = id
    self.displayName = displayName
    self.images = images
    self.listeningTo = listeningTo
    self.recommendedMe = recommendedMe
    self.sentRecommendation = sentRecommendation
  }
    
  // MARK: Computed Properties
  /// Determines which button type to display based on interaction state.
  var buttonToShow: ButtonType {
    if recommendedMe != nil {
      return .listen
    } else if sentRecommendation {
      return .shared
    } else {
      return .share
    }
  }
}
