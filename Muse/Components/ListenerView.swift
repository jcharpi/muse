import SwiftUI

struct ListenerView: View {
  @EnvironmentObject var viewModel: MuseViewModel
  
  let listener: Listener
  let showIconButton: Bool
  
  init(
    _ listener: Listener,
    showIconButton: Bool = true  ) {
      self.listener = listener
      self.showIconButton = showIconButton
    }
  
  var body: some View {
    HStack {
      ProfileIconView(
        Image(listener.profilePic),
        size: Constants.profileIconSize,
        color: Constants.primaryColor
      )
      .padding(.trailing, Constants.trailingProfilePadding)
      
      VStack(alignment: .leading, spacing: Constants.vStackSpacing) {
        Text(listener.name)
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
    static let primaryColor: Color = Color.primary
    static let vStackSpacing: CGFloat = 8.0
    static let profileIconSize: CGFloat = 56.0
    static let trailingProfilePadding: CGFloat = 4.0
  }
}

#Preview {
  VStack(spacing: 16) {
    ListenerView(
      Listener(
        name: "Josh",
        profilePic: "josh",
        listeningTo: .init(
          albumCover: "cover",
          songTitle: "title",
          artistName: "artist"
        )
      )
    )
    ListenerView(
      Listener(
        name: "Maya",
        profilePic: "maya",
        listeningTo: .init(
          albumCover: "cover",
          songTitle: "title",
          artistName: "artist"
        )
      )
    )
    ListenerView(
      Listener(
        name: "Emily",
        profilePic: "emily",
        listeningTo: .init(
          albumCover: "weathertop",
          songTitle: "Frog",
          artistName: "Jibby Jab"
        ),
        sentRecommendation: true
      )
    )
  }
  .padding()
  .environmentObject(MuseViewModel())
}
