import SwiftUI

struct ProfileIconView: View {
  private let profileImage: Image
  private let size: CGFloat
  let color: Color
  
  init(_ pfp: Image, size: CGFloat, color: Color = .white) {
    self.profileImage = pfp
    self.size = size
    self.color = color
  }
  
  var body: some View {
    profileImage
      .resizable()
      .scaledToFit()
      .clipShape(Circle())
      .background(Circle()
        .stroke(lineWidth: Constants.lineWidth)
        .foregroundStyle(color))
      .frame(width: size, height: size)
  }
  
  private struct Constants {
    static let lineWidth: CGFloat = 8.0
  }
}

#Preview {
  ZStack {
    Color.black
      .edgesIgnoringSafeArea(.all)
    
    ProfileIconView(Image("joshc28"), size: 100)
      .padding()
  }
}
