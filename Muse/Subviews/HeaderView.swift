import SwiftUI

struct HeaderView: View {
  @Environment(MuseViewModel.self) private var viewModel
    
  var body: some View {
    HStack {
      Spacer()
      ProfileIconView(
        imageUrl: viewModel.user.images.first?.url,
        size: Constants.profileIconSize
      )
      .padding(.trailing, Constants.trailingPadding)
      .padding(.leading, Constants.leadingPadding)
    }
    .padding(.vertical)
  }
    
  private struct Constants {
    static let profileIconSize: CGFloat = 40
    static let trailingPadding: CGFloat = 16
    static let leadingPadding: CGFloat = 8
  }
}

#Preview {
  let model = MuseModel(musicService: MockMusicService())
  model.user = TestData.testUser
    
  return HeaderView()
    .environment(MuseViewModel(model: model))
}
