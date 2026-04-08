import Foundation

// MARK: - Listener
/// A nearby user who can share and receive music recommendations.
struct Listener: SpotifyAccount, MusicDisplayable {
  let id: String
  let displayName: String
  let images: [SpotifyImage]
  var listeningTo: SpotifyTrack?
  var recommendedMe: SpotifyTrack?
  var sentRecommendation: Bool

  init(
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

  // MARK: - Computed Properties

  /// Which action button to show based on interaction state.
  var buttonToShow: ButtonType {
    if recommendedMe != nil { return .listen }
    if sentRecommendation { return .shared }
    return .share
  }

  /// Ordered track data for display (recommendation first, then now-playing).
  var tracks: [(track: SpotifyTrack?, header: String)] {
    var result: [(SpotifyTrack?, String)] = []
    if let rec = recommendedMe { result.append((rec, "Recommended Song")) }
    if let cur = listeningTo { result.append((cur, "Now Listening")) }
    return result.isEmpty ? [(nil, "")] : result
  }

  /// True when both a recommendation and a now-playing track exist (triggers carousel).
  var showsCarousel: Bool {
    recommendedMe != nil && listeningTo != nil
  }
}
