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
      case .icon: iconButton(assets.icon, colors)
      case .text: textButton(assets.icon, colors)
      }
    }
    .onTapGesture { viewModel.buttonTap(listener) }
  }

  // MARK: - Icon Style (used in the Nearby list)
  // Thumbs-up icon inside a circle, with a reaction count badge when count > 0.
  private func iconButton(_ icon: String, _ colors: MuseViewModel.ButtonColor) -> some View {
    ZStack(alignment: .topTrailing) {
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

      if listener.reactionCount > 0 {
        Text("\(listener.reactionCount)")
          .font(.caption2)
          .fontWeight(.bold)
          .foregroundStyle(.white)
          .padding(5)
          .background(Circle().fill(.pink))
          .offset(x: 2, y: 2)
      }
    }
  }

  // MARK: - Text Style (used in the listener modal)
  // SF Symbol + count number; highlighted in yellow when already reacted.
  private func textButton(_ icon: String, _ colors: MuseViewModel.ButtonColor) -> some View {
    let reacted = listener.buttonToShow == .reacted
    return HStack(spacing: 8) {
      Image(systemName: icon)
      if listener.reactionCount > 0 {
        Text("\(listener.reactionCount)")
      }
    }
    .font(.title2)
    .fontWeight(.medium)
    .foregroundStyle(reacted ? .yellow : .primary)
    .padding(.vertical, 10)
    .padding(.horizontal, 28)
    .background(
      RoundedRectangle(cornerRadius: 20)
        .fill(reacted ? Color.yellow.opacity(0.15) : Color.primary.opacity(0.08))
    )
    .overlay(
      RoundedRectangle(cornerRadius: 20)
        .stroke(reacted ? Color.yellow : Color.primary.opacity(0.3), lineWidth: 2)
    )
  }
}

#Preview {
  let testListeners = TestData.testListeners
  return HStack {
    VStack(spacing: 20) {
      ButtonView(testListeners[0], style: .icon)  // 2 reactions, not reacted
      ButtonView(testListeners[1], style: .icon)  // 5 reactions, reacted
      ButtonView(testListeners[2], style: .icon)  // 0 reactions
    }
    .padding()
    VStack(spacing: 20) {
      ButtonView(testListeners[0], style: .text)
      ButtonView(testListeners[1], style: .text)
      ButtonView(testListeners[2], style: .text)
    }
    .padding()
  }
  .environment(MuseViewModel())
}
