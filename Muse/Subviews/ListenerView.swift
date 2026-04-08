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

      VStack(alignment: .leading, spacing: 8) {
        Text(listener.displayName)
          .font(.title2)
        Text(listener.buttonToShow.statusText)
          .font(.subheadline)
      }
      .fontWeight(.semibold)

      Spacer()
    }
    .contentShape(Rectangle())
  }
}

#Preview {
  let model = MuseModel(musicService: MockMusicService())
  model.setTestData(user: TestData.testUser, listeners: TestData.testListeners)

  return VStack(spacing: 16) {
    ForEach(TestData.testListeners) { listener in
      ListenerView(listener)
    }
  }
  .padding()
  .environment(MuseViewModel(model: model))
}
