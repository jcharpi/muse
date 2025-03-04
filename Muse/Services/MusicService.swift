import Foundation

protocol MusicService {
  func fetchCurrentUser() async throws -> User
  func fetchNearbyListeners() async throws -> [Listener]
  func shareTrack(_ trackId: String, with userId: String) async throws
  func playTrack(_ trackId: String) async throws
}

// Neutral implementation for unauthenticated states
struct EmptyMusicService: MusicService {
  // Default user prevents nil states in UI components
  func fetchCurrentUser() async throws -> User {
    return User(
      id: "empty-user",
      displayName: "Guest",
      images: [],
      listeningTo: nil
    )
  }
    
  // Silent service for inactive functionality
  func fetchNearbyListeners() async throws -> [Listener] { [] }
  func shareTrack(_ trackId: String, with userId: String) async throws {}
  func playTrack(_ trackId: String) async throws {}
}

// Development service with simulated network characteristics
struct MockMusicService: MusicService {
  func fetchCurrentUser() async throws -> User {
    return TestData.testUser
  }
    
  func fetchNearbyListeners() async throws -> [Listener] {
    return TestData.testListeners
  }
    
  // Network latency simulation with success outcomes
  func shareTrack(_ trackId: String, with userId: String) async throws {
    try await Task.sleep(nanoseconds: 300_000_000) // 300ms delay
    print("Mock: Shared track \(trackId) with user \(userId)")
  }
    
  // Playback initiation simulation
  func playTrack(_ trackId: String) async throws {
    try await Task.sleep(nanoseconds: 300_000_000)  // 300ms delay
    print("Mock: Playing track \(trackId)")
  }
}
