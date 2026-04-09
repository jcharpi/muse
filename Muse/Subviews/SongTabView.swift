import SwiftUI

/// Displays a single track: album art, title, and artist list.
/// Header is only rendered when headerTitle is non-empty.
struct SongTabView: View {
  @EnvironmentObject private var spotifyController: SpotifyController

  let track: SpotifyTrack?
  let headerTitle: String

  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        if !headerTitle.isEmpty { headerView }
        albumArtView
        if let track { trackInfoView(for: track) }
      }
      .padding(.horizontal, 16)
    }
  }

  private var headerView: some View {
    Text(headerTitle)
      .font(.title)
      .fontWeight(.semibold)
      .frame(maxWidth: .infinity, alignment: .leading)
  }

  private var albumArtView: some View {
    Group {
      if let track,
         track.uri == spotifyController.currentTrack?.uri,
         let image = spotifyController.currentTrackImage {
        Image(uiImage: image)
          .resizable()
          .scaledToFit()
      } else {
        AsyncImage(url: track?.album.images.first?.url) { phase in
          if case .success(let image) = phase {
            image.resizable().scaledToFit()
          } else {
            fallbackAlbumArt
          }
        }
      }
    }
    .aspectRatio(1, contentMode: .fit)
    .frame(maxWidth: .infinity)
    .overlay(Rectangle().stroke(Color.primary, lineWidth: 2))
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
        .padding(.top, 8)

      Text(track.artists.map { $0.name }.joined(separator: ", "))
        .font(.title3)
        .opacity(0.8)
    }
  }
}

#Preview("With Header") {
  SongTabView(track: TestData.testUser.listeningTo, headerTitle: "Now Playing")
    .environmentObject(SpotifyController())
}

#Preview("No Header") {
  SongTabView(track: TestData.testListeners[0].listeningTo, headerTitle: "")
    .environmentObject(SpotifyController())
}

#Preview("No Track") {
  SongTabView(track: nil, headerTitle: "")
    .environmentObject(SpotifyController())
}
