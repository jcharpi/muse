import UIKit
import SpotifyiOS

/// Handles application lifecycle events and Spotify connection management
class AppDelegate: NSObject, UIApplicationDelegate {
    
  /// Called when the app finishes launching
  /// - Returns: Boolean indicating if launch succeeded (always true for basic setup)
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    // Initial app setup can be added here if needed
    return true // Always return true for basic configuration
  }
    
  /// Called when app is about to lose focus (e.g., switching apps)
  func applicationWillResignActive(_ application: UIApplication) {
    // Disconnect from Spotify to prevent background activity
    if AuthManager.shared.appRemote.isConnected {
      AuthManager.shared.appRemote.disconnect()
    }
  }
    
  /// Called when app becomes active again
  func applicationDidBecomeActive(_ application: UIApplication) {
    // Reconnect to Spotify if we have a valid access token
    if AuthManager.shared.accessToken != nil {
      AuthManager.shared.appRemote.connect()
    }
  }
    
  /// Handles incoming URLs for Spotify authentication callback
  /// - Returns: Boolean indicating if URL was handled successfully
  func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any] = [:]
  ) -> Bool {
    // Route Spotify authentication callback to AuthManager
    AuthManager.shared.handleCallback(url: url)
    return true // Always return true as we handle the URL
  }
}
