import Foundation

// MARK: - MusicService Protocol
/// Defines core music interaction capabilities required by the app
/// - Note: Implementations should handle authentication state internally
protocol MusicService {
  /// Fetches authenticated user's profile
  func fetchCurrentUser() async throws -> User
  
  /// Retrieves nearby users with music sharing capabilities
  func fetchNearbyListeners() async throws -> [Listener]
  
  /// Shares a track with another user
  /// - Parameters:
  ///   - trackId: Spotify URI of track to share
  ///   - userId: Recipient's user identifier
  func shareTrack(_ trackId: String, with userId: String) async throws
  
  /// Initiates playback of a specific track
  /// - Parameter trackId: Spotify URI of track to play
  func playTrack(_ trackId: String) async throws
}

// MARK: - EmptyMusicService
/// Neutral implementation for unauthenticated states
/// - Provides default values to prevent nil states in UI components
struct EmptyMusicService: MusicService {
  func fetchCurrentUser() async throws -> User {
    User(
      id: "empty-user",
      displayName: "Guest",
      images: [],
      listeningTo: nil
    )
  }
  
  func fetchNearbyListeners() async throws -> [Listener] {
    TestData.testListeners
  }
  
  func shareTrack(_ trackId: String, with userId: String) async throws {
    // No-op for unauthenticated state
  }
  
  func playTrack(_ trackId: String) async throws {
    // No-op for unauthenticated state
  }
}

// MARK: - MockMusicService
/// Development service with simulated network characteristics
/// - Uses test data for previews and prototyping
struct MockMusicService: MusicService {
  func fetchCurrentUser() async throws -> User {
    TestData.testUser
  }
  
  func fetchNearbyListeners() async throws -> [Listener] {
    TestData.testListeners
  }
  
  func shareTrack(_ trackId: String, with userId: String) async throws {
    try await Task.sleep(nanoseconds: 300_000_000) // Simulate network latency
    print("Mock: Shared track \(trackId) with user \(userId)")
  }
  
  func playTrack(_ trackId: String) async throws {
    try await Task.sleep(nanoseconds: 300_000_000)
    print("Mock: Playing track \(trackId)")
  }
}
