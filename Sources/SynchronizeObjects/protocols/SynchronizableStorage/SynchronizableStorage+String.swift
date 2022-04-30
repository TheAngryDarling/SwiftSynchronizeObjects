//
//  SynchronizableStorage+String.swift
//  
//
//  Created by Tyler Anger on 2022-04-24.
//

import Foundation

public extension SynchronizableStorage where Storage == String {
    
    static func +=(lhs: inout Self,
                   rhs: Self) {
        lhs.lockingForWithValue { ptr in
            ptr.pointee += rhs.value
        }
    }
    static func +=(lhs: inout Self,
                   rhs: Storage) {
        lhs.lockingForWithValue { ptr in
            ptr.pointee += rhs
        }
    }
}
