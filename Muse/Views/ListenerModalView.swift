//
//  ListenerModalView.swift
//  Muse
//
//  Created by Josh Charpentier on 1/4/25.
//

import SwiftUI

struct ListenerModalView: View {
  @Bindable var viewModel = MuseViewModel()
  
  let listener: MuseViewModel.Listener
  
  init(_ listener: MuseViewModel.Listener) {
    self.listener = listener
  }
  
  var body: some View {
    VStack {
      Group {
        ListenerView(listener, showIconButton: false, color: .primary)
          .padding(.top, Constants.topPadding)
          .padding(.horizontal)
        
        MusicDisplayView(color: .primary)
      }
      .scaleEffect(Constants.scaleEffect)
      
      Spacer()
      
      if (listener.buttonToShow != .shared) {
        ButtonView(listener, style: .text)
      }
    }
    .padding()
  }
  
  private struct Constants {
    static let topPadding: CGFloat = 40.0
    static let scaleEffect: CGFloat = 0.9
  }
}

#Preview {
  ListenerModalView(
    MuseViewModel.Listener.init(
      name: "test",
      listeningTo: .init(
        albumCover: "weathertop",
        songTitle: "frog",
        artistName: "test"
      )
    )
  )
}
