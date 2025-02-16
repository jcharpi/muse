import SwiftUI

struct ListenerView: View {
  @EnvironmentObject var viewModel: MuseViewModel
  
  let listener: MuseViewModel.Listener
  let showIconButton: Bool
  
  init(
    _ listener: MuseViewModel.Listener,
    showIconButton: Bool = true  ) {
      self.listener = listener
      self.showIconButton = showIconButton
    }
  
  var body: some View {
    HStack {
      ProfileIconView(
        Image("joshc28"),
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
    static let profileIconSize: CGFloat = 72.0
    static let trailingProfilePadding: CGFloat = 4.0
  }
}

#Preview {
  VStack(spacing: 16) {
    ListenerView(
      MuseViewModel.Listener(
        name: "Josh",
        listeningTo: .init(
          albumCover: "weathertop",
          songTitle: "Frog",
          artistName: "Jibby Jab"
        )
      )
    )
    ListenerView(
      MuseViewModel.Listener(
        name: "Josh",
        listeningTo: .init(
          albumCover: "weathertop",
          songTitle: "Frog",
          artistName: "Jibby Jab"
        ),
        recommendedMe: true
      )
    )
    ListenerView(
      MuseViewModel.Listener(
        name: "Josh",
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
