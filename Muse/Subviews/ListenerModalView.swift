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

        Group {
          if listener.buttonToShow == .shared {
            Text("You sent \(listener.displayName) a recommendation!")
              .foregroundStyle(.green)
              .font(.footnote)
              .frame(minHeight: 50)
          } else {
            ButtonView(listener, style: .text)
              .frame(minHeight: 50)
          }
        }
        .padding(.bottom, 24)
      }
      .frame(maxHeight: .infinity)
    }
  }
}

#Preview {
  let viewModel = MuseViewModel(model: MuseModel(musicService: MockMusicService()))
  viewModel.selectedListener = TestData.testListeners[1]
  return ListenerModalView()
    .environment(viewModel)
    .environmentObject(SpotifyController())
}
