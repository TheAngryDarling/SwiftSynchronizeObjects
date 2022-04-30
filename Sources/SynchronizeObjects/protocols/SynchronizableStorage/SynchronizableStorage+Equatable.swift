//
//  SynchronizableStorage+Equatable.swift
//  
//
//  Created by Tyler Anger on 2022-04-24.
//

import Foundation

public extension SynchronizableStorage where Storage: Equatable {
    static func ==(lhs: Self,
                   rhs: Self) -> Bool {
        return lhs.value == rhs.value
    }
    static func ==(lhs: Self,
                   rhs: Storage) -> Bool {
        return lhs.value == rhs
    }
    static func !=(lhs: Self,
                   rhs: Self) -> Bool {
        return lhs.value != rhs.value
    }
    static func !=(lhs: Self,
                   rhs: Storage) -> Bool {
        return lhs.value != rhs
    }
}
