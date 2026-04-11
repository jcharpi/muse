import Foundation

// MARK: - MuseModel
/// Central data model — fetches user/listener data from the music service.
@MainActor
final class MuseModel {
  private let musicService: MusicService
  var user: User
  var listeners: [Listener]

  init(musicService: MusicService = MockMusicService()) {
    self.musicService = musicService
    self.listeners = []
    self.user = Self.defaultUser
  }

  // MARK: - Public Methods

  func updateListeningTo(_ track: SpotifyTrack?) {
    user.listeningTo = track
  }

  func loadData() async throws {
    async let fetchedUser = musicService.fetchCurrentUser()
    async let fetchedListeners = musicService.fetchNearbyListeners()
    (self.user, self.listeners) = try await (fetchedUser, fetchedListeners)
  }
}

// MARK: - Debug Helpers
#if DEBUG
extension MuseModel {
  func setTestData(user: User, listeners: [Listener]) {
    self.user = user
    self.listeners = listeners
  }
}
#endif

// MARK: - Private Helpers
private extension MuseModel {
  static var defaultUser: User {
    User(id: "default-user", displayName: "Guest", images: [])
  }
}

// MARK: - MuseError
// NOTE: currently unused — kept as scaffolding for MultipeerConnectivity error handling
enum MuseError: LocalizedError {
  case apiError(String)
  case listenerNotFound

  var errorDescription: String? {
    switch self {
    case .apiError(let message):     return "API Error: \(message)"
    case .listenerNotFound:          return "Listener not found in current session"
    }
  }
}
