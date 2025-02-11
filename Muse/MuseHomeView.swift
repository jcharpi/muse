//
//  ContentView.swift
//  Muse
//
//  Created by Josh Charpentier on 12/31/24.
//

import SwiftUI

struct MuseHomeView: View {
  let accentColor: Color = .white
  
  var body: some View {
    VStack {
      HeaderView()
      Spacer()
      MusicDisplayView(color: accentColor)
      Spacer()
    }
    
  }
}



#Preview {
  ZStack {
    Color.black
      .opacity(0.8)
      .edgesIgnoringSafeArea(.all)
    
    MuseHomeView()
  }
}
