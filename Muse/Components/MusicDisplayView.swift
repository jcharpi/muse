import SwiftUI

struct MusicDisplayView: View {
  let musicListener: any MusicDisplayable
    
  init(_ musicListener: any MusicDisplayable) {
    self.musicListener = musicListener
  }
  
  private let screenWidth = UIScreen.main.bounds.width
    
  var body: some View {
    VStack(alignment: .leading) {
      Image(musicListener.listeningTo.albumCover) //TODO: Make dynamic
        .resizable()
        .padding(.horizontal, Constants.horizontalPadding)
        .frame(width: screenWidth, height: screenWidth)
      
      songDetails
    }
  }
  
  @ViewBuilder
  var songDetails: some View {
    Group {
      Text(musicListener.listeningTo.songTitle)
        .font(.title2)
        .fontWeight(.medium)
        .padding(.top, Constants.songTitleTopPadding)
        .padding(.bottom, Constants.songTitleBottomPadding)
      Text(musicListener.listeningTo.artistName)
        .font(.title3)
        .fontWeight(.regular)
        .opacity(Constants.opacity)
    }
    .foregroundStyle(Color.primary)
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal, Constants.horizontalPadding)
  }
  
  private struct Constants {
    static let horizontalPadding: CGFloat = 16
    static let songTitleTopPadding: CGFloat = 16
    static let songTitleBottomPadding: CGFloat = 4
    static let opacity: CGFloat = 0.8
  }
}

#Preview {
  MusicDisplayView(
    Listener(
      name: "Test",
      listeningTo: .init(
        albumCover: "Weatherman",
        songTitle: "Frog",
        artistName: "Test Artist"
      )
    )
  )
  .environmentObject(MuseViewModel())
}
