import SwiftUI

struct ProfileIconView: View {
  // Holds an optional URL for fetching the profile image asynchronously.
  private let imageUrl: URL?
  // Defines the overall dimensions, ensuring a uniform circular appearance.
  private let size: CGFloat
    
  /// Enables dependency injection for testing or custom configurations.
  init(imageUrl: URL?, size: CGFloat) {
    self.imageUrl = imageUrl
    self.size = size
  }
    
  var body: some View {
    Group {
      if let imageUrl {
        AsyncImage(url: imageUrl) { phase in
          if let image = phase.image {
            // Successfully retrieved images are adjusted to fill the container.
            image
              .resizable()
              .aspectRatio(contentMode: .fill)
          } else if phase.error != nil {
            // Fallback in case of a loading error maintains consistency.
            Image(systemName: "person.circle.fill")
              .resizable()
          } else {
            // Indicates an ongoing loading process.
            ProgressView()
          }
        }
      } else {
        // Directly use a default placeholder if no URL is provided.
        Image(systemName: "person.circle.fill")
          .resizable()
      }
    }
    // Constrains the view to a square before applying a circular clip.
    .frame(width: size, height: size)
    .clipShape(Circle())
    // Adds a border overlay to enhance visual definition.
    .background(
      Circle()
        .stroke(lineWidth: Constants.lineWidth)
        .foregroundStyle(Color.primary)
    )
  }
    
  private struct Constants {
    // Centralized constant for the border stroke width.
    static let lineWidth: CGFloat = 4.0
  }
}

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
