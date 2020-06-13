//
//  CardView.swift
//  Set-Game-Composable-Architecture-CS193P
//
//  Created by Joshua Homann on 6/7/20.
//  Copyright © 2020 com.josh. All rights reserved.
//

import SwiftUI

struct CardView: View {
  var card: Card
  var isSet: Bool
  var isSelected: Bool
  var body: some View {
    GeometryReader { geometry in
      ZStack {
        Color(self.isSet && self.isSelected ? #colorLiteral(red: 0.9717183709, green: 0.9393340349, blue: 0.7800399661, alpha: 1) : #colorLiteral(red: 0.9916529059, green: 0.9701647162, blue: 0.913726449, alpha: 1) )
          .cornerRadius(geometry.size.width * 0.125)
          .shadow(
            color: Color(self.isSelected ? #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1) : .clear),
            radius: geometry.size.width * 0.03, x: 0, y: 0
          )
        VStack(alignment: .center, spacing: geometry.size.width * 0.1) {
          ForEach(0..<self.card.symbolCount) { _ in
            self.makeCardImage(cardSize: geometry.size)
          }
        }
        .padding(geometry.size.width * 0.1)
      }
    }
    .aspectRatio(2.0/3.0, contentMode: .fit)
  }

  private func makeCardImage(cardSize: CGSize) -> some View {
    let name: String
    switch card.fill {
    case .outline: name = card.shape.rawValue
    case .hatched: name = "\(card.shape.rawValue).hatch"
    case .solid: name = "\(card.shape.rawValue).fill"
    }
    let color: UIColor
    switch card.color {
    case .blue: color = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
    case .green: color = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
    case .red: color = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
    }
    return Image(name)
      .resizable()
      .foregroundColor(Color(color))
      .aspectRatio(3/1, contentMode: .fit)
  }
}


struct CardView_Previews: PreviewProvider {
  static var previews: some View {
    CardView(card: .init(color: .blue, shape: .wave, fill: .hatched, symbolCount: 2), isSet: false, isSelected: false)
  }
}

