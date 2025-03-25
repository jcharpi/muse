import SwiftUI

// MARK: - ListenerModalView
/// A modal sheet displaying detailed information about a selected nearby listener.
/// - Shows music recommendations and sharing status.
struct ListenerModalView: View {
  // MARK: - Dependencies
  @Environment(MuseViewModel.self) private var viewModel
  
  // MARK: - Body
  var body: some View {
    if let listener = viewModel.selectedListener {
      VStack(spacing: Constants.verticalSpacing) {
        // Header Section
        ListenerView(listener)
          .padding(.top, Constants.topPadding)
          .padding(.horizontal)
        
        // Music Content
        MusicDisplayView(listener: listener)
        
        // Action Section
        Group {
          if listener.buttonToShow != .shared {
            ButtonView(listener, style: .text)
              .frame(minHeight: Constants.minHeight)
          } else {
            Text("You sent \(listener.displayName) a recommendation!")
              .foregroundStyle(.green)
              .font(.footnote)
              .frame(minHeight: Constants.minHeight)
          }
        }
        .padding(.bottom, Constants.bottomPadding)
      }
      .frame(maxHeight: .infinity)
    } else {
      Text("No listener selected")
    }
  }
  
  // MARK: - Constants
  private struct Constants {
    static let minHeight: CGFloat = 50.0
    static let topPadding: CGFloat = 8.0
    static let verticalSpacing: CGFloat = 32.0
    static let bottomPadding: CGFloat = 24 // Bottom space replacement
  }
}

// MARK: - Previews
#Preview {
  let viewModel = MuseViewModel(
    model: MuseModel(musicService: MockMusicService())
  )
  viewModel.selectedListener = TestData.testListeners[1]
    
  return ListenerModalView()
    .environment(viewModel)
    .environmentObject(SpotifyController())
}
