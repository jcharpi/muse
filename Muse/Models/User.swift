import Foundation

struct User: IdentifiableEntity, MusicDisplayable {
  var id: String
  var name: String
  var listeningTo: MusicDisplayData

  init(name: String, listeningTo: MusicDisplayData) {
    self.name = name
    self.listeningTo = listeningTo
    self.id = name
  }
}
