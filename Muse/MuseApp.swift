import SwiftUI

@main
struct MuseApp: App {
  @StateObject var viewModel = MuseViewModel()

  var body: some Scene {
    WindowGroup {
      MuseHomeView()
        .environmentObject(viewModel)
    }
  }
  
  private struct Constants {
    static let backgroundColor: Color = Color.black.opacity(0.8)
  }
}
