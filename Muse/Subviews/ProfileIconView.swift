import SwiftUI

/// Circular profile image with async URL loading and a person-icon fallback.
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
          switch phase {
          case .success(let image):
            image.resizable().aspectRatio(contentMode: .fill)
          case .failure:
            fallbackImage
          default:
            ProgressView()
          }
        }
      } else {
        fallbackImage
      }
    }
    .frame(width: size, height: size)
    .clipShape(Circle())
    .background(
      Circle()
        .stroke(lineWidth: 4)
        .foregroundStyle(Color.primary)
    )
  }

  private var fallbackImage: some View {
    Image(systemName: "person.circle.fill")
      .resizable()
  }
}

#Preview {
  VStack {
    ProfileIconView(imageUrl: TestData.testUser.images.first?.url, size: 80)
    ProfileIconView(imageUrl: URL(string: "https://invalid.url"), size: 60)
    ProfileIconView(imageUrl: nil, size: 40)
  }
  .padding()
}
