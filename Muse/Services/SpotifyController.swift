import SwiftUI
import SpotifyiOS
import Combine

/// Manages all Spotify integration including:
/// - User authentication flow
/// - Music playback state tracking
/// - Album artwork retrieval
/// - Connection lifecycle management
///
/// Acts as bridge between Spotify iOS SDK and SwiftUI interface
@MainActor
final class SpotifyController: NSObject, ObservableObject {
  // MARK: - Configuration Properties
    
  /*
   Spotify developer credentials required for API access:
   - Client ID: Identifies our app to Spotify's servers
   - Redirect URL: Where Spotify sends users after login
   These values must match exactly what's registered in your Spotify Developer Dashboard
   */
  private let spotifyClientID = "05de78e3bdfb459983d1e6c548358be7"
  private let spotifyRedirectURL = URL(
    string: "spotify-ios-quick-start://spotify-login-callback"
  )!
    
  // MARK: - Player State
    
  /*
   Published properties that drive the UI:
   - currentTrack: Metadata about currently playing song
   - accessToken: Secure authentication token from Spotify
   - currentTrackImage: High-resolution album artwork
   These automatically update SwiftUI views when changed
   */
  @Published var currentTrack: SpotifyTrack?
  @Published var accessToken: String?
  @Published var currentTrackImage: UIImage?
    
  // MARK: - SDK Components
    
  /*
   Internal Spotify SDK management:
   - appStateSubscriptions: Tracks app foreground/background state
   - currentAlbumId: Prevents duplicate artwork downloads
   - hasInitialArtFetch: Flag for first-time setup
   - configuration: SDK setup with our credentials
   - appRemote: Main interface to Spotify app features
   */
  private var appStateSubscriptions = Set<AnyCancellable>()
  private var currentAlbumId = ""
  private var hasInitialArtFetch = false
    
  lazy private var configuration: SPTConfiguration = {
    SPTConfiguration(clientID: spotifyClientID, redirectURL: spotifyRedirectURL)
  }()
    
  lazy private var appRemote: SPTAppRemote = {
    let remote = SPTAppRemote(configuration: configuration, logLevel: .debug)
    remote.delegate = self
    return remote
  }()
    
  // MARK: - Lifecycle
    
  /// Sets up automatic connection management when app state changes
  override init() {
    super.init()
    setupAppStateObservers()
  }
}

// MARK: - Connection Management

/*
 Handles physical connection to Spotify service:
 - Automatically connects when app comes to foreground
 - Disconnects when app backgrounds
 - Manages connection state transitions
 */
extension SpotifyController {
  /// Establishes connection using either stored token or new authentication
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
    
  /// Listens for app state changes to maintain Spotify connection
  private func setupAppStateObservers() {
    NotificationCenter.default
      .publisher(for: UIApplication.didBecomeActiveNotification)
      .sink { [weak self] _ in self?.connect() }
      .store(in: &appStateSubscriptions)
        
    NotificationCenter.default
      .publisher(for: UIApplication.willResignActiveNotification)
      .sink { [weak self] _ in self?.disconnect() }
      .store(in: &appStateSubscriptions)
  }
}

// MARK: - Authentication

/*
 Manages OAuth2 authentication flow:
 1. Starts login process with Spotify app
 2. Handles callback URL with authentication tokens
 3. Stores access token for future sessions
 */
extension SpotifyController {
  /// Launches Spotify app for user login and authorization
  func authorize() {
    appRemote.authorizeAndPlayURI("")
  }
    
  /// Processes authentication response from Spotify
  /// - Parameter url: Callback URL containing authentication tokens
  func setAccessToken(from url: URL) {
    guard let parameters = appRemote.authorizationParameters(from: url) else {
      return
    }
        
    if let token = parameters[SPTAppRemoteAccessTokenKey] {
      appRemote.connectionParameters.accessToken = token
      accessToken = token
    } else if let error = parameters[SPTAppRemoteErrorDescriptionKey] {
      print("Authorization error: \(error)")
    }
  }
}

// MARK: - Music Data Handling

/*
 Processes real-time music playback information:
 - Tracks song changes
 - Extracts metadata (artist, album, track name)
 - Manages high-resolution artwork retrieval
 - Handles track history to prevent duplicate processing
 */
extension SpotifyController {
  /// Main entry point for processing playback updates
  private func handlePlayerStateUpdate(_ playerState: SPTAppRemotePlayerState) {
    let albumId = extractAlbumId(from: playerState.track)
    guard shouldFetchNewArtwork(for: albumId) else { return }
        
    currentAlbumId = albumId
    hasInitialArtFetch = true
        
    updateCurrentTrack(from: playerState)
    fetchTrackArtwork(for: playerState.track)
  }
    
  /// Extracts unique album identifier from Spotify track URI
  private func extractAlbumId(from track: SPTAppRemoteTrack) -> String {
    track.album.uri.components(separatedBy: ":").last ?? ""
  }
    
  /// Determines if artwork needs refresh
  private func shouldFetchNewArtwork(for albumId: String) -> Bool {
    albumId != currentAlbumId || !hasInitialArtFetch
  }
    
  /// Updates our track model with latest playback info
  private func updateCurrentTrack(from playerState: SPTAppRemotePlayerState) {
    currentTrack = SpotifyTrack(
      uri: playerState.track.uri,
      name: playerState.track.name,
      artists: [SpotifyArtist(name: playerState.track.artist.name)],
      album: SpotifyAlbum(images: [])
    )
  }
    
  /// Retrieves high-quality artwork using Spotify's native image API
  private func fetchTrackArtwork(for track: SPTAppRemoteTrack) {
    appRemote.imageAPI?.fetchImage(
      forItem: track,
      with: CGSize(width: 2000, height: 2000),
      callback: { [weak self] (image, error) in
        guard let self = self else { return }
                
        if let error = error {
          print("Artwork fetch error: \(error.localizedDescription)")
          return
        }
                
        guard let image = image as? UIImage else { return }
                
        DispatchQueue.main.async {
          self.currentTrackImage = image
          print("Loaded artwork dimensions: \(image.size)")
        }
      }
    )
  }
}

// MARK: - Spotify SDK Delegates

/*
 Handles low-level SDK events and errors:
 - Connection state changes
 - Player state updates
 - Error conditions
 These delegates are called by the Spotify SDK itself
 */
extension SpotifyController: SPTAppRemoteDelegate {
  // Successful connection handler
  nonisolated func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
    Task { @MainActor in
      print("Spotify connection established")
      setupPlayerStateSubscription()
    }
  }
    
  // Connection error handlers
  nonisolated func appRemote(
    _ appRemote: SPTAppRemote,
    didDisconnectWithError error: Error?
  ) {
    Task { @MainActor in
      handleConnectionError("disconnected", error: error)
    }
  }
    
  nonisolated func appRemote(
    _ appRemote: SPTAppRemote,
    didFailConnectionAttemptWithError error: Error?
  ) {
    Task { @MainActor in
      handleConnectionError("connection failed", error: error)
    }
  }

  // Central error processing
  @MainActor
  private func handleConnectionError(_ context: String, error: Error?) {
    print(
      "Spotify \(context): \(error?.localizedDescription ?? "Unknown error")"
    )
  }

  /// Sets up continuous player state monitoring
  private func setupPlayerStateSubscription() {
    appRemote.playerAPI?.delegate = self
    appRemote.playerAPI?
      .subscribe(
toPlayerState: { [weak self] (result, error) in
        if let error = error {
          print(
            "Player state subscription error: \(error.localizedDescription)"
          )
        } else {
          print("Subscribed to player state updates")
          self?.appRemote.playerAPI?.getPlayerState { _, _ in }
        }
})
  }
}

// MARK: - Player State Delegate

/// Receives real-time playback updates from Spotify
extension SpotifyController: SPTAppRemotePlayerStateDelegate {
  nonisolated func playerStateDidChange(
    _ playerState: SPTAppRemotePlayerState
  ) {
    Task { @MainActor in
      handlePlayerStateUpdate(playerState)
    }
  }
}
