import SwiftUI

struct HeaderView: View {
  var body: some View {
    HStack {
      Spacer()
      ProfileIconView(Image("joshc28"), size: Constants.profileIconSize)
        .padding(.trailing, Constants.trailingPadding)
        .padding(.leading, Constants.leadingPadding)
    }
    .padding(.vertical)
  }
  
  private struct Constants {
    static let profileIconSize: CGFloat = 40
    static let trailingPadding: CGFloat = 16
    static let leadingPadding: CGFloat = 8
  }
}

#Preview {
  HeaderView()
}
