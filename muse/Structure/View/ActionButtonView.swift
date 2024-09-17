//
//  ContentView.swift
//  muse
//
//  Created by Josh Charpentier on 9/16/24.
//

import SwiftUI

enum ButtonStyleType {
  case share
  case listen
  case stop
}

struct ActionButtonView: View {
  var size: Double
  var style: ButtonStyleType
  
  var body: some View {
    Button(action: {}) {
      Image(systemName: iconName(for: style))
        .resizable()
        .aspectRatio(contentMode: .fit)
        .padding(
          size * stylePadding(for: style))
        .foregroundStyle(
          foregroundColor(for: style)
        )
        .clipShape(.circle)
        .frame(width: size, height: size)
        .overlay(
          Circle()
            .stroke(foregroundColor(for: style), lineWidth: size * 0.03)
        )
    }
  }
  
  private func stylePadding(for style: ButtonStyleType) -> Double {
    switch style {
    case .share:
      return 0.2
    case .listen:
      return 0.25
    case .stop:
      return 0.3
    }
  }
  
  private func iconName(for style: ButtonStyleType) -> String {
    switch style {
    case .share:
      return "bolt"
    case .listen:
      return "music.note.list"
    case .stop:
      return "stop"
    }
  }
  
  private func foregroundColor(for style: ButtonStyleType) -> Color {
    switch style {
    case .share:
      return .magenta
    case .listen:
      return .green
    case .stop:
      return .offWhite
    }
  }
}

#Preview {
  ActionButtonView(size: 100, style: .listen)
}
