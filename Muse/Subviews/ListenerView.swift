import SwiftUI

struct ListenerView: View {
  let listener: Listener

  init(_ listener: Listener) {
    self.listener = listener
  }

  var body: some View {
    HStack {
      ProfileIconView(imageUrl: listener.images.first?.url, size: 56)
        .padding(.trailing, 4)

      VStack(alignment: .leading, spacing: 4) {
        Text(listener.displayName)
          .font(.title2)
          .fontWeight(.semibold)
        Text(listener.listeningTo.map { "\($0.name) — \($0.artists.map(\.name).joined(separator: ", "))" } ?? "Not playing")
          .font(.subheadline)
          .foregroundStyle(.secondary)
          .lineLimit(1)
      }

      Spacer()
    }
    .contentShape(Rectangle())
  }
}

#Preview {
  VStack(spacing: 16) {
    ForEach(TestData.testListeners) { listener in
      ListenerView(listener)
    }
  }
  .padding()
}
