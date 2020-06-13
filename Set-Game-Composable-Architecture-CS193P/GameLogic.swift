//
//  GameLogic.swift
//  Set-Game-Composable-Architecture-CS193P
//
//  Created by Joshua Homann on 6/7/20.
//  Copyright © 2020 com.josh. All rights reserved.
//

import ComposableArchitecture
import Combine
import SwiftUI

struct GameState: Equatable {
  enum Constant {
    static let rows = 4
    static let columns = 5
    static let boardCount = 20
  }
  var drawPile: [Card] = []
  var cards: [Card] = []
  var matched: [Card] = []
  var allCards: [Card] { drawPile + cards + matched }
  var spacesAvailable: Int { GameState.Constant.boardCount - cards.count }
  var selectedCards: Set<Card> = []
  var isSet = false
  var selectionStatus = " "
}

enum GameAction: Equatable {
  case reset, deal, select(card: Card)
}

struct GameEnvironment {}

let gameReducer = Reducer<GameState, GameAction, GameEnvironment> { state, action, environment in
  switch action {
  case .reset:
    state.drawPile = Card.all.shuffled()
    state.cards = []
    state.matched = []
    state.selectedCards = []
    state.isSet = false
    state.selectionStatus = " "
    return .none

  case .deal:
    let occupiedLocations = Set(state.cards.compactMap { card -> Int? in
      guard case let .board(index) = card.location else { return nil}
      return index
    })
    guard let freeSpace = Array((0..<GameState.Constant.rows * GameState.Constant.columns))
      .first(where: { !occupiedLocations.contains($0) }) else {
        return .none
    }
    state.cards = state.cards + state.drawPile
      .suffix(1)
      .map { card in
        with(card) {
          $0.location = .board(index: freeSpace)
        }
      }
    state.drawPile.removeLast()
    return .none

  case let .select(card):
    let initialSelectionCount = state.selectedCards.count
    if initialSelectionCount < 3 {
      if state.selectedCards.contains(card) {
        state.selectedCards.remove(card)
      } else {
        state.selectedCards.insert(card)
      }
    }

    let attributeCounts = [
      Set(state.selectedCards.map(\.color)).count,
      Set(state.selectedCards.map(\.shape)).count,
      Set(state.selectedCards.map(\.fill)).count,
      Set(state.selectedCards.map(\.symbolCount)).count,
    ]
    state.selectionStatus = "Color: \(attributeCounts[0]) Shape: \(attributeCounts[1]) Fill: \(attributeCounts[2]) Count: \(attributeCounts[3])"
    state.isSet = attributeCounts.allSatisfy { $0 != 2 }

    if initialSelectionCount == 3 {
      defer { state.selectedCards.removeAll() }
      if state.isSet {
        state.matched = state.matched + state.selectedCards.map{ with($0) { $0.location = .matched }}
        state.cards = state.cards.filter { !state.selectedCards.contains($0) }
      }
      return state.cards.contains(card)
        ? Just(GameAction.select(card: card)).eraseToEffect()
        : .none
    }
    return .none
  }
}

