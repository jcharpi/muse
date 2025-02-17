import SwiftUI

struct ListenerModalView: View {
  @EnvironmentObject var viewModel: MuseViewModel
  
  var body: some View {
    if let listener = viewModel.selectedListener {
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
        
        Spacer()
      }
      .padding()
    } else {
      Text("No listener selected")
    }
  }
  
  private struct Constants {
    static let topPadding: CGFloat = 40.0
    static let scaleEffect: CGFloat = 0.9
  }
}

#Preview {
  let viewModel = MuseViewModel()
  
  viewModel.selectedListener = viewModel.listeners[2]
  return ListenerModalView()
    .environmentObject(viewModel)
}
