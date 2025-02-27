import Foundation

struct Listener: IdentifiableEntity, MusicDisplayable {
  var id: String
  var name: String
  var profilePic: String
  var listeningTo: MusicDisplayData
  var recommendedSong: MusicDisplayData?
  var recommendedMe: Bool = false
  var sentRecommendation: Bool = false
    
  init(name: String,
       profilePic: String,
       listeningTo: MusicDisplayData,
       recommendedSong: MusicDisplayData? = nil,
       recommendedMe: Bool = false,
       sentRecommendation: Bool = false) {
    self.name = name
    self.profilePic = profilePic
    self.listeningTo = listeningTo
    self.recommendedSong = recommendedSong
    self.recommendedMe = recommendedMe
    self.sentRecommendation = sentRecommendation
    self.id = name
  }
    
  var buttonToShow: ButtonType {
    if recommendedMe {
      return .listen
    } else if sentRecommendation {
      return .shared
    } else {
      return .share
    }
  }
}
