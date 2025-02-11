//
//  ButtonView.swift
//  Muse
//
//  Created by Josh Charpentier on 12/31/24.
//

import SwiftUI

struct ButtonView: View {
  @Bindable var viewModel = MuseViewModel()
  
  private let listener: MuseViewModel.Listener
  private let style: MuseViewModel.ButtonStyle
  
  init(
    _ listener: MuseViewModel.Listener,
    style: MuseViewModel.ButtonStyle
  ) {
    self.listener = listener
    self.style = style
  }
  
  var body: some View {
    let type = listener.buttonToShow
    let data = viewModel.buttonData(for: type, style: style)
    let colors = viewModel.buttonColors(for: type)
    
    if let title = data.title {
      textButton(title, colors)
    } else if let icon = data.icon {
      iconButton(icon, colors).onTapGesture {
        viewModel.buttonTap(listener)
      }
    }
  }
  
  private func textButton(_ title: String, _ colors: MuseViewModel.ButtonColor) -> some View {
    Text(title)
      .font(Constants.titleFontSize)
      .fontWeight(.medium)
      .foregroundStyle(colors.secondaryColor ?? .black)
      .padding(.vertical, Constants.verticalPadding)
      .padding(.horizontal, Constants.horizontalPadding)
      .background(colors.primaryColor)
      .cornerRadius(Constants.cornerRadius)
  }
  
  private func iconButton(_ icon: String, _ colors: MuseViewModel.ButtonColor) -> some View {
    Image(systemName: icon)
      .font(Constants.iconFontSize)
      .fontWeight(.semibold)
      .foregroundStyle(colors.primaryColor)
      .padding()
      .background(Circle()
        .stroke(lineWidth: Constants.iconCircleStrokeWidth)
        .foregroundStyle(colors.primaryColor))
  }
  
  private struct Constants {
    static let verticalPadding: CGFloat = 8
    static let horizontalPadding: CGFloat = 24
    static let cornerRadius: CGFloat = 20
    static let iconFontSize: Font = .title
    static let titleFontSize: Font = .title2
    static let iconCircleStrokeWidth: CGFloat = 4
  }
}

#Preview {
  HStack {
    @Bindable var viewModel = MuseViewModel()
    
    VStack {
      ButtonView(viewModel.listeners[0], style: .text)
      ButtonView(viewModel.listeners[1], style: .text)
      ButtonView(viewModel.listeners[2], style: .text)
      
    }
    .padding()
    VStack {
      ButtonView(viewModel.listeners[0], style: .icon)
      ButtonView(viewModel.listeners[1], style: .icon)
      ButtonView(viewModel.listeners[2], style: .icon)
    }
    .padding()
  }
}
