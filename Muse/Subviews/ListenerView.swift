import SwiftUI

// MARK: - ListenerView
/// A row item displaying basic listener information and interaction status.
struct ListenerView: View {
  // MARK: - Dependencies
  @Environment(MuseViewModel.self) private var viewModel
  
  // MARK: - Properties
  let listener: Listener
  
  // MARK: - Initialization
  init(_ listener: Listener) {
    self.listener = listener
  }
  
  // MARK: - Body
  var body: some View {
    HStack {
      ProfileIconView(
        imageUrl: listener.images.first?.url,
        size: Constants.profileIconSize
      )
      .padding(.trailing, Constants.trailingProfilePadding)
      
      listenerText
      Spacer()
    }
    .contentShape(Rectangle())
  }
  
  // MARK: - Subviews
  private var listenerText: some View {
    VStack(alignment: .leading, spacing: Constants.vStackSpacing) {
      Text(listener.displayName)
        .font(.title2)
      Text(viewModel.textToDisplay(listener.buttonToShow))
        .font(.subheadline)
    }
    .fontWeight(.semibold)
    .foregroundStyle(Constants.primaryColor)
  }
  
  // MARK: - Constants
  private struct Constants {
    static let primaryColor: Color = .primary
    static let vStackSpacing: CGFloat = 8.0
    static let profileIconSize: CGFloat = 56.0
    static let trailingProfilePadding: CGFloat = 4.0
  }
}

// MARK: - Previews
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
