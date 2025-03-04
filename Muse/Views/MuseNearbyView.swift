import SwiftUI

/// A view displaying nearby music listeners and their current activity
struct MuseNearbyView: View {
  // MARK: - Properties
  @Environment(MuseViewModel.self) private var viewModel
  /// Local state tracking selected listener for modal presentation
  @State private var selectedListener: Listener?
    
  // MARK: - Main View
  var body: some View {
    NavigationStack {
      listenerList
        .navigationTitle("Nearby Listeners")
        .sheet(item: $selectedListener) { _ in
          listenerModal
        }
    }
  }
    
  // MARK: - View Components
  /// List displaying nearby listeners with interactive elements
  private var listenerList: some View {
    List(viewModel.listeners) { listener in
      HStack {
        listenerRow(listener)
        Spacer()
        ButtonView(listener, style: .icon)
      }
      .listRowStyling()
    }
    .listRowSpacing(Constants.rowSpacing)
  }
    
  /// Individual listener row with tap handling
  private func listenerRow(_ listener: Listener) -> some View {
    ListenerView(listener)
      .onTapGesture {
        handleListenerSelection(listener)
      }
  }
    
  /// Modal view for selected listener details
  private var listenerModal: some View {
    ListenerModalView()
      .environment(viewModel)
      .presentationDragIndicator(.visible)
  }
    
  // MARK: - Actions
  /// Handles listener selection and state synchronization
  private func handleListenerSelection(_ listener: Listener) {
    selectedListener = listener
    viewModel.selectedListener = listener
  }
    
  // MARK: - Constants
  /// Visual constants for layout configuration
  private struct Constants {
    static let rowSpacing: CGFloat = 8
  }
}

// MARK: - View Modifiers
private extension View {
  /// Standard styling for list rows
  func listRowStyling() -> some View {
    self
      .listRowBackground(Color.clear)
      .listRowSeparator(.hidden)
  }
}

// MARK: - Previews
#Preview {
  // Configure preview with test data
  let model = MuseModel(musicService: MockMusicService())
  model.setTestData(
    user: TestData.testUser,
    listeners: TestData.testListeners
  )
  let viewModel = MuseViewModel(model: model)
    
  return MuseNearbyView()
    .environment(viewModel)
}
