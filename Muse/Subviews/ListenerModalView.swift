import SwiftUI

struct ListenerModalView: View {
  @Environment(MuseViewModel.self) private var viewModel
    
  var body: some View {
    // Check if a listener is selected; if not, display a fallback message.
    if let listener = viewModel.selectedListener {
      VStack {
        Spacer()
                
        // Display listener information without an interactive icon.
        ListenerView(listener)
          .padding(
            .top,
            Constants.topPadding
          )
          .padding(.horizontal)
                
        Spacer()
                
        // Display music-related content for the selected listener.
        MusicDisplayView(listener: listener)
                
        Spacer()

        // Conditionally show a button or a confirmation message based on the listener's state.
        if listener.buttonToShow != .shared {
          ButtonView(listener, style: .text)
            .frame(
              minHeight: Constants.minHeight
            )
        } else {
          Text("You sent \(listener.displayName) a recommendation!")
            .foregroundStyle(.green)
            .font(.footnote)
            .fontWeight(.medium)
            .frame(minHeight: Constants.minHeight)
        }
                
        Spacer()
      }
      .padding()
    } else {
      Text("No listener selected")
    }
  }
    
  private struct Constants {
    static let minHeight: CGFloat = 50.0 // Minimum height for button or text area.
    static let topPadding: CGFloat = 8.0 // Top padding for the listener view.
  }
}

#Preview {
  let viewModel = MuseViewModel(
    model: MuseModel(musicService: MockMusicService())
  )
  viewModel.selectedListener = TestData.testListeners.first
    
  return ListenerModalView()
    .environment(viewModel)
}
