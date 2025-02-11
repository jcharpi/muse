//
//  MuseModel.swift
//  Muse
//
//  Created by Josh Charpentier on 12/31/24.
//

import Foundation

struct MuseModel {
  private(set) var listeners: [Listener]
  
  // MARK: - Access Funcs
  mutating func buttonTap(_ listener: Listener, _ type: ButtonType) {
    if let chosenListenerIndex = listeners.firstIndex(
      where: { $0.id == listener.id
      }) {
      switch type {
      case .share:
        listeners[chosenListenerIndex].sentRecommendation = true
      case .listen:
        print("Open Spotify")
      default:
        print("Unhandled button type")
      }
    } else {
      print("Listener not found")
    }
  }
  
  func nowPlaying() -> MusicDisplayData {
    return MusicDisplayData(
      albumCover: "Weatherman",
      songTitle: "Amsterdam",
      artistName: "Gregory Alan Isakov"
    )
  }
  
  func textToDisplay(_ buttonType: ButtonType) -> String {
    switch buttonType {
    case .listen: "Recommended you a song"
    default: "Listening nearby"
    }
  }
  
  struct ButtonData {
    var type: ButtonType
    var title: String?
    var icon: String?
  }
  
  struct MusicDisplayData {
    // TODO: - Figure out how to convert fetch to Image in ViewModel
    var albumCover: String
    var songTitle: String
    var artistName: String
  }
  
  struct Listener: Identifiable {
    var name: String
    var listeningTo: MusicDisplayData
    var recommendedSong: MusicDisplayData?
    
    var recommendedMe: Bool = false
    var sentRecommendation: Bool = false
    
    var id: String { name }
    
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
  
  enum ButtonStyle {
    case icon, text
  }
  
  enum ButtonType {
    case listen, login, logout, share, shared
  }
  
}
