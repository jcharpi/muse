import SwiftUI

// MARK: - HeaderView
/// Displays the user's profile icon in the top-right corner of the screen.
/// - Tapping the icon triggers a logout confirmation alert.
struct HeaderView: View {
  // MARK: - Dependencies
  @Environment(MuseViewModel.self) private var viewModel
  
  // MARK: - Body
  var body: some View {
    HStack {
      Spacer()
      ProfileIconView(
        imageUrl: viewModel.user.images.first?.url,
        size: Constants.profileIconSize
      )
      .padding(.trailing, Constants.trailingPadding)
    }
    .padding(.vertical)
  }
  
  // MARK: - Constants
  private struct Constants {
    static let profileIconSize: CGFloat = 40
    static let trailingPadding: CGFloat = 16
  }
}

// MARK: - Previews
#Preview {
  let model = MuseModel(musicService: MockMusicService())
  model.user = TestData.testUser
    
  return HeaderView()
    .environment(MuseViewModel(model: model))
}
