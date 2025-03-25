import SwiftUI
import SpotifyiOS
import Combine

// MARK: - SpotifyController
/// Manages Spotify SDK integration including authentication, playback state, and artwork handling
@MainActor
final class SpotifyController: NSObject, ObservableObject {
    
  // MARK: - Configuration
  /// Spotify developer credentials (MUST match Spotify Dashboard settings)
  private let spotifyClientID = "05de78e3bdfb459983d1e6c548358be7"
  private let spotifyRedirectURL = URL(
    string: "spotify-ios-quick-start://spotify-login-callback"
  )!
    
  /// SDK configuration object - bridges SwiftUI and Spotify iOS SDK
  private lazy var configuration: SPTConfiguration = {
    SPTConfiguration(clientID: spotifyClientID, redirectURL: spotifyRedirectURL)
  }()
    
  // MARK: - Player State
  /// Published properties driving UI updates
  @Published var currentTrack: SpotifyTrack?      // Currently playing track metadata
  @Published var accessToken: String?             // OAuth2 access token
  @Published var currentTrackImage: UIImage?      // High-res artwork for current track
    
  // MARK: - SDK Components
  /// Primary interface to Spotify app features
  private lazy var appRemote: SPTAppRemote = {
    let remote = SPTAppRemote(configuration: configuration, logLevel: .debug)
    remote.delegate = self
    return remote
  }()
    
  /// Tracks current album ID to prevent duplicate artwork fetches
  private var currentAlbumId = ""
  private var cancellables = Set<AnyCancellable>()
    
  // MARK: - Lifecycle
  override init() {
    super.init()
    setupAppStateObservers()
  }
}

// MARK: - Connection Management
extension SpotifyController {
  /// Establishes connection using stored token or initiates auth flow
  func connect() {
    guard appRemote.connectionParameters.accessToken == nil else {
      appRemote.connect()
      return
    }
        
    if let accessToken = accessToken {
      appRemote.connectionParameters.accessToken = accessToken
      appRemote.connect()
    }
  }
    
  /// Safely terminates Spotify connection
  func disconnect() {
    guard appRemote.isConnected else { return }
    appRemote.disconnect()
  }
    
  /// Monitors app state changes to maintain connection
  private func setupAppStateObservers() {
    // Auto-connect when app enters foreground
    NotificationCenter.default
      .publisher(for: UIApplication.didBecomeActiveNotification)
      .sink { [weak self] _ in self?.connect() }
      .store(in: &cancellables)
        
    // Disconnect when app backgrounds
    NotificationCenter.default
      .publisher(for: UIApplication.willResignActiveNotification)
      .sink { [weak self] _ in self?.disconnect() }
      .store(in: &cancellables)
  }
}

// MARK: - Authentication
extension SpotifyController {
  /// Initiates Spotify OAuth2 flow through native app
  func authorize() {
    appRemote.authorizeAndPlayURI("")
  }
    
  /// Processes auth response from Spotify callback URL
  func setAccessToken(from url: URL) {
    guard let params = appRemote.authorizationParameters(from: url) else {
      return
    }
        
    if let token = params[SPTAppRemoteAccessTokenKey] {
      appRemote.connectionParameters.accessToken = token
      accessToken = token
    } else if let error = params[SPTAppRemoteErrorDescriptionKey] {
      print("Auth error: \(error)")
    }
  }
}

// MARK: - Playback State Handling
extension SpotifyController {
  /// Processes real-time player state updates from Spotify
  private func handlePlayerStateUpdate(_ playerState: SPTAppRemotePlayerState) {
    let albumId = extractAlbumId(from: playerState.track)
    guard shouldFetchNewArtwork(for: albumId) else { return }
        
    currentAlbumId = albumId
    updateCurrentTrack(from: playerState)
    fetchTrackArtwork(for: playerState.track)
  }
    
  /// Extracts unique album identifier from track URI
  private func extractAlbumId(from track: SPTAppRemoteTrack) -> String {
    track.album.uri.components(separatedBy: ":").last ?? ""
  }
    
  /// Determines if artwork needs refresh
  private func shouldFetchNewArtwork(for albumId: String) -> Bool {
    albumId != currentAlbumId
  }
    
  /// Updates track metadata model from SDK response
  private func updateCurrentTrack(from playerState: SPTAppRemotePlayerState) {
    currentTrack = SpotifyTrack(
      uri: playerState.track.uri,
      name: playerState.track.name,
      artists: [SpotifyArtist(name: playerState.track.artist.name)],
      album: SpotifyAlbum(images: [])
    )
  }
    
  /// Fetches high-res artwork using Spotify's native API
  private func fetchTrackArtwork(for track: SPTAppRemoteTrack) {
    appRemote.imageAPI?
      .fetchImage(forItem: track, with: CGSize(width: 2000, height: 2000)) {
        [weak self] (image, error) in
        guard let self else { return }
            
        if let error = error {
          print("Artwork error: \(error.localizedDescription)")
          return
        }
            
        guard let image = image as? UIImage else { return }
            
        DispatchQueue.main.async {
          self.currentTrackImage = image
        }
      }
  }
}

// MARK: - SDK Delegates
extension SpotifyController: SPTAppRemoteDelegate {
  nonisolated func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
    Task { @MainActor [weak self] in
      print("Spotify connection established")
      self?.setupPlayerStateSubscription()
    }
  }
    
  nonisolated func appRemote(
    _ appRemote: SPTAppRemote,
    didDisconnectWithError error: Error?
  ) {
    Task { @MainActor [weak self] in
      self?.handleConnectionError("disconnected", error: error)
    }
  }
    
  nonisolated func appRemote(
    _ appRemote: SPTAppRemote,
    didFailConnectionAttemptWithError error: Error?
  ) {
    Task { @MainActor [weak self] in
      self?.handleConnectionError("connection failed", error: error)
    }
  }
    
  private func handleConnectionError(_ context: String, error: Error?) {
    print(
      "Spotify \(context): \(error?.localizedDescription ?? "Unknown error")"
    )
  }
    
  /// Enables continuous player state monitoring
  private func setupPlayerStateSubscription() {
    appRemote.playerAPI?.delegate = self
    appRemote.playerAPI?
      .subscribe(toPlayerState: { [weak self] (result, error) in
        guard error == nil else { return }
        self?.appRemote.playerAPI?.getPlayerState { _, _ in }
      })
  }
}

extension SpotifyController: SPTAppRemotePlayerStateDelegate {
  nonisolated func playerStateDidChange(
    _ playerState: SPTAppRemotePlayerState
  ) {
    Task { @MainActor [weak self] in
      self?.handlePlayerStateUpdate(playerState)
    }
  }
}
