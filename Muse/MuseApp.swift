import SwiftUI

@main
struct MuseApp: App {
  // MARK: - Application Delegate
  /// Bridges UIKit's AppDelegate functionality to SwiftUI
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
  // MARK: - State Management
  /// Central authentication manager (persists throughout app lifecycle)
  @State private var authManager = AuthManager.shared
    
  /// Main view model for business logic and data management
  @State private var viewModel = MuseViewModel()
    
  // MARK: - Main Scene
  var body: some Scene {
    WindowGroup {
      MuseHomeView()
      // Inject dependencies into environment
        .environment(authManager)
        .environment(viewModel)
                
      // Handle app foregrounding events
        .onReceive(
          NotificationCenter.default.publisher(
            for: UIApplication.didBecomeActiveNotification
          )
        ) { _ in
          // Reconnect to Spotify if authenticated
          if authManager.accessToken != nil {
            authManager.appRemote.connect()
          }
        }
    }
  }
}
