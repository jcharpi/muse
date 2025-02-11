//
//  MuseNearbyView.swift
//  Muse
//
//  Created by Josh Charpentier on 1/1/25.
//

import SwiftUI

struct MuseNearbyView: View {
  @Bindable var viewModel = MuseViewModel()
  @State private var isModalPresented = false

  var body: some View {
    VStack {
      HeaderView()
      Spacer()
      ScrollView {
        LazyVStack(alignment: .center, spacing: Constants.lazyVStackspacing) {
          ForEach(viewModel.listeners) { listener in
            listenerElement(listener)
          }
        }
        .padding()
      }
    }
  }
  
  func listenerElement(_ listener: MuseViewModel.Listener) -> some View {
    HStack {
      ListenerView(listener)
        .contentShape(Rectangle())
        .onTapGesture { isModalPresented = true }
        .sheet(isPresented: $isModalPresented) {
          ListenerModalView(listener)
            .presentationDetents(
              [.fraction(Constants.modalPresentationFraction)]
            )
            .presentationDragIndicator(.visible)
        }
      ButtonView(listener, style: .icon)
    }
  }
  
  private struct Constants {
    static let lazyVStackspacing: CGFloat = 24.0
    static let modalPresentationFraction: CGFloat = 0.9
  }
}

#Preview {
  ZStack {
    // Background
    Color.black
      .edgesIgnoringSafeArea(.all)
      .opacity(0.8)
    
    // Foreground
    MuseNearbyView(viewModel: MuseViewModel())
  }
}
