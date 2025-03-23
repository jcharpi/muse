import SwiftUI

struct ButtonView: View {
  @Environment(MuseViewModel.self) private var viewModel
    
  // Encapsulated interaction handler with type erasure
  private let listener: Listener
  private let style: ButtonStyle
    
  // Enforces explicit style declaration at creation
  init(_ listener: Listener, style: ButtonStyle) {
    self.listener = listener
    self.style = style
  }
    
  var body: some View {
    let type = listener.buttonToShow
    let data = viewModel.buttonData(for: type, style: style)
    let colors = viewModel.buttonColors(for: type)
        
    Group {
      // Optional content strategy with type safety
      if let title = data.title {
        textButton(title, colors)
      } else if let icon = data.icon {
        iconButton(icon, colors)
      }
    }
    .onTapGesture {
      viewModel.buttonTap(listener)
    }
  }
    
  // Text variant styling with theme compliance
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
    
  // Icon variant with circular containment
  private func iconButton(_ icon: String, _ colors: MuseViewModel.ButtonColor) -> some View {
    Image(systemName: icon)
      .font(Constants.iconFontSize)
      .fontWeight(.semibold)
      .frame(
        width: Constants.iconSize,
        height: Constants.iconSize
      ) // Fixed frame
      .scaledToFit() // Maintain aspect ratio
      .foregroundStyle(colors.primaryColor)
      .background(
        Circle()
          .stroke(lineWidth: Constants.iconCircleStrokeWidth)
          .foregroundStyle(colors.primaryColor)
          .frame(width: Constants.circleSize, height: Constants.circleSize)
      )
      .padding(Constants.iconPadding) // Consistent padding

  }
  
  private struct Constants {
    static let iconSize: CGFloat = 30 // Fixed icon dimensions
    static let circleSize: CGFloat = 56 // Fixed background size
    static let iconPadding: CGFloat = 16
    static let verticalPadding: CGFloat = 8
    static let horizontalPadding: CGFloat = 24
    static let cornerRadius: CGFloat = 20
    static let iconFontSize: Font = .title
    static let titleFontSize: Font = .title2
    static let iconCircleStrokeWidth: CGFloat = 4
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
