import Foundation

struct MusicDisplayData {
  let albumCover: String
  let songTitle: String
  let artistName: String
}

protocol MusicDisplayable {
  var listeningTo: MusicDisplayData { get }
}
