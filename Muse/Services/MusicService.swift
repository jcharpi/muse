import Foundation

// MARK: - MusicService Protocol
/// Core music interaction interface. Implementations handle authentication state internally.
protocol MusicService {
  func fetchCurrentUser() async throws -> User
  func fetchNearbyListeners() async throws -> [Listener]
  func sendReaction(to userId: String) async throws
}

// MARK: - EmptyMusicService
/// No-op service for unauthenticated state. Returns a guest user and no listeners.
struct EmptyMusicService: MusicService {
  func fetchCurrentUser() async throws -> User {
    User(id: "empty-user", displayName: "Guest", images: [])
  }

  func fetchNearbyListeners() async throws -> [Listener] { [] }
  func sendReaction(to userId: String) async throws {}
}

// MARK: - MockMusicService
/// Development service with simulated latency, backed by TestData.
struct MockMusicService: MusicService {
  func fetchCurrentUser() async throws -> User { TestData.testUser }
  func fetchNearbyListeners() async throws -> [Listener] { TestData.testListeners }

  func sendReaction(to userId: String) async throws {
    try await Task.sleep(nanoseconds: 300_000_000)
    print("Mock: Sent reaction to user \(userId)")
  }
}
