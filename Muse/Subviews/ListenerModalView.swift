import SwiftUI

struct ListenerModalView: View {
  @Environment(MuseViewModel.self) private var viewModel
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    if let listener = viewModel.selectedListener {
      VStack(spacing: 24) {
        ListenerView(listener)
          .padding(.top, 8)
          .padding(.horizontal)

        MusicDisplayView(listener: listener)

        if listener.listeningTo != nil {
          Button {
            viewModel.playTrack(for: listener)
            dismiss()
          } label: {
            Label("Play", systemImage: "play.fill")
              .fontWeight(.medium)
              .padding(.vertical, 10)
              .padding(.horizontal, 24)
              .background(RoundedRectangle(cornerRadius: 20).fill(.green))
              .foregroundStyle(.black)
          }
          .padding(.bottom, 24)
        }
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

#Preview("No track") {
  let viewModel = MuseViewModel(model: MuseModel(musicService: MockMusicService()))
  viewModel.selectedListener = TestData.testListeners[2]
  return ListenerModalView()
    .environment(viewModel)
    .environmentObject(SpotifyController())
}
