import SwiftUI

@main
struct MuseApp: App {
  @State private var viewModel = MuseViewModel()
    
  var body: some Scene {
    WindowGroup {
      MuseHomeView()
        .environment(viewModel)  // New environment injection style
    }
  }
    
  private struct Constants {
    static let backgroundColor: Color = Color.black.opacity(0.8)
  }
}
