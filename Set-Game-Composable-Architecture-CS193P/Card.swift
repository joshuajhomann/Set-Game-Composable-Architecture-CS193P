//
//  Card.swift
//  Set-Game-Composable-Architecture-CS193P
//
//  Created by Joshua Homann on 6/7/20.
//  Copyright © 2020 com.josh. All rights reserved.
//

import Foundation

struct Card: Identifiable, Hashable {
  enum Color: String, CaseIterable, Hashable {
    case red, green, blue
  }
  enum Shape: String, CaseIterable, Hashable {
    case diamond, capsule, wave
  }
  enum Fill: String, CaseIterable, Hashable {
    case outline, hatched, solid
  }
  enum Location: Hashable {
    case deck, board(index: Int), matched
  }
  var location: Location
  let color: Color
  let shape: Shape
  let fill: Fill
  let symbolCount: Int
  let id: String
  init(color: Color, shape: Shape, fill: Fill, symbolCount: Int) {
    id = [String(describing: symbolCount), color.rawValue, shape.rawValue, fill.rawValue].joined(separator: "-")
    self.color = color
    self.shape = shape
    self.fill = fill
    self.symbolCount = symbolCount
    location = .deck
  }
  static let all: [Card] = {
    Color.allCases.flatMap { color in
      Shape.allCases.flatMap { shape in
        Fill.allCases.flatMap { fill in
          (1...3).map { count in
            Self(color: color, shape: shape, fill: fill, symbolCount: count)
          }
        }
      }
    }
  }()
}
