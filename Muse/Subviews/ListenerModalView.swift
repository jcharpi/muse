import SwiftUI

struct ListenerModalView: View {
  @Environment(MuseViewModel.self) private var viewModel
    
  var body: some View {
    if let listener = viewModel.selectedListener {
      VStack {
        Spacer()
                
        ListenerView(listener, showIconButton: false)
          .padding(.top, Constants.topPadding)
          .padding(.horizontal)
                
        Spacer()
                
        MusicDisplayView(listener: listener)
          .scaleEffect(Constants.scaleEffect)
                
        Spacer()

        if listener.buttonToShow != .shared {
          ButtonView(listener, style: .text)
            .frame(minHeight: Constants.minHeight)
        } else {
          Text("You sent \(listener.displayName) a recommendation!")
            .foregroundStyle(.green)
            .font(.footnote)
            .fontWeight(.medium)
            .frame(minHeight: Constants.minHeight)
        }
                
        Spacer()
      }
      .padding()
    } else {
      Text("No listener selected")
    }
  }
    
  private struct Constants {
    static let minHeight: CGFloat = 50.0
    static let topPadding: CGFloat = 8.0
    static let scaleEffect: CGFloat = 0.9
  }
}

#Preview {
  let viewModel = MuseViewModel(
    model: MuseModel(musicService: MockMusicService())
  )
  viewModel.selectedListener = TestData.testListeners.first
    
  return ListenerModalView()
    .environment(viewModel)
}
