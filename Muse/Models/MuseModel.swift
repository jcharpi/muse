import Foundation

struct MuseModel {
  private(set) var listeners: [Listener]
  private(set) var user: User
    
  init(listeners: [Listener],
       user: User = User(name: "User", listeningTo: MusicDisplayData(albumCover: "Weatherman",
                                                                     songTitle: "Bumpin' Song",
                                                                     artistName: "Artist"))) {
    self.listeners = listeners
    self.user = user
  }
    
  mutating func buttonTap(_ listener: Listener, _ type: ButtonType) {
    guard let index = listeners.firstIndex(where: { $0.id == listener.id }) else {
      print("Listener not found")
      return
    }
        
    switch type {
    case .share:
      listeners[index].sentRecommendation = true
    case .listen:
      print("Open Spotify")
    default:
      print("Unhandled button type")
    }
  }
    
  func textToDisplay(_ buttonType: ButtonType) -> String {
    switch buttonType {
    case .listen:
      return "Recommended you a song"
    default:
      return "Listening nearby"
    }
  }
}
