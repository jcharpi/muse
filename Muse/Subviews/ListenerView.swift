import SwiftUI

struct ListenerView: View {
  @Environment(MuseViewModel.self) private var viewModel
    
  let listener: Listener
  let showIconButton: Bool
    
  init(_ listener: Listener, showIconButton: Bool = true) {
    self.listener = listener
    self.showIconButton = showIconButton
  }
    
  var body: some View {
    HStack {
      ProfileIconView(
        imageUrl: listener.images.first?.url,
        size: Constants.profileIconSize
      )
      .padding(.trailing, Constants.trailingProfilePadding)
            
      VStack(alignment: .leading, spacing: Constants.vStackSpacing) {
        Text(listener.displayName)
          .font(.title2)
        Text(viewModel.textToDisplay(listener.buttonToShow))
          .font(.subheadline)
      }
      .fontWeight(.semibold)
      .foregroundStyle(Constants.primaryColor)
            
      Spacer()
    }
    .contentShape(Rectangle())
  }
    
  private struct Constants {
    static let primaryColor: Color = .primary
    static let vStackSpacing: CGFloat = 8.0
    static let profileIconSize: CGFloat = 56.0
    static let trailingProfilePadding: CGFloat = 4.0
  }
}

#Preview {
  VStack(spacing: 16) {
    ListenerView(
      Listener(
        id: "1",
        displayName: "Josh",
        images: [SpotifyImage(
          url: URL(
            string: "https://example.com/user1.jpg"
          )!
        )]
      ),
      showIconButton: true
    )
    ListenerView(
      Listener(
        id: "2",
        displayName: "Maya",
        images: [SpotifyImage(
          url: URL(
            string: "https://example.com/user2.jpg"
          )!
        )]
      ),
      showIconButton: true
    )
  }
  .padding()
  .environment(MuseViewModel())
}
