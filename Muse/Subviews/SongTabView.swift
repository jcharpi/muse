import SwiftUI

struct SongTabView: View {
  // Optional track accommodates scenarios where user isn't actively listening to a song
  let track: SpotifyTrack?
  // Provides context-specific titling for the view.
  let headerTitle: String
    
  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        // Separates the title from the visual content.
        headerView
        
        // Leverages asynchronous image loading with a graceful fallback.
        albumArtView
                
        // Conditional rendering to ensure UI consistency when track data is missing.
        if let track = track {
          trackInfoView(for: track)
        }
      }
      .padding(.horizontal, Constants.horizontalPadding)
    }
  }
    
  // MARK: - Components
  
  // Flexible header, adapting to various container widths.
  private var headerView: some View {
    Text(headerTitle)
      .font(.title)
      .fontWeight(.semibold)
      .foregroundStyle(.primary)
      .frame(maxWidth: .infinity, alignment: .leading)
  }
    
  // AsyncImage is used for remote album art; a fallback ensures visual stability.
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
      // An overlay stroke creates a consistent framing for the album art.
      Rectangle()
        .stroke(Color.primary, lineWidth: Constants.albumStroke)
    )
  }
    
  // Provides a fallback visual element to maintain layout integrity.
  private var fallbackAlbumArt: some View {
    Image(systemName: "music.note")
      .resizable()
      .scaledToFit()
      .padding()
  }
    
  // Consolidates track details into a clean presentation, merging multiple artist names.
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
  // Centralizes layout metrics for consistency and easier future adjustments.
  private struct Constants {
    static let aspectRatio: CGFloat = 1
    static let horizontalPadding: CGFloat = 16
    static let songTitleTopPadding: CGFloat = 8
    static let albumStroke: CGFloat = 2
    static let opacity: CGFloat = 0.8
  }
}

// MARK: - Previews
// Previews simulate different data conditions to verify component behavior.
#Preview("Listener with album art") {
  SongTabView(
    track: TestData.testListeners[1].listeningTo,
    headerTitle: "Now Listening"
  )
}

#Preview("User without album art") {
  SongTabView(
    track: TestData.testUser.listeningTo,
    headerTitle: "Now Playing"
  )
}

#Preview("No track available") {
  SongTabView(
    track: nil,
    headerTitle: "No Track Available"
  )
}
