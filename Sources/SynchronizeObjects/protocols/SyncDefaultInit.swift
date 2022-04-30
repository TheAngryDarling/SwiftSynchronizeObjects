//
//  File.swift
//  
//
//  Created by Tyler Anger on 2022-04-29.
//

import Foundation

/// Protocol defining an object type that can be created with an
/// initializer with no parameters
public protocol SyncDefaultInit {
    init()
}

extension Dictionary: SyncDefaultInit {}
extension Array: SyncDefaultInit { }

extension Optional: SyncDefaultInit {
    public init() { self = .none }
}
