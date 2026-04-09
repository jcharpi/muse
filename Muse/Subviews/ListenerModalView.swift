import SwiftUI

struct ListenerModalView: View {
  @Environment(MuseViewModel.self) private var viewModel

  var body: some View {
    if let listener = viewModel.selectedListener {
      VStack(spacing: 24) {
        ListenerView(listener)
          .padding(.top, 8)
          .padding(.horizontal)

        MusicDisplayView(listener: listener)

        ButtonView(listener, style: .text)
          .frame(minHeight: 50)
          .padding(.bottom, 24)
      }
      .frame(maxHeight: .infinity)
    }
  }
}

#Preview {
  let viewModel = MuseViewModel(model: MuseModel(musicService: MockMusicService()))
  viewModel.selectedListener = TestData.testListeners[0]
  return ListenerModalView()
    .environment(viewModel)
    .environmentObject(SpotifyController())
}

#Preview("Already reacted") {
  let viewModel = MuseViewModel(model: MuseModel(musicService: MockMusicService()))
  viewModel.selectedListener = TestData.testListeners[1]
  return ListenerModalView()
    .environment(viewModel)
    .environmentObject(SpotifyController())
}
