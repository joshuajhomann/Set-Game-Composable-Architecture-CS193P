//
//  PreferenceKeys.swift
//  Set-Game-Composable-Architecture-CS193P
//
//  Created by Joshua Homann on 6/7/20.
//  Copyright © 2020 com.josh. All rights reserved.
//

import SwiftUI

protocol SingleValuePreferenceKey: PreferenceKey { }

extension SingleValuePreferenceKey {
  static func reduce(value: inout Value, nextValue: () -> Value) {
    value = nextValue()
  }
}

protocol DictionaryPreferenceKey: PreferenceKey where Value == [Key : DictionaryValue] {
  associatedtype Key: Hashable
  associatedtype DictionaryValue
}

extension DictionaryPreferenceKey {
  static var defaultValue: Value { [:] }
  static func reduce(value: inout Value, nextValue: () -> Value) {
    nextValue().forEach { value[$0] = $1 }
  }
}

struct CardPlaceholderPreferenceKey: DictionaryPreferenceKey {
  typealias Key = Int
  typealias DictionaryValue = CGRect
}

struct BoardSizePreferenceKey: SingleValuePreferenceKey {
  static var defaultValue: CGSize = .zero
}

struct DrawPileFramePreferenceKey: SingleValuePreferenceKey {
  static var defaultValue: CGRect = .zero
}
struct MatchPileFramePreferenceKey: SingleValuePreferenceKey {
  static var defaultValue: CGRect = .zero
}
