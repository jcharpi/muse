import Foundation

// MARK: - ButtonType
enum ButtonType {
  case listen, connect, disconnect, share, shared

  /// Status text shown beneath a listener's name in the list.
  var statusText: String {
    self == .listen ? "Recommended a song" : "Listening nearby"
  }
}

// MARK: - ButtonDisplayStyle
/// Controls whether a button renders as a labelled pill or a compact icon.
enum ButtonDisplayStyle {
  case icon, text
}
