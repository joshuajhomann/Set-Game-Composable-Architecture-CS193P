//
//  ContentView.swift
//  Set-Game-Composable-Architecture-CS193P
//
//  Created by Joshua Homann on 6/7/20.
//  Copyright © 2020 com.josh. All rights reserved.
//

import SwiftUI
import ComposableArchitecture


struct GameView: View {
  let store: Store<GameState, GameAction>
  @State private var cardFrames: [Int: CGRect] = [:]
  @State private var cardSize: CGSize = .zero
  @State private var boardSize: CGSize = .zero
  @State private var drawPileFrame: CGRect = .zero
  @State private var matchPileFrame: CGRect = .zero

  enum Space: Hashable {
    case board
  }
  var body: some View {
    WithViewStore(store) { viewStore in
      ZStack(alignment: .topLeading) {
        VStack {
          BoardView()
            .onPreferenceChange(BoardSizePreferenceKey.self) { self.boardSize = $0 }
            .onPreferenceChange(CardPlaceholderPreferenceKey.self) { cardFrames in
              self.cardFrames = cardFrames
              self.cardSize = cardFrames[0]?.size ?? .zero
            }
          HStack {
            GeometryReader { geometry in
              PlaceholderView()
                .preference(key: DrawPileFramePreferenceKey.self, value: geometry.frame(in: CoordinateSpace.named(GameView.Space.board)))
            }
            .frame(width: self.cardSize.width, height: self.cardSize.height)
            Spacer()
            VStack(spacing: 24) {
              Button(action: {
                for space in 0..<viewStore.spacesAvailable {
                  withAnimation(Animation.easeInOut(duration: 0.4).delay(0.1*Double(space))) { viewStore.send(.deal) } }
                }
              ) { Text("Deal") }
              Button(action: {
                withAnimation { viewStore.send(.reset) } }
              ) { Text("Reset") }
            }.font(.largeTitle)
            Spacer()
            GeometryReader { geometry in
              PlaceholderView()
                .preference(key: MatchPileFramePreferenceKey.self, value: geometry.frame(in: CoordinateSpace.named(GameView.Space.board)))
            }
            .frame(width: self.cardSize.width, height: self.cardSize.height)
          }
            .frame(height: self.boardSize.height * 0.4)
            .onPreferenceChange(DrawPileFramePreferenceKey.self) { self.drawPileFrame = $0 }
            .onPreferenceChange(MatchPileFramePreferenceKey.self) { self.matchPileFrame = $0 }
          HStack {
            Text("Deck: \(viewStore.drawPile.count)")
            Spacer()
            Text(viewStore.selectionStatus)
            Spacer()
            Text("Matches: \(viewStore.matched.count)")
          }
        }
        ForEach(viewStore.allCards) { card in
          Button(action: { withAnimation { viewStore.send(.select(card: card) )} }) {
            CardView(card: card, isSet: viewStore.isSet && viewStore.selectedCards.count == 3, isSelected: viewStore.selectedCards.contains(card))
          }
            .offset(self.offset(for: card))
            .frame(width: self.cardSize.width, height: self.cardSize.height)
        }
      }
        .coordinateSpace(name: GameView.Space.board)
        .padding()
        .onAppear { viewStore.send(.reset) }
    }
  }
  private func offset(for card: Card) -> CGSize {
    switch card.location {
    case .deck:
      return .init(width: drawPileFrame.minX, height: drawPileFrame.minY)
    case let .board(index):
      let point = cardFrames[index]?.origin ?? .zero
      return .init(width: point.x, height: point.y)
    case .matched:
      return .init(width: matchPileFrame.minX, height: matchPileFrame.minY)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    GameView(store: .init(
      initialState: .init(),
      reducer: gameReducer,
      environment: .init()
    ))
  }
}
