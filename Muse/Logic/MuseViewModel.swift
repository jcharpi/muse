import SwiftUI

@Observable
class MuseViewModel: ObservableObject {
  typealias ButtonType = MuseModel.ButtonType
  typealias ButtonStyle = MuseModel.ButtonStyle
  typealias ButtonData = MuseModel.ButtonData
  typealias ButtonColor = (primaryColor: Color, secondaryColor: Color?)
  typealias Listener = MuseModel.Listener
  typealias MusicDisplayData = MuseModel.MusicDisplayData
  
  var selectedListener: Listener? = nil
  
  let listenerArray: [Listener] = [
    Listener(
      name: "Maya",
      listeningTo: MusicDisplayData(
        albumCover: "Weatherman",
        songTitle: "Easy on the Eyes",
        artistName: "Beautiful"
      ),
      sentRecommendation: true
    ),
    Listener(
      name: "Diego",
      listeningTo: MusicDisplayData(
        albumCover: "Weatherman",
        songTitle: "Goated on the Tech Hoe",
        artistName: "Epcot"
      ),
      recommendedMe: true
    ),
    Listener(
      name: "Nelly",
      listeningTo: MusicDisplayData(
        albumCover: "Weatherman",
        songTitle: "Mom's Spagooti",
        artistName: "Locked In"
      )
    ),
    Listener(
      name: "Emily",
      listeningTo: MusicDisplayData(
        albumCover: "Weatherman",
        songTitle: "Emiline",
        artistName: "GLOOstick"
      )
    ),
  ]
  
  private var model: MuseModel
  
  init() {
    self.model = MuseModel(listeners: listenerArray)
  }
  
  var listeners: [Listener] { model.listeners }
  
  var user: Listener { model.user }
  
  // MARK: - Intents
  func buttonTap(_ listener: Listener) {
    model.buttonTap(listener, listener.buttonToShow)
  }
  
  func textToDisplay(_ buttonType: ButtonType) -> String {
    model.textToDisplay(buttonType)
  }
  
  // MARK: - Button Information
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
  
  func buttonColors(for type: ButtonType) -> ButtonColor {
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
