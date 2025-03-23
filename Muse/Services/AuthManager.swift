import Foundation
import SpotifyiOS

@Observable
final class AuthManager: NSObject {
  static let shared = AuthManager()
  var isAuthenticated = false
    
  // MARK: - Spotify Components
  @ObservationIgnored private let configuration: SPTConfiguration
  @ObservationIgnored private let sessionManager: SPTSessionManager
  @ObservationIgnored lazy var appRemote: SPTAppRemote = {
    let remote = SPTAppRemote(configuration: configuration, logLevel: .debug)
    remote.delegate = self
    return remote
  }()
    
  private var accessToken: String? {
    didSet {
      appRemote.connectionParameters.accessToken = accessToken
    }
  }
    
  // MARK: - Initialization
  override init() {
    // Initialize configuration with secure values
    configuration = SPTConfiguration(
      clientID: Secrets.spotifyClientID,
      redirectURL: Secrets.spotifyRedirectURL
    )
        
    sessionManager = SPTSessionManager(
      configuration: configuration,
      delegate: nil
    )
        
    super.init()
    sessionManager.delegate = self
  }
    
  // MARK: - Auth Flow
  func login() {
    let scope: SPTScope = [.appRemoteControl, .userReadPlaybackState]
    sessionManager.initiateSession(
      with: scope,
      options: .default,
      campaign: "main_app_flow"
    )
  }
    
  func handleCallback(url: URL) {
    let parameters = appRemote.authorizationParameters(from: url)
        
    if let token = parameters?[SPTAppRemoteAccessTokenKey] {
      accessToken = token
      appRemote.connect()
      isAuthenticated = true
    } else if let error = parameters?[SPTAppRemoteErrorDescriptionKey] {
      print("Auth error: \(error)")
      isAuthenticated = false
    }
  }
    
  func logout() {
    appRemote.disconnect()
    isAuthenticated = false
    accessToken = nil
  }
}

// MARK: - Session Manager Delegates
extension AuthManager: SPTSessionManagerDelegate {
  @objc func sessionManager(
    manager: SPTSessionManager,
    didInitiate session: SPTSession
  ) {
    accessToken = session.accessToken
    isAuthenticated = true
    appRemote.connect()
  }
    
  @objc func sessionManager(
    manager: SPTSessionManager,
    didFailWith error: Error
  ) {
    print("Auth failed: \(error.localizedDescription)")
    isAuthenticated = false
  }
}

// MARK: - App Remote Delegates
extension AuthManager: SPTAppRemoteDelegate {
  func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
    print("Spotify App Remote connected")
  }
    
  func appRemote(
    _ appRemote: SPTAppRemote,
    didDisconnectWithError error: Error?
  ) {
    print(
      "Spotify connection lost:",
      error?.localizedDescription ?? "unknown error"
    )
    isAuthenticated = false
  }
    
  func appRemote(
    _ appRemote: SPTAppRemote,
    didFailConnectionAttemptWithError error: Error?
  ) {
    print("Connection failed:", error?.localizedDescription ?? "unknown error")
    isAuthenticated = false
  }
}
