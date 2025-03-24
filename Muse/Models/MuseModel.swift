@MainActor
final class MuseModel {
  private let musicService: MusicService
  // Main actor-isolated mutable state
  var user: User
  var listeners: [Listener]
    
  // Testable initialization with mock defaults
  init(musicService: MusicService = MockMusicService()) {
    self.musicService = musicService
    self.listeners = []
    // Fallback user prevents optional state
    self.user = Self.defaultUser
  }
    
  // Allow the model to update the user's current track
  func updateListeningTo(_ track: SpotifyTrack?) {
    user.listeningTo = track
  }
  
  // Test harness injection point
  func setTestData(user: User, listeners: [Listener]) {
    self.user = user
    self.listeners = listeners
  }
    
  // Parallel data hydration pattern
  func loadData() async throws {
    async let fetchedUser = musicService.fetchCurrentUser()
    async let fetchedListeners = musicService.fetchNearbyListeners()
        
    // Atomic state update prevents partial renders
    (self.user, self.listeners) = try await (fetchedUser, fetchedListeners)
  }
    
  // State mutation with index safety
  func handleButtonAction(for listener: Listener, type: ButtonType) async throws {
    guard let index = listeners.firstIndex(where: { $0.id == listener.id }) else {
      throw MuseError.listenerNotFound
    }
        
    // Copy-on-write pattern for thread safety
    var updatedListener = listeners[index]
    try await handleAction(type: type, for: &updatedListener)
    listeners[index] = updatedListener
  }
    
  // Localization-ready string resolver
  func textToDisplay(_ buttonType: ButtonType) -> String {
    switch buttonType {
    case .listen: return "Recommended a song"  // Action-oriented phrasing
    default: return "Listening nearby"  // Fallback preserves UI stability
    }
  }
  
  // Unified track data formatter
  func listenerTracks(_ listener: Listener) -> [(
    track: SpotifyTrack?,
    header: String
  )] {
    var tracks = [(SpotifyTrack?, String)]()
    // Recommendation prioritization
    if let recommendation = listener.recommendedMe {
      tracks.append((recommendation, "Recommended Song"))
    }
    // Current activity secondary position
    if let current = listener.listeningTo {
      tracks.append((current, "Now Listening"))
    }
    // Graceful empty state handling
    return tracks.isEmpty ? [(nil, "No Track")] : tracks
  }
  
  // Conditional UI display logic
  func shouldShowCarousel(_ listener: Listener) -> Bool {
    // Requires dual content for carousel activation
    listener.recommendedMe != nil && listener.listeningTo != nil
  }
  
  // Dynamic header text resolver
  func userHeader(_ user: User) -> String {
    user.listeningTo != nil ? "Now Playing" : "No Track"
  }
}

// State factory methods
private extension MuseModel {
  static var defaultUser: User {
    User(
      id: "default-user",
      displayName: "Guest",
      images: [],
      listeningTo: nil
    )
  }
    
  func handleAction(type: ButtonType, for listener: inout Listener) async throws {
    switch type {
    case .share:
      try await handleShareAction(for: &listener)
    case .listen:
      try await handleListenAction(for: &listener)
    default:  // Future action slot
      break
    }
  }
    
  func handleShareAction(for listener: inout Listener) async throws {
    guard let currentTrack = user.listeningTo else {
      throw MuseError.noTrackPlaying  // Prevents empty shares
    }
    try await musicService.shareTrack(currentTrack.uri, with: listener.id)
    // Acknowledgement flag update
    listener.sentRecommendation = true
  }
    
  func handleListenAction(for listener: inout Listener) async throws {
    guard let track = listener.recommendedMe else {
      throw MuseError.noRecommendedTrack
    }
    try await musicService.playTrack(track.uri)
    listener.recommendedMe = nil
  }
}

enum MuseError: Error {
  case listenerNotFound  // Index validation failure
  case noTrackPlaying  // Precondition violation
  case noRecommendedTrack  // State consistency error
  case apiError(String)  // Network failure container
    
  // User-facing message resolver
  var errorDescription: String? {
    switch self {
    case .listenerNotFound:
      return "Listener not found in current session"  // Session boundary context
    case .noTrackPlaying:
      return "No track currently playing"  // Action availability guard
    case .noRecommendedTrack:
      return "No recommended track available"  // State expectation
    case .apiError(let message):
      return "API Error: \(message)"  // Upstream error surfacing
    }
  }
}
