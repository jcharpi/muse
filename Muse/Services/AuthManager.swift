import Foundation
import SpotifyiOS
import SwiftUI

/// Central authentication and Spotify playback state observer
/// Handles user authentication and tracks music playback state
@Observable
final class AuthManager: NSObject {
  /// Shared instance for app-wide access
  static let shared = AuthManager()
    
  // MARK: - Authentication State
  /// Indicates if user is logged in to Spotify (observed by SwiftUI views)
  var isAuthenticated = false
    
  // MARK: - Playback State
  /// Current player state from Spotify (observed by SwiftUI views)
  var playerState: SPTAppRemotePlayerState?
    
  // MARK: - Spotify Configuration
  /// Non-observable Spotify SDK configuration
  @ObservationIgnored private let configuration: SPTConfiguration
    
  /// Manager for authentication sessions
  @ObservationIgnored private let sessionManager: SPTSessionManager
    
  /// Remote interface for Spotify connection
  @ObservationIgnored lazy var appRemote: SPTAppRemote = {
    let remote = SPTAppRemote(configuration: configuration, logLevel: .debug)
    remote.delegate = self
    return remote
  }()
    
  // MARK: - Token Management
  /// Current access token with restricted write access
  private(set) var accessToken: String? {
    didSet {
      appRemote.connectionParameters.accessToken = accessToken
    }
  }
    
  // MARK: - Initialization
  override init() {
    // Set up Spotify configuration with credentials from Secrets.swift
    configuration = SPTConfiguration(
      clientID: Secrets.spotifyClientID,
      redirectURL: Secrets.spotifyRedirectURL
    )
        
    // Initialize session manager with configuration
    sessionManager = SPTSessionManager(
      configuration: configuration,
      delegate: nil
    )
        
    super.init()
    sessionManager.delegate = self
  }
    
  // MARK: - Authentication Flow
  /// Initiates Spotify login flow with read-only permissions
  func login() {
    // Define required permissions (read-only)
    let scope: SPTScope = [
      .appRemoteControl,
      .userReadPlaybackState
    ]
        
    // Start authentication flow
    sessionManager.initiateSession(
      with: scope,
      options: .default,
      campaign: "main_app_flow"
    )
  }
    
  /// Handles authentication callback from Spotify
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
    
  /// Clears all authentication state and disconnects from Spotify
  func logout() {
    appRemote.disconnect()
    accessToken = nil
    isAuthenticated = false
    playerState = nil
  }
    
  // MARK: - State Management
  /// Fetches current player state from Spotify
  private func fetchPlayerState() {
    appRemote.playerAPI?.getPlayerState { [weak self] result, error in
      guard let self else { return }
            
      if let error = error {
        print("Error fetching player state: \(error.localizedDescription)")
      } else if let state = result as? SPTAppRemotePlayerState {
        self.playerState = state
      }
    }
  }
}

// MARK: - Session Management Delegates
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
extension AuthManager: SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate {
  func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
    print("Spotify Connected")
    appRemote.playerAPI?.delegate = self
    appRemote.playerAPI?.subscribe(toPlayerState: { [weak self] _, error in
      if let error = error {
        print("Subscription error: \(error.localizedDescription)")
      } else {
        self?.fetchPlayerState()
      }
    })
  }
    
  func appRemote(
    _ appRemote: SPTAppRemote,
    didDisconnectWithError error: Error?
  ) {
    print(
      "Spotify Disconnected: \(error?.localizedDescription ?? "Unknown error")"
    )
    isAuthenticated = false
    playerState = nil
  }
    
  func appRemote(
    _ appRemote: SPTAppRemote,
    didFailConnectionAttemptWithError error: Error?
  ) {
    print(
      "Connection Failed: \(error?.localizedDescription ?? "Unknown error")"
    )
    isAuthenticated = false
  }
    
  func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
    self.playerState = playerState
    print("Now Playing: \(playerState.track.name)")
  }
}
