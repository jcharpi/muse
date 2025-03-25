import SwiftUI

// MARK: - ButtonView
/// A customizable button that dynamically adapts to listener interaction states.
/// - Supports both text and icon styles.
/// - Taps trigger asynchronous actions via `MuseViewModel`.
struct ButtonView: View {
  // MARK: - Dependencies
  @Environment(MuseViewModel.self) private var viewModel
  
  // MARK: - Properties
  private let listener: Listener
  private let style: ButtonStyle
  
  // MARK: - Initialization
  /// - Parameters:
  ///   - listener: The listener associated with this button.
  ///   - style: Determines if the button displays text or an icon.
  init(_ listener: Listener, style: ButtonStyle) {
    self.listener = listener
    self.style = style
  }
  
  // MARK: - Body
  var body: some View {
    let type = listener.buttonToShow
    let data = viewModel.buttonData(for: type, style: style)
    let colors = viewModel.buttonColors(for: type)
    
    Group {
      if let title = data.title {
        textButton(title, colors)
      } else if let icon = data.icon {
        iconButton(icon, colors)
      }
    }
    .onTapGesture { viewModel.buttonTap(listener) }
  }
  
  // MARK: - Subviews
  private func textButton(_ title: String, _ colors: MuseViewModel.ButtonColor) -> some View {
    Text(title)
      .font(Constants.titleFontSize)
      .fontWeight(.medium)
      .foregroundStyle(colors.secondaryColor ?? .black)
      .padding(.vertical, Constants.verticalPadding)
      .padding(.horizontal, Constants.horizontalPadding)
      .background(colors.primaryColor)
      .cornerRadius(Constants.cornerRadius)
  }
  
  private func iconButton(_ icon: String, _ colors: MuseViewModel.ButtonColor) -> some View {
    Image(systemName: icon)
      .font(Constants.iconFontSize)
      .fontWeight(.semibold)
      .frame(width: Constants.iconSize, height: Constants.iconSize)
      .scaledToFit()
      .foregroundStyle(colors.primaryColor)
      .background(
        Circle()
          .stroke(lineWidth: Constants.iconCircleStrokeWidth)
          .foregroundStyle(colors.primaryColor)
          .frame(width: Constants.circleSize, height: Constants.circleSize)
      )
      .padding(Constants.iconPadding)
  }
  
  // MARK: - Constants
  private struct Constants {
    static let iconSize: CGFloat = 30
    static let circleSize: CGFloat = 56
    static let iconPadding: CGFloat = 16
    static let verticalPadding: CGFloat = 8
    static let horizontalPadding: CGFloat = 24
    static let cornerRadius: CGFloat = 20
    static let iconFontSize: Font = .title
    static let titleFontSize: Font = .title2
    static let iconCircleStrokeWidth: CGFloat = 4
  }
}

// MARK: - Previews
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
