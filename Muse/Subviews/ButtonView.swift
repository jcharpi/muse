import SwiftUI

struct ButtonView: View {
  @Environment(MuseViewModel.self) private var viewModel

  private let listener: Listener
  private let style: ButtonDisplayStyle

  init(_ listener: Listener, style: ButtonDisplayStyle) {
    self.listener = listener
    self.style = style
  }

  var body: some View {
    let type = listener.buttonToShow
    let assets = viewModel.buttonAssets(for: type)
    let colors = viewModel.buttonColors(for: type)

    Group {
      switch style {
      case .text: textButton(assets.title, colors)
      case .icon: iconButton(assets.icon, colors)
      }
    }
    .onTapGesture { viewModel.buttonTap(listener) }
  }

  private func textButton(_ title: String, _ colors: MuseViewModel.ButtonColor) -> some View {
    Text(title)
      .font(.title2)
      .fontWeight(.medium)
      .foregroundStyle(colors.secondary ?? .black)
      .padding(.vertical, 8)
      .padding(.horizontal, 24)
      .background(colors.primary)
      .cornerRadius(20)
  }

  private func iconButton(_ icon: String, _ colors: MuseViewModel.ButtonColor) -> some View {
    Image(systemName: icon)
      .font(.title)
      .fontWeight(.semibold)
      .frame(width: 30, height: 30)
      .scaledToFit()
      .foregroundStyle(colors.primary)
      .background(
        Circle()
          .stroke(lineWidth: 4)
          .foregroundStyle(colors.primary)
          .frame(width: 56, height: 56)
      )
      .padding(16)
  }
}

#Preview {
  let testListeners = TestData.testListeners
  return HStack {
    VStack {
      ButtonView(testListeners[0], style: .text)
      ButtonView(testListeners[1], style: .text)
      ButtonView(testListeners[2], style: .text)
    }
    .padding()
    VStack {
      ButtonView(testListeners[0], style: .icon)
      ButtonView(testListeners[1], style: .icon)
      ButtonView(testListeners[2], style: .icon)
    }
    .padding()
  }
  .environment(MuseViewModel())
}
