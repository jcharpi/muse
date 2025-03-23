// File: Muse/Services/AuthManager.swift
import Foundation
import SpotifyiOS // Add this import

@Observable
class AuthManager {
    static let shared = AuthManager()
    var isAuthenticated = false
    
    // Spotify configuration
    private static let SpotifyClientID = "[YOUR_CLIENT_ID_HERE]" // Replace with actual ID
    private static let SpotifyRedirectURL = URL(string: "muse://spotify-login-callback")!
    
    lazy var configuration: SPTConfiguration = {
        let config = SPTConfiguration(clientID: AuthManager.SpotifyClientID,
                                      redirectURL: AuthManager.SpotifyRedirectURL)
        config.playURI = "" // Optional: Set play URI if needed
        return config
    }()
    
    // Add session manager instance
    lazy var sessionManager: SPTSessionManager = {
        return SPTSessionManager(configuration: configuration, delegate: self)
    }()
    
    func login() {
        let scope: SPTScope = [.appRemoteControl, .userReadPlaybackState]
        sessionManager.initiateSession(with: scope, options: .default)
    }
    
    func handleCallback(url: URL) {
        sessionManager.application(UIApplication.shared, open: url, options: [:])
    }
    
    func logout() {
        isAuthenticated = false
        // Add session cleanup if needed
    }
}

// MARK: - SPTSessionManagerDelegate
extension AuthManager: SPTSessionManagerDelegate {
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        isAuthenticated = true
        // Store session and connect to Spotify app remote
    }
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        print("Auth failed: \(error.localizedDescription)")
    }
    
    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
        // Handle session renewal
    }
}
