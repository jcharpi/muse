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
      .aspectRatio(contentMode: .fill)
      .frame(width: size, height: size)
      .clipShape(Circle())
      .background(
        Circle()
          .stroke(lineWidth: Constants.lineWidth)
          .foregroundStyle(Color.primary)
      )
  }
    
  private struct Constants {
    static let lineWidth: CGFloat = 4.0
  }
}

#Preview {
  ProfileIconView(Image("josh"), size: 80)
    .padding()
}
