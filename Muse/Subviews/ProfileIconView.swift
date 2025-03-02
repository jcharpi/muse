import SwiftUI

struct ProfileIconView: View {
  private let imageUrl: URL?
  private let size: CGFloat
    
  init(imageUrl: URL?, size: CGFloat) {
    self.imageUrl = imageUrl
    self.size = size
  }
    
  var body: some View {
    Group {
      if let imageUrl {
        AsyncImage(url: imageUrl) { phase in
          if let image = phase.image {
            image
              .resizable()
              .aspectRatio(contentMode: .fill)
          } else if phase.error != nil {
            Image(systemName: "person.circle.fill")
              .resizable()
          } else {
            ProgressView()
          }
        }
      } else {
        Image(systemName: "person.circle.fill")
          .resizable()
      }
    }
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
  let mockUrl = URL(
    string: "https://i.scdn.co/image/ab67616d00001e02ff9ca10b55ce82ae553c8228"
  )!
  return ProfileIconView(imageUrl: mockUrl, size: 80)
    .padding()
    .environment(MuseViewModel())
}
