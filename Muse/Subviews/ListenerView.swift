import SwiftUI

struct ListenerView: View {
  @Environment(MuseViewModel.self) private var viewModel
    
  // Represents the listener whose information is being displayed.
  let listener: Listener
    
  // Initializes the view with a listener and an optional flag for showing an icon button.
  init(_ listener: Listener, showIconButton: Bool = true) {
    self.listener = listener
  }
    
  var body: some View {
    HStack {
      // Displays the listener's profile image in a circular format.
      ProfileIconView(
        imageUrl: listener.images.first?.url,
        size: Constants.profileIconSize
      )
      .padding(.trailing, Constants.trailingProfilePadding)
            
      listenerText
            
      Spacer() // Pushes content to the leading side.
    }
    // Defines a tappable area that covers the entire horizontal row.
    .contentShape(Rectangle())
  }
  
  var listenerText: some View {
    // Arranges the listener's display name and associated button text vertically.
    VStack(alignment: .leading, spacing: Constants.vStackSpacing) {
      Text(listener.displayName)
        .font(.title2)
      // Uses the view model to determine the appropriate text based on the listener's button state.
      Text(viewModel.textToDisplay(listener.buttonToShow))
        .font(.subheadline)
    }
    // Applies a consistent styling to the text.
    .fontWeight(.semibold)
    .foregroundStyle(Constants.primaryColor)
  }
  
  private struct Constants {
    static let primaryColor: Color = .primary
    static let vStackSpacing: CGFloat = 8.0
    static let profileIconSize: CGFloat = 56.0
    static let trailingProfilePadding: CGFloat = 4.0
  }
}

#Preview {
  let model = MuseModel(musicService: MockMusicService())
  model.setTestData(
    user: TestData.testUser,
    listeners: TestData.testListeners
  )
  let viewModel = MuseViewModel(model: model)
    
  return VStack(spacing: 16) {
    ForEach(TestData.testListeners) { listener in
      ListenerView(listener)
    }
  }
  .padding()
  .environment(viewModel)
}
