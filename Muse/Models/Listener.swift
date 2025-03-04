import Foundation

struct Listener: SpotifyAccount, MusicDisplayable {
  let id: String
  let displayName: String
  let images: [SpotifyImage]
  var listeningTo: SpotifyTrack?
  var recommendedMe: SpotifyTrack?
  var sentRecommendation: Bool
    
  // Public initializer for testing and previews
  public init(
    id: String,
    displayName: String,
    images: [SpotifyImage],
    listeningTo: SpotifyTrack? = nil,
    /// Sent me a recommendation
    recommendedMe: SpotifyTrack? = nil,
    /// Sent them a recommendation
    sentRecommendation: Bool = false
  ) {
    self.id = id
    self.displayName = displayName
    self.images = images
    self.listeningTo = listeningTo
    self.recommendedMe = recommendedMe
    self.sentRecommendation = sentRecommendation
  }
    
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
