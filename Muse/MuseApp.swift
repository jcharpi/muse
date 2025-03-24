// Muse/MuseApp.swift
import SwiftUI

@main
struct MuseApp: App {
  @StateObject private var spotifyController = SpotifyController()
  @State private var viewModel = MuseViewModel()
    
  var body: some Scene {
    WindowGroup {
      MuseHomeView()
        .environment(viewModel)
        .environmentObject(spotifyController)
        .onOpenURL { url in
          spotifyController.setAccessToken(from: url)
        }
    }
  }
    
  private struct Constants {
    static let backgroundColor: Color = Color.black.opacity(0.8)
  }
}
