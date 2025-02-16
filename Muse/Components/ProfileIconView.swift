import SwiftUI

struct ProfileIconView: View {
  private let profileImage: Image
  private let size: CGFloat
  
  init(_ pfp: Image, size: CGFloat, color: Color = .primary) {
    self.profileImage = pfp
    self.size = size
  }
  
  var body: some View {
    profileImage
      .resizable()
      .scaledToFit()
      .clipShape(Circle())
      .background(Circle()
        .stroke(lineWidth: Constants.lineWidth)
        .foregroundStyle(Color.primary))
      .frame(width: size, height: size)
  }
  
  private struct Constants {
    static let lineWidth: CGFloat = 8.0
  }
}

#Preview {
  ProfileIconView(Image("joshc28"), size: 100)
    .padding()
  
}
