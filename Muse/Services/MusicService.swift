import Foundation

// MARK: - MusicService Protocol
/// Core music interaction interface. Implementations handle authentication state internally.
/// `fetchNearbyListeners` only returns listeners actively playing a track.
protocol MusicService {
  func fetchCurrentUser() async throws -> User
  func fetchNearbyListeners() async throws -> [Listener]
}

// MARK: - EmptyMusicService
/// No-op service for unauthenticated state. Returns a guest user and no listeners.
struct EmptyMusicService: MusicService {
  func fetchCurrentUser() async throws -> User {
    User(id: "empty-user", displayName: "Guest", images: [])
  }

  func fetchNearbyListeners() async throws -> [Listener] { [] }
}

// MARK: - MockMusicService
/// Development service backed by TestData.
struct MockMusicService: MusicService {
  func fetchCurrentUser() async throws -> User { TestData.testUser }
  func fetchNearbyListeners() async throws -> [Listener] { TestData.testListeners }
}
