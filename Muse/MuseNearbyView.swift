import SwiftUI

struct MuseNearbyView: View {
  @EnvironmentObject var viewModel: MuseViewModel
  
  init() {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithTransparentBackground()
    appearance.backgroundColor = Constants.navBarColor
    appearance.largeTitleTextAttributes = [.foregroundColor: Constants.navBarTextColor]
    appearance.titleTextAttributes = [.foregroundColor: Constants.navBarTextColor]
    
    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().compactAppearance = appearance
  }
  
  var body: some View {
    NavigationStack {
      List(viewModel.listeners) { listener in
        ListenerView(listener)
          .onTapGesture {
            viewModel.selectedListener = listener
          }
          .listRowBackground(Color.clear)
      }
      .listStyle(PlainListStyle())
      .background(Constants.backgroundColor)
      .navigationTitle("Nearby Listeners")
      .navigationBarTitleDisplayMode(.large)
      .sheet(item: $viewModel.selectedListener) { listener in
        ListenerModalView(listener)
          .presentationDetents(
            [.fraction(Constants.sheetFraction)]
          )
          .presentationDragIndicator(.visible)
      }
    }
  }
  
  private struct Constants {
    static let backgroundColor: Color = Color.black.opacity(0.8)
    static let sheetFraction: CGFloat = 0.9
    static let navBarColor: UIColor = .darkGray
    static let navBarTextColor: UIColor = .white
  }
}
#Preview {
  MuseNearbyView()
    .environmentObject(MuseViewModel())
}
