import SwiftUI
import SpotifyiOS
import Combine

/// Main controller class for handling Spotify integration and playback management
@MainActor
final class SpotifyController: NSObject, ObservableObject {
  // MARK: - Spotify Configuration Properties
  let spotifyClientID = "05de78e3bdfb459983d1e6c548358be7"
  let spotifyRedirectURL = URL(
    string: "spotify-ios-quick-start://spotify-login-callback"
  )!

  // MARK: - Player State Properties
  @Published var currentTrack: SpotifyTrack?
  @Published var accessToken: String?
  @Published var currentTrackImage: UIImage?
    
  // MARK: - Spotify SDK Components
  private var connectCancellable: AnyCancellable?
  private var disconnectCancellable: AnyCancellable?
    
  lazy var configuration: SPTConfiguration = {
    let config = SPTConfiguration(
      clientID: spotifyClientID,
      redirectURL: spotifyRedirectURL
    )
    config.tokenSwapURL = URL(
      string: "https://your-token-swap-service.com"
    ) // Optional for token refresh
    config.tokenRefreshURL = URL(
      string: "https://your-token-refresh-service.com"
    ) // Optional
    return config
  }()
    
  lazy var appRemote: SPTAppRemote = {
    let remote = SPTAppRemote(configuration: configuration, logLevel: .debug)
    remote.delegate = self
    return remote
  }()
    
  // MARK: - Lifecycle Methods
  override init() {
    super.init()
    setupAppStateListeners()
  }
    
  // MARK: - Connection Management
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
    
  func disconnect() {
    if appRemote.isConnected {
      appRemote.disconnect()
    }
  }
    
  // MARK: - Authorization Methods
  func authorize() {
    appRemote.authorizeAndPlayURI("")
  }
    
  func setAccessToken(from url: URL) {
    let parameters = appRemote.authorizationParameters(from: url)
        
    if let token = parameters?[SPTAppRemoteAccessTokenKey] {
      appRemote.connectionParameters.accessToken = token
      accessToken = token
    } else if let error = parameters?[SPTAppRemoteErrorDescriptionKey] {
      print("Authorization error: \(error)")
    }
  }
    
  // MARK: - Private Methods
  private func setupAppStateListeners() {
    connectCancellable = NotificationCenter.default
      .publisher(for: UIApplication.didBecomeActiveNotification)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.connect()
      }
        
    disconnectCancellable = NotificationCenter.default
      .publisher(for: UIApplication.willResignActiveNotification)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.disconnect()
      }
  }
    
  private func fetchImage() {
    appRemote.playerAPI?.getPlayerState { [weak self] (result, error) in
      guard let self = self else { return }
            
      if let error = error {
        print("Player state error: \(error.localizedDescription)")
        return
      }
            
      guard let playerState = result as? SPTAppRemotePlayerState else { return }
            
      self.appRemote.imageAPI?.fetchImage(
        forItem: playerState.track,
        with: CGSize(width: 300, height: 300)
      ) { [weak self] (image, error) in
        guard let self = self else { return }
                
        if let error = error {
          print("Image fetch error: \(error.localizedDescription)")
          return
        }
                
        DispatchQueue.main.async {
          self.currentTrackImage = image as? UIImage
        }
      }
    }
  }
}

// MARK: - Spotify Remote Delegate
extension SpotifyController: SPTAppRemoteDelegate {
  nonisolated func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
    Task { @MainActor in
      print("Spotify connection established")
      self.appRemote.playerAPI?.delegate = self
      self.appRemote.playerAPI?.subscribe(
        toPlayerState: { [weak self] (result, error) in
          if let error = error {
            print(
              "Player state subscription error: \(error.localizedDescription)"
            )
          } else {
            print("Subscribed to player state updates")
            self?.appRemote.playerAPI?.getPlayerState({ _, _ in })
          }
        }
      )
    }
  }
    
  nonisolated func appRemote(
    _ appRemote: SPTAppRemote,
    didDisconnectWithError error: Error?
  ) {
    Task { @MainActor in
      print(
        "Spotify disconnected: \(error?.localizedDescription ?? "Unknown error")"
      )
      self.accessToken = nil
    }
  }
    
  nonisolated func appRemote(
    _ appRemote: SPTAppRemote,
    didFailConnectionAttemptWithError error: Error?
  ) {
    Task { @MainActor in
      print(
        "Connection failed: \(error?.localizedDescription ?? "Unknown error")"
      )
    }
  }
}

// MARK: - Player State Delegate
extension SpotifyController: SPTAppRemotePlayerStateDelegate {
  nonisolated func playerStateDidChange(
    _ playerState: SPTAppRemotePlayerState
  ) {
    Task { @MainActor in
      // Update currentTrack
      currentTrack = SpotifyTrack(
        uri: playerState.track.uri,
        name: playerState.track.name,
        artists: [SpotifyArtist(name: playerState.track.artist.name)],
        album: SpotifyAlbum(images: [])
      )
      
      fetchImage()
    }
  }
}
