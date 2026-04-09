import Foundation

// MARK: - ButtonType
enum ButtonType {
  case react, reacted

  var statusText: String { "Listening nearby" }
}

// MARK: - ButtonDisplayStyle
/// Controls whether a button renders as a labelled pill or a compact icon.
enum ButtonDisplayStyle {
  case icon, text
}
