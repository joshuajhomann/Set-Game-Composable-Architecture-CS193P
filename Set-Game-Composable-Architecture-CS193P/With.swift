//
//  With.swift
//  Set-Game-Composable-Architecture-CS193P
//
//  Created by Joshua Homann on 6/9/20.
//  Copyright © 2020 com.josh. All rights reserved.
//

import Foundation

@discardableResult public func with<T>(_ item: T, update: (inout T) throws -> Void) rethrows -> T {
    var copy = item
    try update(&copy)
    return copy
}
