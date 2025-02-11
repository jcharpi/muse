  //
  //  MuseApp.swift
  //  Muse
  //
  //  Created by Josh Charpentier on 12/31/24.
  //

  import SwiftUI

  @main
  struct MuseApp: App {
    @State var app = MuseViewModel()
    
    var body: some Scene {
      WindowGroup {
        ZStack {
          Color.black
            .opacity(Constants.backgroundOpacity)
            .edgesIgnoringSafeArea(.all)
          
          MuseNearbyView()
        }
      }
    }
    
    private struct Constants {
      static let backgroundOpacity: Double = 0.8
    }
  }
