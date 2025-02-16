import SwiftUI

struct MuseHomeView: View {
  @EnvironmentObject var viewModel: MuseViewModel

  var body: some View {
    TabView {
      Tab("Now Playing", systemImage: "play.fill") {
        nowPlaying
      }
      Tab("Nearby", systemImage: "wave.3.up") {
        MuseNearbyView()
      }
    }
    .tabViewStyle(.tabBarOnly)
    .tint(.primary)
  }
  
  var nowPlaying: some View {
    VStack {
      HeaderView()
      Spacer()
      Text("Now Playing")
        .font(.title)
        .fontWeight(.semibold)
        .foregroundStyle(.primary)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, Constants.horizontalPadding)
      MusicDisplayView(viewModel.user)
      Spacer()
      // TODO: Media controls
      Spacer()
    }
  }
  
  private struct Constants {
    static let horizontalPadding: CGFloat = 16
  }
}

#Preview {
  MuseHomeView()
    .environmentObject(MuseViewModel())
}
