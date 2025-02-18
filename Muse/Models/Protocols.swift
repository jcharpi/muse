import Foundation

protocol MusicDisplayable {
  var listeningTo: MusicDisplayData { get set }
}

// TODO: make id more unique
protocol IdentifiableEntity: Identifiable {
  var id: String { get set }
  var name: String { get set }
}
