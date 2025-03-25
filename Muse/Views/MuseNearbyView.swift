import SwiftUI

// MARK: - MuseNearbyView
/// Displays a scrollable list of nearby listeners with interaction capabilities
struct MuseNearbyView: View {
  // MARK: - Dependencies
  @Environment(MuseViewModel.self) private var viewModel
  
  // MARK: - State
  @State private var selectedListener: Listener? // Drives modal presentation

  // MARK: - Body
  var body: some View {
    NavigationStack {
      listenerList
        .navigationTitle("Nearby Listeners")
        .sheet(item: $selectedListener) { _ in listenerModal }
    }
  }

  // MARK: - Components
  /// Scrollable list of listener rows
  private var listenerList: some View {
    List(viewModel.listeners) { listener in
      HStack {
        listenerRow(listener)
        Spacer()
        ButtonView(listener, style: .icon) // Action button
      }
      .listRowStyling()
    }
    .listRowSpacing(Constants.rowSpacing)
  }

  /// Individual listener row with tap interaction
  private func listenerRow(_ listener: Listener) -> some View {
    ListenerView(listener)
      .onTapGesture { handleListenerSelection(listener) }
  }

  /// Modal detail view for selected listener
  private var listenerModal: some View {
    ListenerModalView()
      .environment(viewModel)
      .presentationDragIndicator(.hidden)
  }

  // MARK: - Actions
  /// Updates selected listener state
  private func handleListenerSelection(_ listener: Listener) {
    selectedListener = listener
    viewModel.selectedListener = listener // Sync with ViewModel
  }

  // MARK: - Constants
  private struct Constants {
    static let rowSpacing: CGFloat = 8
  }
}

// MARK: - View Modifiers
private extension View {
  /// Standardizes list row appearance
  func listRowStyling() -> some View {
    self
      .listRowBackground(Color.clear)
      .listRowSeparator(.hidden)
  }
}

// MARK: - Previews
#Preview {
  let model = MuseModel(musicService: MockMusicService())
  model.setTestData(user: TestData.testUser, listeners: TestData.testListeners)
  return MuseNearbyView()
    .environment(MuseViewModel(model: model))    
    .environmentObject(SpotifyController())
}
