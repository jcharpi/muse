import SwiftUI

struct SongTabView: View {
  let track: SpotifyTrack?  // Made optional
  let headerTitle: String
    
  var body: some View {
    HStack {
      Spacer()
      VStack(alignment: .leading) {
        headerView
        albumArtView
                
        // Only show track info if track exists
        if let track = track {
          trackInfoView(for: track)
        }
      }
      .padding(.horizontal, Constants.horizontalPadding)
      Spacer()
    }
  }
    
  // MARK: - Components
  private var headerView: some View {
    Text(headerTitle)
      .font(.largeTitle)
      .fontWeight(.semibold)
      .foregroundStyle(.primary)
      .frame(maxWidth: .infinity, alignment: .leading)
  }
    
  private var albumArtView: some View {
    AsyncImage(url: track?.album.images.first?.url) { phase in
      switch phase {
      case .success(let image):
        image
          .resizable()
          .scaledToFit()
      default:
        fallbackAlbumArt
      }
    }
    .aspectRatio(Constants.aspectRatio, contentMode: .fit)
    .frame(maxWidth: UIScreen.main.bounds.width)
    .overlay(
      Rectangle()
        .stroke(Color.primary, lineWidth: Constants.albumStroke)
    )
  }
    
  private var fallbackAlbumArt: some View {
    Image(systemName: "music.note")
      .resizable()
      .scaledToFit()
      .padding()
  }
    
  private func trackInfoView(for track: SpotifyTrack) -> some View {
    VStack(alignment: .leading) {
      Text(track.name)
        .font(.title2)
        .fontWeight(.medium)
        .padding(.top, Constants.songTitleTopPadding)
            
      Text(track.artists.map { $0.name }.joined(separator: ", "))
        .font(.title3)
        .opacity(Constants.opacity)
    }
  }
    
  // MARK: - Constants
  private struct Constants {
    static let aspectRatio: CGFloat = 1
    static let horizontalPadding: CGFloat = 16
    static let songTitleTopPadding: CGFloat = 8
    static let albumStroke: CGFloat = 2
    static let opacity: CGFloat = 0.8
  }
}

// MARK: - Preview
#Preview {
  SongTabView(
    track: nil,  // Nil track test case
    headerTitle: "No Track Available"
  )
}

#Preview {
  SongTabView(
    track: SpotifyTrack(
      uri: "spotify:track:preview123",
      name: "Sample Track",
      artists: [
        SpotifyArtist(id: "artist1", name: "Sample Artist 1"),
        SpotifyArtist(id: "artist2", name: "Sample Artist 2")
      ],
      album: SpotifyAlbum(images: [])
    ),
    headerTitle: "Preview Track"
  )
}
