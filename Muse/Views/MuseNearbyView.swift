import SwiftUI

struct MuseNearbyView: View {
  @Environment(MuseViewModel.self) private var viewModel
  @State private var selectedListener: Listener?  // Local state mirror
    
  var body: some View {
    NavigationStack {
      List(viewModel.listeners) { listener in
        HStack {
          ListenerView(listener)
            .onTapGesture {
              selectedListener = listener  // Update local state
              viewModel.selectedListener = listener  // Sync with VM
            }
          Spacer()
          ButtonView(listener, style: .icon)
        }
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
      }
      .listRowSpacing(Constants.rowSpacing)
      .navigationTitle("Nearby Listeners")
      .sheet(item: $selectedListener) { _ in  // Use local state binding
        ListenerModalView()
          .environment(viewModel)
          .presentationDragIndicator(.visible)
      }
    }
  }
    
  private struct Constants {
    static let rowSpacing: CGFloat = 8
  }
}

#Preview {
  MuseNearbyView()
    .environment(MuseViewModel())
}
