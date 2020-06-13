//
//  BoardView.swift
//  Set-Game-Composable-Architecture-CS193P
//
//  Created by Joshua Homann on 6/7/20.
//  Copyright © 2020 com.josh. All rights reserved.
//

import SwiftUI

struct PlaceholderView: View {
  var body: some View {
    GeometryReader { geometry in
      Color(#colorLiteral(red: 0.9058823529, green: 0.9058823529, blue: 0.9058823529, alpha: 1))
        .cornerRadius(geometry.size.height * 0.125)
        .aspectRatio(2/3, contentMode: .fit)
    }
  }
}

struct BoardView: View {
  var body: some View {
    GeometryReader { boardGeometry in
      VStack {
        ForEach (0..<GameState.Constant.rows) { y in
          HStack {
            ForEach (0..<GameState.Constant.columns) { x in
              GeometryReader { geometry in
                PlaceholderView()
                  .preference(
                    key: CardPlaceholderPreferenceKey.self,
                    value: [x+y*GameState.Constant.columns: geometry.frame(in: CoordinateSpace.named(GameView.Space.board))]
                  )
              }
            }
          }
        }
      }
      .preference(key: BoardSizePreferenceKey.self, value: boardGeometry.size)
    }
  }
}

struct BoardView_Previews: PreviewProvider {
  static var previews: some View {
    BoardView()
  }
}
