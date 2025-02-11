//
//  ListenerView.swift
//  Muse
//
//  Created by Josh Charpentier on 1/4/25.
//

import SwiftUI

struct ListenerView: View {
  @Bindable var viewModel = MuseViewModel()
  
  let listener: MuseViewModel.Listener
  let showIconButton: Bool
  let color: Color
  
  init(
    _ listener: MuseViewModel.Listener,
    showIconButton: Bool = true,
    color: Color = .white
  ) {
    self.listener = listener
    self.showIconButton = showIconButton
    self.color = color
  }
  
  var body: some View {
    HStack {
      ProfileIconView(
        Image("joshc28"),
        size: Constants.profileIconSize,
        color: color
      )
      .padding(.trailing, Constants.trailingProfilePadding)
        
      VStack(alignment: .leading, spacing: Constants.vStackSpacing) {
        Text(listener.name)
          .font(.title2)
          
        Text(viewModel.textToDisplay(listener.buttonToShow))
          .font(.subheadline)
      }
      .fontWeight(.semibold)
      .foregroundStyle(color)
        
      Spacer()
    }
  }
  
  private struct Constants {
    static let vStackSpacing: CGFloat = 8.0
    static let profileIconSize: CGFloat = 72.0
    static let trailingProfilePadding: CGFloat = 4.0
  }
}

#Preview {
  ZStack {
    Color.black
      .opacity(0.8)
      .ignoresSafeArea()
    
    VStack(spacing: 16) {
      ListenerView(
        MuseViewModel.Listener(
          name: "Josh",
          listeningTo: .init(
            albumCover: "weathertop",
            songTitle: "Frog",
            artistName: "Jibby Jab"
          )
        )
      )
      ListenerView(
        MuseViewModel.Listener(
          name: "Josh",
          listeningTo: .init(
            albumCover: "weathertop",
            songTitle: "Frog",
            artistName: "Jibby Jab"
          ),
          recommendedMe: true
        )
      )
      ListenerView(
        MuseViewModel.Listener(
          name: "Josh",
          listeningTo: .init(
            albumCover: "weathertop",
            songTitle: "Frog",
            artistName: "Jibby Jab"
          ),
          sentRecommendation: true
        )
      )
    }
    .padding()
  }
}
