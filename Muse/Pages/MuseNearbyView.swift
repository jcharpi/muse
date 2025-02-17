import SwiftUI

struct MuseNearbyView: View {
  @EnvironmentObject var viewModel: MuseViewModel
  
  var body: some View {
    NavigationStack {
      List(viewModel.listeners) { listener in
        HStack {
          ListenerView(listener)
            .onTapGesture {
              viewModel.selectedListener = listener
            }
          Spacer()
          ButtonView(listener, style: .icon)
        }
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
      }
      .listRowSpacing(Constants.rowSpacing)
      .listStyle(PlainListStyle())
      .navigationTitle("Nearby Listeners")
      .sheet(item: $viewModel.selectedListener) { _ in
        ListenerModalView()
          .presentationDragIndicator(.visible)
      }
    }
  }
  
  private struct Constants {
    static let sheetFraction: CGFloat = 0.9
    static let rowSpacing: CGFloat = 8
  }
}

#Preview {
  MuseNearbyView()
    .environmentObject(MuseViewModel())
}
