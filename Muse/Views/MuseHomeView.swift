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
                  .tint(.green)
                }
              }
              .swipeActions(edge: .leading) {
                if listener.listeningTo != nil {
                  Button {
                    viewModel.queueTrack(for: listener)
                  } label: {
                    Label("Queue", systemImage: "text.badge.plus")
                  }
                  .tint(Color.queueAction)
                }
              }
          }
          .listRowSeparator(.hidden)
          .listRowBackground(Color.clear)
        } header: {
          Text("Nearby")
            .font(.title2)
            .fontWeight(.bold)
            .foregroundStyle(.primary)
            .textCase(nil)
        }
      }
      .listStyle(.plain)
      .sheet(item: $vm.selectedListener) { _ in
        ListenerModalView()
          .environment(viewModel)
          .presentationDragIndicator(.hidden)
      }
    }
    .overlay(alignment: .bottom) { toastOverlay }
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
    if let toast = viewModel.toastMessage {
      Text(toast)
        .font(.subheadline)
        .fontWeight(.medium)
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(Capsule().fill(.ultraThinMaterial))
        .padding(.bottom, 24)
        .transition(.move(edge: .bottom).combined(with: .opacity))
        .onAppear {
          DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation { viewModel.toastMessage = nil }
          }
        }
    }
  }
}

// MARK: - App Colors
extension Color {
  /// #B91D6F — used for queue swipe action
  static let queueAction = Color(red: 0.73, green: 0.11, blue: 0.44)
}

#Preview {
  let model = MuseModel(musicService: MockMusicService())
  model.setTestData(user: TestData.testUser, listeners: TestData.testListeners)
  return MuseHomeView()
    .environment(MuseViewModel(model: model))
    .environmentObject(SpotifyController())
}
