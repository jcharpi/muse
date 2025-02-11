//
//  MusicDisplayView.swift
//  Muse
//
//  Created by Josh Charpentier on 1/1/25.
//

import SwiftUI

struct MusicDisplayView: View {
  @Bindable var viewModel = MuseViewModel()
  
  private let screenWidth = UIScreen.main.bounds.width
  
  let color: Color
  
  var body: some View {
    let albumCover = viewModel.nowPlaying().albumCover
    
    VStack(alignment: .leading) {
      Image(albumCover)
        .resizable()
        .padding(.horizontal, Constants.horizontalPadding)
        .frame(width: screenWidth, height: screenWidth)
      
      songDetails
    }
  }
  
  @ViewBuilder
  var songDetails: some View {
    let songTitle = viewModel.nowPlaying().songTitle
    let artistName = viewModel.nowPlaying().artistName
    
    Group {
      Text(songTitle)
        .font(.title)
        .fontWeight(.medium)
        .padding(.top, Constants.songTitleTopPadding)
        .padding(.bottom, Constants.songTitleBottomPadding)
      Text(artistName)
        .font(.title3)
        .fontWeight(.regular)
        .opacity(Constants.opacity)
    }
    .foregroundStyle(color)
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal, Constants.horizontalPadding)
  }
  
  private struct Constants {
    static let horizontalPadding: CGFloat = 16
    static let songTitleTopPadding: CGFloat = 16
    static let songTitleBottomPadding: CGFloat = 4
    static let opacity: CGFloat = 0.8
  }
}

#Preview {
  ZStack {
    Color.black.opacity(0.8).edgesIgnoringSafeArea(.all)
    MusicDisplayView(color: .white)
  }
}
