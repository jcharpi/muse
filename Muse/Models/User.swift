import Foundation

struct User: IdentifiableEntity, MusicDisplayable {
  var id: String
  var name: String
  var profilePic: String
  var listeningTo: MusicDisplayData

  init(name: String, profilePic: String, listeningTo: MusicDisplayData) {
    self.name = name
    self.profilePic = profilePic
    self.listeningTo = listeningTo
    self.id = name
  }
}
