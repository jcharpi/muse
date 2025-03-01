import SwiftUI

struct MusicDisplayView: View {
  let musicListener: any MusicDisplayable
    
  init(_ musicListener: any MusicDisplayable) {
    self.musicListener = musicListener
  }
  
  var body: some View {
    if let listener = musicListener as? Listener {
      if let recommendedMe = listener.recommendedMe {
        // Listener with recommended song
        TabView {
          SongTabView(data: recommendedMe, headerTitle: "Recommended Song")
          SongTabView(data: listener.listeningTo, headerTitle: "Now Listening")
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
      } else {
        // Listener without recommended song: Single view
        SongTabView(data: listener.listeningTo, headerTitle: "Now Listening")
      }
    } else {
      // User or other types: Show "Now Playing"
      SongTabView(data: musicListener.listeningTo, headerTitle: "Now Playing")
    }
  }
    
  private struct SongTabView: View {
    let data: MusicDisplayData
    let headerTitle: String
    var body: some View {
      VStack(alignment: .center) {
        Text(headerTitle)
          .font(.largeTitle)
          .fontWeight(.semibold)
          .foregroundStyle(.primary)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.horizontal, Constants.horizontalPadding)
                
        Image(data.albumCover)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .overlay(
            Rectangle()
              .stroke(Color.primary, lineWidth: Constants.albumStroke)
          )
          .padding(.horizontal, Constants.horizontalPadding)
          .padding(.vertical, Constants.verticalPadding)
                
        songDetails
      }.frame(width: Constants.screenWidth)
    }
        
    @ViewBuilder
    private var songDetails: some View {
      Group {
        Text(data.songTitle)
          .font(.title2)
          .fontWeight(.medium)
          .padding(.top, Constants.songTitleTopPadding)
          .padding(.bottom, Constants.songTitleBottomPadding)
        Text(data.artistName)
          .font(.title3)
          .fontWeight(.regular)
          .opacity(Constants.opacity)
          .padding(.bottom, Constants.songArtistBottomPadding)
      }
      .foregroundStyle(Color.primary)
      .padding(.horizontal, Constants.horizontalPadding)
      .frame(maxWidth: .infinity, alignment: .leading)
    }
        
    private struct Constants {
      static let horizontalPadding: CGFloat = 16
      static let verticalPadding: CGFloat = 8
      static let songTitleTopPadding: CGFloat = 8
      static let songTitleBottomPadding: CGFloat = 4
      static let songArtistBottomPadding: CGFloat = 60
      static let albumStroke: CGFloat = 2
      static let opacity: CGFloat = 0.8
      static let screenWidth = UIScreen.main.bounds.width * 0.98
    }
  }
}

#Preview {
  MusicDisplayView(
    Listener(
      name: "Test",
      profilePic: "Josh",
      listeningTo: .init(
        albumCover: "weatherman",
        songTitle: "Amsterdam",
        artistName: "Gregory Alan Isakov"
      ),
      recommendedMe: .init(
        albumCover: "unrealUnearth",
        songTitle: "Eat Your Young",
        artistName: "Hozier"
      )
    )
  )
  .environmentObject(MuseViewModel())
}
