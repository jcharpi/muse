import SwiftUI
import SpotifyiOS
import Combine

// MARK: - SpotifyController
/// Manages Spotify SDK integration: authentication, connection lifecycle, and playback state.
@MainActor
final class SpotifyController: NSObject, ObservableObject {

  // MARK: - Configuration
  private let spotifyClientID: String = {
    guard let id = Bundle.main.object(forInfoDictionaryKey: "SpotifyClientID") as? String else {
      fatalError("SpotifyClientID missing from Info.plist")
    }
    return id
  }()

  private let spotifyRedirectURL: URL = {
    guard let raw = Bundle.main.object(forInfoDictionaryKey: "SpotifyRedirectURL") as? String,
          let url = URL(string: raw) else {
      fatalError("SpotifyRedirectURL missing or invalid in Info.plist")
    }
    return url
  }()

  private lazy var configuration = SPTConfiguration(
    clientID: spotifyClientID,
    redirectURL: spotifyRedirectURL
  )

  // MARK: - Published State
  @Published var accessToken: String?
  @Published var currentTrack: SpotifyTrack?
  @Published var currentTrackImage: UIImage?

  // MARK: - Private
  private lazy var appRemote: SPTAppRemote = {
    let remote = SPTAppRemote(configuration: configuration, logLevel: .debug)
    remote.delegate = self
    return remote
  }()

  private var cancellables = Set<AnyCancellable>()
  private var currentAlbumId = ""

  override init() {
    super.init()
    setupAppStateObservers()
  }
}

// MARK: - Connection Management
extension SpotifyController {
  func connect() {
    if appRemote.connectionParameters.accessToken != nil {
      appRemote.connect()
      return
    }
    if let token = accessToken {
      appRemote.connectionParameters.accessToken = token
      appRemote.connect()
    }
  }

  func disconnect() {
    guard appRemote.isConnected else { return }
    appRemote.disconnect()
  }

  func signOut() {
    disconnect()
    accessToken = nil
  }

  private func setupAppStateObservers() {
    NotificationCenter.default
      .publisher(for: UIApplication.didBecomeActiveNotification)
      .sink { [weak self] _ in self?.connect() }
      .store(in: &cancellables)

    NotificationCenter.default
      .publisher(for: UIApplication.willResignActiveNotification)
      .sink { [weak self] _ in self?.disconnect() }
      .store(in: &cancellables)
  }
}

// MARK: - Authentication
extension SpotifyController {
  func authorize() {
    appRemote.authorizeAndPlayURI("")
  }

  func setAccessToken(from url: URL) {
    guard let params = appRemote.authorizationParameters(from: url) else { return }
    if let token = params[SPTAppRemoteAccessTokenKey] {
      appRemote.connectionParameters.accessToken = token
      accessToken = token
    } else if let error = params[SPTAppRemoteErrorDescriptionKey] {
      print("Auth error: \(error)")
    }
  }
}

// MARK: - Playback State
extension SpotifyController {
  private func handlePlayerStateUpdate(_ playerState: SPTAppRemotePlayerState) {
    let albumId = playerState.track.album.uri.components(separatedBy: ":").last ?? ""
    guard albumId != currentAlbumId else { return }
    currentAlbumId = albumId
    currentTrack = SpotifyTrack(
      uri: playerState.track.uri,
      name: playerState.track.name,
      artists: [SpotifyArtist(name: playerState.track.artist.name)],
      album: SpotifyAlbum(images: [])
    )
    fetchTrackArtwork(for: playerState.track)
  }

  private func fetchTrackArtwork(for track: SPTAppRemoteTrack) {
    appRemote.imageAPI?
      .fetchImage(forItem: track, with: CGSize(width: 2000, height: 2000)) {
        [weak self] (image, error) in
        if let error {
          print("Artwork error: \(error.localizedDescription)")
          return
        }
        guard let image = image as? UIImage else { return }
        Task { @MainActor [weak self] in
          self?.currentTrackImage = image
        }
      }
  }
}

// MARK: - SPTAppRemoteDelegate
extension SpotifyController: SPTAppRemoteDelegate {
  nonisolated func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
    Task { @MainActor [weak self] in
      print("Spotify connected")
      self?.setupPlayerStateSubscription()
    }
  }

  nonisolated func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
    Task { @MainActor in
      print("Spotify disconnected: \(error?.localizedDescription ?? "unknown")")
    }
  }

  nonisolated func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
    Task { @MainActor in
      print("Spotify connection failed: \(error?.localizedDescription ?? "unknown")")
    }
  }

  private func setupPlayerStateSubscription() {
    appRemote.playerAPI?.delegate = self
    appRemote.playerAPI?.subscribe(toPlayerState: { _, _ in })
  }
}

// MARK: - Playback Control
extension SpotifyController {
  func playTrack(uri: String, completion: ((Error?) -> Void)? = nil) {
    guard appRemote.isConnected else {
      completion?(SpotifyError.notConnected)
      return
    }
    appRemote.playerAPI?.play(uri, asRadio: false) { _, error in
      completion?(error)
    }
  }

  func queueTrack(uri: String, completion: ((Error?) -> Void)? = nil) {
    guard appRemote.isConnected else {
      completion?(SpotifyError.notConnected)
      return
    }
    appRemote.playerAPI?.enqueueTrackUri(uri) { _, error in
      completion?(error)
    }
  }

  enum SpotifyError: LocalizedError {
    case notConnected

    var errorDescription: String? {
      switch self {
      case .notConnected: return "Spotify is not connected"
      }
    }
  }
}

// MARK: - SPTAppRemotePlayerStateDelegate
extension SpotifyController: SPTAppRemotePlayerStateDelegate {
  nonisolated func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
    Task { @MainActor [weak self] in
      self?.handlePlayerStateUpdate(playerState)
    }
  }
}
