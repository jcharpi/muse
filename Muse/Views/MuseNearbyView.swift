import SwiftUI

struct MuseNearbyView: View {
  @Environment(MuseViewModel.self) private var viewModel

  var body: some View {
    @Bindable var vm = viewModel
    NavigationStack {
      List(vm.listeners) { listener in
        HStack {
          ListenerView(listener)
            .onTapGesture { viewModel.selectedListener = listener }
          Spacer()
          ButtonView(listener, style: .icon)
        }
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
      }
      .listRowSpacing(8)
      .navigationTitle("Nearby Listeners")
      .sheet(item: $vm.selectedListener) { _ in
        ListenerModalView()
          .environment(viewModel)
          .presentationDragIndicator(.hidden)
      }
    }
  }
}

#Preview {
  let model = MuseModel(musicService: MockMusicService())
  model.setTestData(user: TestData.testUser, listeners: TestData.testListeners)
  return MuseNearbyView()
    .environment(MuseViewModel(model: model))
    .environmentObject(SpotifyController())
}
