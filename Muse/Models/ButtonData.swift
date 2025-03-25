import Foundation

// MARK: - ButtonType
/// Defines the types of buttons available in the UI.
/// - Cases:
///   - `listen`: Triggers playback of a recommended track.
///   - `connect`: Initiates Spotify authentication.
///   - `disconnect`: Ends the user session.
///   - `share`: Shares the current track with a listener.
///   - `shared`: Indicates a recommendation has already been sent.
enum ButtonType {
  case listen, connect, disconnect, share, shared
}

// MARK: - ButtonStyle
/// Determines the visual presentation of a button.
/// - Cases:
///   - `icon`: Displays only an icon (e.g., SF Symbol).
///   - `text`: Displays text label.
enum ButtonStyle {
  case icon, text
}

// MARK: - ButtonData
/// Encapsulates configuration data for rendering a button.
/// - Properties:
///   - `type`: The functional type of the button.
///   - `title`: Optional text label (used for `.text` style).
///   - `icon`: Optional SF Symbol name (used for `.icon` style).
struct ButtonData {
  let type: ButtonType
  let title: String?
  let icon: String?
}
