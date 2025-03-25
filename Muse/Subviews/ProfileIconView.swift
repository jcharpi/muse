import SwiftUI

// MARK: - ProfileIconView
/// Displays a circular profile image with optional Spotify artwork.
/// - Handles loading states and fallback UI.
struct ProfileIconView: View {
  // MARK: - Properties
  private let imageUrl: URL?
  private let size: CGFloat
  
  // MARK: - Initialization
  init(imageUrl: URL?, size: CGFloat) {
    self.imageUrl = imageUrl
    self.size = size
  }
  
  // MARK: - Body
  var body: some View {
    Group {
      if let imageUrl {
        AsyncImage(url: imageUrl) { phase in
          switch phase {
          case .success(let image): loadedImage(image)
          case .failure: fallbackImage
          default: ProgressView()
          }
        }
      } else {
        fallbackImage
      }
    }
    .frame(width: size, height: size)
    .clipShape(Circle())
    .background(circleBorder)
  }
  
  // MARK: - Subviews
  private func loadedImage(_ image: Image) -> some View {
    image
      .resizable()
      .aspectRatio(contentMode: .fill)
  }
  
  private var fallbackImage: some View {
    Image(systemName: "person.circle.fill")
      .resizable()
  }
  
  private var circleBorder: some View {
    Circle()
      .stroke(lineWidth: Constants.lineWidth)
      .foregroundStyle(Color.primary)
  }
  
  // MARK: - Constants
  private struct Constants {
    static let lineWidth: CGFloat = 4.0
  }
}

// MARK: - Previews
#Preview {
  VStack {
    // Simulates a typical user scenario with valid image data.
    ProfileIconView(
      imageUrl: TestData.testUser.images.first?.url,
      size: 80
    )
        
    // Tests the error path with an invalid URL.
    ProfileIconView(
      imageUrl: URL(string: "https://invalid.url"),
      size: 60
    )
        
    // Represents the state when no image data is available.
    ProfileIconView(
      imageUrl: nil,
      size: 40
    )
  }
  .padding()
  .environment(MuseViewModel())
}
