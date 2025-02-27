import SwiftUI

@Observable
class MuseViewModel: ObservableObject {
  typealias ButtonColor = (primaryColor: Color, secondaryColor: Color?)

  var selectedListener: Listener? = nil
  var showSignIn: Bool = true
    
  private let listenerArray: [Listener] = [
    Listener(name: "Maya",
             profilePic: "maya",
             listeningTo: MusicDisplayData(albumCover: "weatherman",
                                           songTitle: "Amsterdam",
                                           artistName: "Gregory Alan Isakov"),
             sentRecommendation: true),
    Listener(name: "Diego",
             profilePic: "diego",
             listeningTo: MusicDisplayData(albumCover: "silkSonic",
                                           songTitle: "Skate",
                                           artistName: "Silk Sonic"),
             recommendedSong: MusicDisplayData(
              albumCover: "appaloosaBones",
              songTitle: "Silver Bell",
              artistName: "Gregory Alan Isakov"
             ),
             recommendedMe: true
            ),
    Listener(name: "Cayden",
             profilePic: "cayden",
             listeningTo: MusicDisplayData(albumCover: "billieEilish",
                                           songTitle: "CHIHIRO",
                                           artistName: "Billie Eilish")),
    Listener(name: "Emily",
             profilePic: "emily",
             listeningTo: MusicDisplayData(albumCover: "maggieRogers",
                                           songTitle: "Alaska",
                                           artistName: "Maggie Rogers"))
  ]
    
  private var model: MuseModel
    
  init() {
    self.model = MuseModel(listeners: listenerArray)
  }
    
  var listeners: [Listener] { model.listeners }
  var user: User { model.user }
    
  // MARK: - Intents
  func buttonTap(_ listener: Listener) {
    model.buttonTap(listener, listener.buttonToShow)
    // Update selected listener state if necessary.
    if selectedListener?.id == listener.id {
      selectedListener = model.listeners.first(where: { $0.id == listener.id })
    }
  }
    
  func textToDisplay(_ buttonType: ButtonType) -> String {
    model.textToDisplay(buttonType)
  }
    
  // MARK: - Button Configuration
  func buttonData(for type: ButtonType, style: ButtonStyle) -> ButtonData {
    switch (type, style) {
    case (.listen, .icon):
      return ButtonData(type: .listen, title: nil, icon: "music.note")
    case (.listen, .text):
      return ButtonData(type: .listen, title: "Listen", icon: nil)
    case (.login, .icon):
      return ButtonData(type: .login, title: nil, icon: "door.left.hand.open")
    case (.login, .text):
      return ButtonData(type: .login, title: "Login", icon: nil)
    case (.logout, .icon):
      return ButtonData(type: .logout, title: nil, icon: "door.right.hand.open")
    case (.logout, .text):
      return ButtonData(type: .logout, title: "Logout", icon: nil)
    case (.share, .icon):
      return ButtonData(type: .share, title: nil, icon: "bolt")
    case (.share, .text):
      return ButtonData(type: .share, title: "Share", icon: nil)
    case (.shared, .icon):
      return ButtonData(type: .shared, title: nil, icon: "bolt.fill")
    case (.shared, .text):
      return ButtonData(type: .shared, title: "Shared", icon: nil)
    }
  }
    
  func buttonColors(for type: ButtonType) -> (
    primaryColor: Color,
    secondaryColor: Color?
  ) {
    switch type {
    case .listen, .login:
      return (.green, .black)
    case .logout, .share:
      return (.pink, .white)
    case .shared:
      return (.red, .white)
    }
  }
}
