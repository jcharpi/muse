import Foundation

struct User: Identifiable, MusicDisplayable {
  let id: String
  let name: String
  var listeningTo: MusicDisplayData

  init(name: String, listeningTo: MusicDisplayData) {
    self.name = name
    self.listeningTo = listeningTo
    self.id = name
  }
}
