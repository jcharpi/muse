import SwiftUI

/// Displays detailed song information including:
/// - Album artwork (either current track or generic)
/// - Track title and artists
/// - Context-specific header (e.g., "Now Playing")
///
/// Handles multiple display scenarios:
/// 1. Current track with high-res SDK artwork
/// 2. Other tracks with URL-loaded artwork
/// 3. Fallback state when no track is available
struct SongTabView: View {
  // MARK: - Music Data Properties
    
  /// Connection to Spotify controller for real-time updates
  @EnvironmentObject private var spotifyController: SpotifyController
    
  /// The track to display, nil means no current playback
  let track: SpotifyTrack?
    
  /// Header text explaining context:
  /// - "Now Playing" for current user
  /// - "Recommended Song" for others
  /// - "No Track Available" when inactive
  let headerTitle: String
    
  // MARK: - Main View Structure
    
  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        // Vertical stack contains:
        // 1. Header text
        // 2. Album artwork
        // 3. Track details (if available)
        headerView
        albumArtView
                
        if let track = track {
          trackInfoView(for: track)
        }
      }
      .padding(.horizontal, Constants.horizontalPadding)
    }
  }
    
  // MARK: - Subcomponents
    
  /// Dynamic header that adapts to container width
  private var headerView: some View {
    Text(headerTitle)
      .font(.title)
      .fontWeight(.semibold)
      .foregroundStyle(.primary)
    // Expand to full width while keeping text aligned left
      .frame(maxWidth: .infinity, alignment: .leading)
  }
    
  /// Album artwork display with three potential states:
  /// 1. High-res image from Spotify SDK (current track)
  /// 2. Async-loaded image from URL (other tracks)
  /// 3. Fallback music note icon (no artwork available)
  private var albumArtView: some View {
    Group {
      if let track = track,
         track.uri == spotifyController.currentTrack?.uri,
         let image = spotifyController.currentTrackImage {
        // Current track uses optimized SDK image
        Image(uiImage: image)
          .resizable()
          .scaledToFit()
      } else {
        // Other tracks use standard URL loading
        AsyncImage(url: track?.album.images.first?.url) { phase in
          if case .success(let image) = phase {
            // Successfully loaded remote image
            image
              .resizable()
              .scaledToFit()
          } else {
            // Show placeholder during loading/errors
            fallbackAlbumArt
          }
        }
      }
    }
    .aspectRatio(Constants.aspectRatio, contentMode: .fit)
    .frame(maxWidth: UIScreen.main.bounds.width)
    .overlay(
      // Add subtle border around artwork
      Rectangle()
        .stroke(Color.primary, lineWidth: Constants.albumStroke)
    )
  }
    
  /// Fallback display when no artwork available
  private var fallbackAlbumArt: some View {
    Image(systemName: "music.note")
      .resizable()
      .scaledToFit()
      .padding()  // Prevent icon from touching edges
  }
    
  /// Track information section showing:
  /// - Song title (primary focus)
  /// - Artist list (secondary information)
  private func trackInfoView(for track: SpotifyTrack) -> some View {
    VStack(alignment: .leading) {
      Text(track.name)
        .font(.title2)
        .fontWeight(.medium)
        .padding(.top, Constants.songTitleTopPadding)
            
      // Combine multiple artists into comma-separated string
      Text(track.artists.map { $0.name }.joined(separator: ", "))
        .font(.title3)
        .opacity(Constants.opacity)  // Subtle appearance for secondary info
    }
  }
    
  // MARK: - Layout Constants
    
  /// Centralized layout values for consistent styling
  private struct Constants {
    /// Square aspect ratio for all artwork
    static let aspectRatio: CGFloat = 1
    /// Horizontal padding around content
    static let horizontalPadding: CGFloat = 16
    /// Spacing between song title and artist
    static let songTitleTopPadding: CGFloat = 8
    /// Border thickness around artwork
    static let albumStroke: CGFloat = 2
    /// Artist name transparency level
    static let opacity: CGFloat = 0.8
  }
}

// MARK: - Preview Configurations

/// SwiftUI previews showing different display states
#Preview("Current Track with Artwork") {
  SongTabView(
    track: TestData.testListeners[1].listeningTo,
    headerTitle: "Now Listening"
  )
  .environmentObject(SpotifyController())  // Simulate logged-in state
}

#Preview("User Without Artwork") {
  SongTabView(
    track: TestData.testUser.listeningTo,
    headerTitle: "Now Playing"
  )
}

#Preview("Inactive State") {
  SongTabView(
    track: nil,
    headerTitle: "No Track Available"
  )
}
