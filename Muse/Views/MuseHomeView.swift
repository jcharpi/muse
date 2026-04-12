import SwiftUI

struct MuseHomeView: View {
  @Environment(MuseViewModel.self) private var viewModel
  @EnvironmentObject private var spotifyController: SpotifyController

  @State private var showDisconnectAlert = false

  var body: some View {
    @Bindable var vm = viewModel
    NavigationStack {
      List {
        // MARK: - Now Playing Section
        Section {
          Button { showDisconnectAlert = true } label: { HeaderView() }
            .alert("Disconnect", isPresented: $showDisconnectAlert) {
              Button("Cancel", role: .cancel) {}
              Button("Disconnect", role: .destructive) {
                spotifyController.signOut()
              }
            }

          MusicDisplayView(user: viewModel.user)
            .frame(maxHeight: 350)
        }
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets())
        .listRowBackground(Color.clear)

        // MARK: - Nearby Listeners Section
        Section {
          ForEach(vm.listeners) { listener in
            ListenerView(listener)
              .onTapGesture { viewModel.selectedListener = listener }
              .swipeActions(edge: .trailing) {
                if listener.listeningTo != nil {
                  Button {
                    viewModel.playTrack(for: listener)
                  } label: {
                    Label("Play", systemImage: "play.fill")
                  }
                  .tint(.appGreen)
                }
              }
              .swipeActions(edge: .leading) {
                if listener.listeningTo != nil {
                  Button {
                    viewModel.queueTrack(for: listener)
                  } label: {
                    Label("Queue", systemImage: "text.badge.plus")
                  }
                  .tint(.appMagenta)
                }
              }
          }
          .listRowSeparator(.hidden)
          .listRowBackground(Color.clear)
        } header: {
          Text("Nearby")
            .font(.title2)
            .fontWeight(.bold)
            .tint(Color.white)
            .foregroundStyle(.primary)
            .textCase(nil)
        }
      }
      .listStyle(.plain)
      .scrollContentBackground(.hidden)
      .background(Color.appBackground)
      .sheet(item: $vm.selectedListener) { _ in
        ListenerModalView()
          .environment(viewModel)
          .presentationDragIndicator(.hidden)
      }
    }
    .overlay(alignment: .bottom) { toastOverlay }
    .animation(.easeInOut(duration: 0.3), value: viewModel.toast == nil)
    .alert("Something went wrong", isPresented: Binding(
      get: { vm.errorMessage != nil },
      set: { if !$0 { vm.errorMessage = nil } }
    )) {
      Button("OK", role: .cancel) { viewModel.errorMessage = nil }
    } message: {
      Text(viewModel.errorMessage ?? "")
    }
  }

  // MARK: - Toast Overlay
  @ViewBuilder
  private var toastOverlay: some View {
    if let toast = viewModel.toast {
      Text(toast.message)
        .font(.subheadline)
        .fontWeight(.medium)
        .foregroundStyle(.white)
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(Capsule().fill(toast.color))
        .padding(.bottom, 24)
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
  }
}

// MARK: - App Colors
extension Color {
  static let appBackground = Color(red: 30/255,  green: 30/255,  blue: 30/255)   // #1E1E1E
  static let appGreen      = Color(red: 29/255,  green: 185/255, blue: 84/255)   // #1DB954
  static let appMagenta    = Color(red: 185/255, green: 29/255,  blue: 111/255)  // #B91D6F
}

#Preview {
  let model = MuseModel(musicService: MockMusicService())
  model.setTestData(user: TestData.testUser, listeners: TestData.testListeners)
  return MuseHomeView()
    .environment(MuseViewModel(model: model))
    .environmentObject(SpotifyController())
}
