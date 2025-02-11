//
//  MuseProfileIconView.swift
//  Muse
//
//  Created by Josh Charpentier on 1/1/25.
//

import SwiftUI

struct ProfileIconView: View {
  private let profileImage: Image
  private let lineWidth: CGFloat = 8.0
  private let size: CGFloat
  let color: Color
  
  init(_ pfp: Image, size: CGFloat, color: Color = .white) {
    self.profileImage = pfp
    self.size = size
    self.color = color
  }
  
  var body: some View {
    profileImage
      .resizable()
      .scaledToFit()
      .clipShape(Circle())
      .background(Circle()
        .stroke(lineWidth: lineWidth)
        .foregroundStyle(color))
      .frame(width: size, height: size)
  }
}

#Preview {
  ZStack {
    // Background
    Color.black
      .edgesIgnoringSafeArea(.all)
    
    // Foreground
    ProfileIconView(Image("joshc28"), size: 100)
      .padding()
  }
}
