import SwiftUI

struct ListenerModalView: View {
  @EnvironmentObject var viewModel: MuseViewModel
  
  let listener: MuseViewModel.Listener
  
  init(_ listener: MuseViewModel.Listener) {
    self.listener = listener
  }
  
  var body: some View {
    VStack {
      ListenerView(listener, showIconButton: false)
        .padding(.top, Constants.topPadding)
        .padding(.horizontal)
      
      MusicDisplayView(listener)
        .scaleEffect(Constants.scaleEffect)
      
      Spacer()
      
      if listener.buttonToShow != .shared {
        ButtonView(listener, style: .text)
      }
    }
    .padding()
  }
  
  private struct Constants {
    static let topPadding: CGFloat = 40.0
    static let scaleEffect: CGFloat = 0.9
  }
}

#Preview {
  ListenerModalView(
    MuseViewModel.Listener(
      name: "Test",
      listeningTo: .init(
        albumCover: "weathertop",
        songTitle: "Frog",
        artistName: "Test Artist"
      )
    )
  )
  .environmentObject(MuseViewModel())
}
