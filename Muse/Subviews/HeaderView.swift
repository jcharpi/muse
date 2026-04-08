import SwiftUI

/// User profile icon in the top-right corner. Tapping triggers the disconnect alert.
struct HeaderView: View {
  @Environment(MuseViewModel.self) private var viewModel

  var body: some View {
    HStack {
      Spacer()
      ProfileIconView(imageUrl: viewModel.user.images.first?.url, size: 40)
        .padding(.trailing, 16)
    }
    .padding(.vertical)
  }
}

#Preview {
  let model = MuseModel(musicService: MockMusicService())
  model.setTestData(user: TestData.testUser, listeners: [])
  return HeaderView()
    .environment(MuseViewModel(model: model))
}
