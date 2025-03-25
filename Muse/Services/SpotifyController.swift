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
  private var currentAlbumId: String = ""
  private var hasInitialArtFetch = false
  
  // MARK: - Player State Properties
  @Published var currentTrack: SpotifyTrack?
  @Published var accessToken: String?
  
  // MARK: - Spotify SDK Components
  private var connectCancellable: AnyCancellable?
  private var disconnectCancellable: AnyCancellable?
  
  lazy var configuration: SPTConfiguration = {
    let config = SPTConfiguration(
      clientID: spotifyClientID,
      redirectURL: spotifyRedirectURL
    )
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
  
  private func fetchAlbumArt(albumId: String) {
    guard let accessToken = accessToken else { return }
    
    let url = URL(string: "https://api.spotify.com/v1/albums/\(albumId)")!
    
    var request = URLRequest(url: url)
    request
      .setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    
    URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
      guard let self = self else { return }
      
      if let error = error {
        print("Album fetch error: \(error.localizedDescription)")
        return
      }
      
      guard let data = data,
            let result = try? JSONDecoder().decode(SpotifyAlbumResponse.self, from: data) else {
        return
      }
      
      DispatchQueue.main.async {
        // Create a mutable copy of the current track
        if var currentTrack = self.currentTrack {
          currentTrack.album.images = result.images
          self.currentTrack = currentTrack  // Reassign the updated track
        }
      }
    }.resume()
  }

  // Add this struct to decode the response
  struct SpotifyAlbumResponse: Codable {
    let images: [SpotifyImage]
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
      let albumUriParts = playerState.track.album.uri.components(
        separatedBy: ":"
      )
      let albumId = albumUriParts.last ?? ""
      
      // Skip if same album and already fetched art
      guard albumId != self.currentAlbumId || !hasInitialArtFetch else {
        return
      }
      
      self.currentAlbumId = albumId
      self.hasInitialArtFetch = true
      
      // Initialize track
      self.currentTrack = SpotifyTrack(
        uri: playerState.track.uri,
        name: playerState.track.name,
        artists: [SpotifyArtist(name: playerState.track.artist.name)],
        album: SpotifyAlbum(images: [])
      )
      
      fetchAlbumArt(albumId: albumId)
    }
  }
}
