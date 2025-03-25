import Foundation

// MARK: - MuseModel
/// Central data model managing user and listener states.
/// - Responsibilities:
///   - Fetches user/listener data from `MusicService`.
///   - Handles button-triggered actions (e.g., sharing tracks).
///   - Formats data for UI consumption.
@MainActor
final class MuseModel {
  // MARK: Properties
  private let musicService: MusicService
  var user: User
  var listeners: [Listener]
    
  // MARK: Initialization
  /// Initializes with a `MusicService` (defaults to mock for testing).
  init(musicService: MusicService = EmptyMusicService()) {
    self.musicService = musicService
    self.listeners = []
    self.user = Self.defaultUser
  }
    
  // MARK: Public Methods
  /// Updates the user's currently playing track.
  func updateListeningTo(_ track: SpotifyTrack?) {
    user.listeningTo = track
  }
  
  /// Injects test data for previews or unit testing.
  func setTestData(user: User, listeners: [Listener]) {
    self.user = user
    self.listeners = listeners
  }
    
  /// Fetches user and listener data asynchronously.
  func loadData() async throws {
    async let fetchedUser = musicService.fetchCurrentUser()
    async let fetchedListeners = musicService.fetchNearbyListeners()
    (self.user, self.listeners) = try await (fetchedUser, fetchedListeners)
  }
  
  /// Handles button actions for a specific listener.
  func handleButtonAction(for listener: Listener, type: ButtonType) async throws {
    guard let index = listeners.firstIndex(where: { $0.id == listener.id }) else {
      throw MuseError.listenerNotFound
    }
    var updatedListener = listeners[index]
    try await handleAction(type: type, for: &updatedListener)
    listeners[index] = updatedListener
  }
  
  // MARK: Helper Methods
  /// Resolves text for UI buttons.
  func textToDisplay(_ buttonType: ButtonType) -> String {
    switch buttonType {
    case .listen: return "Recommended a song"
    default: return "Listening nearby"
    }
  }
  
  /// Formats a listener's tracks for display.
  func listenerTracks(_ listener: Listener) -> [(
    track: SpotifyTrack?,
    header: String
  )] {
    var tracks = [(SpotifyTrack?, String)]()
    if let recommendation = listener.recommendedMe {
      tracks.append((recommendation, "Recommended Song"))
    }
    if let current = listener.listeningTo {
      tracks.append((current, "Now Listening"))
    }
    return tracks.isEmpty ? [(nil, "")] : tracks
  }
  
  /// Determines if a carousel should show for a listener.
  func shouldShowCarousel(_ listener: Listener) -> Bool {
    listener.recommendedMe != nil && listener.listeningTo != nil
  }
  
  /// Generates header text for the user's current state.
  func userHeader(_ user: User) -> String {
    user.listeningTo != nil ? "Now Playing" : ""
  }
}

// MARK: - Private Helpers
private extension MuseModel {
  static var defaultUser: User {
    User(
      id: "default-user",
      displayName: "Guest",
      images: [],
      listeningTo: nil
    )
  }
    
  /// Processes button actions for a listener.
  func handleAction(type: ButtonType, for listener: inout Listener) async throws {
    switch type {
    case .share:
      try await handleShareAction(for: &listener)
    case .listen:
      try await handleListenAction(for: &listener)
    default: break
    }
  }
    
  /// Shares the current track with a listener.
  func handleShareAction(for listener: inout Listener) async throws {
    guard let currentTrack = user.listeningTo else {
      throw MuseError.noTrackPlaying
    }
    try await musicService.shareTrack(currentTrack.uri, with: listener.id)
    listener.sentRecommendation = true
  }
    
  /// Plays a track recommended to the user.
  func handleListenAction(for listener: inout Listener) async throws {
    guard let track = listener.recommendedMe else {
      throw MuseError.noRecommendedTrack
    }
    try await musicService.playTrack(track.uri)
    listener.recommendedMe = nil
  }
}

// MARK: - MuseError
/// Custom errors for Muse model operations.
enum MuseError: Error {
  case listenerNotFound
  case noTrackPlaying
  case noRecommendedTrack
  case apiError(String)
    
  /// User-friendly error descriptions.
  var errorDescription: String? {
    switch self {
    case .listenerNotFound: return "Listener not found in current session"
    case .noTrackPlaying: return "No track currently playing"
    case .noRecommendedTrack: return "No recommended track available"
    case .apiError(let message): return "API Error: \(message)"
    }
  }
}
