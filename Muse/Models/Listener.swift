import Foundation

struct Listener: IdentifiableEntity, MusicDisplayable {
  var id: String
  var name: String
  var profilePic: String
  var listeningTo: MusicDisplayData
  var recommendedMe: MusicDisplayData?
  var sentRecommendation: Bool = false
    
  init(name: String,
       profilePic: String,
       listeningTo: MusicDisplayData,
       recommendedMe: MusicDisplayData? = nil,
       sentRecommendation: Bool = false) {
    self.name = name
    self.profilePic = profilePic
    self.listeningTo = listeningTo
    self.recommendedMe = recommendedMe
    self.sentRecommendation = sentRecommendation
    self.id = name
  }
    
  var buttonToShow: ButtonType {
    if recommendedMe != nil {
      return .listen
    } else if sentRecommendation {
      return .shared
    } else {
      return .share
    }
  }
}
