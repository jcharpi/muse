import SwiftUI

struct MuseHomeView: View {
  @EnvironmentObject var viewModel: MuseViewModel
  @State private var showHeaderAlert = false

  var body: some View {
    TabView {
      Tab("Now Playing", systemImage: "play.fill") {
        nowPlaying
      }
      Tab("Nearby", systemImage: "wave.3.up") {
        MuseNearbyView()
      }
    }
    .tabViewStyle(.automatic)
    .tint(.primary)
    .fullScreenCover(isPresented: $viewModel.showSignIn) {
      SignInView()
        .environmentObject(viewModel)
    }
  }
  
  var nowPlaying: some View {
    VStack {
      Button {
        showHeaderAlert = true
      } label: {
        HeaderView()
      }
      .alert("Logout", isPresented: $showHeaderAlert) {
        Button("Cancel", role: .cancel) { }
        Button("Logout", role: .destructive) {
          viewModel.showSignIn = true
        }
      }
      
      Spacer()
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
