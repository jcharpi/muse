import Foundation

enum ButtonType {
  case listen, login, logout, share, shared
}

enum ButtonStyle {
  case icon, text
}

struct ButtonData {
  let type: ButtonType
  let title: String?
  let icon: String?
}
