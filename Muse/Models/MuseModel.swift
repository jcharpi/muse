import Foundation

// MARK: - MuseModel
/// Central data model — fetches user/listener data and handles button actions.
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

  func setTestData(user: User, listeners: [Listener]) {
    self.user = user
    self.listeners = listeners
  }

  func loadData() async throws {
    async let fetchedUser = musicService.fetchCurrentUser()
    async let fetchedListeners = musicService.fetchNearbyListeners()
    (self.user, self.listeners) = try await (fetchedUser, fetchedListeners)
  }

  func handleButtonAction(for listener: Listener, type: ButtonType) async throws {
    guard let index = listeners.firstIndex(where: { $0.id == listener.id }) else {
      throw MuseError.listenerNotFound
    }
    var updated = listeners[index]
    switch type {
    case .react:
      try await musicService.sendReaction(to: updated.id)
      updated.hasReacted = true
      updated.reactionCount += 1
    case .reacted:
      return
    }
    listeners[index] = updated
  }
}

// MARK: - Private Helpers
private extension MuseModel {
  static var defaultUser: User {
    User(id: "default-user", displayName: "Guest", images: [])
  }
}

// MARK: - MuseError
enum MuseError: Error {
  case listenerNotFound
  case apiError(String)

  var errorDescription: String? {
    switch self {
    case .listenerNotFound: return "Listener not found in current session"
    case .apiError(let msg): return "API Error: \(msg)"
    }
  }
}
