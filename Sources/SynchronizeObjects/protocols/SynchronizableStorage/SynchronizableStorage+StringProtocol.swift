//
//  SynchronizableStorage+StringProtocol.swift
//  
//
//  Created by Tyler Anger on 2022-04-24.
//

import Foundation

public extension SynchronizableStorage where Storage: StringProtocol {
    
    static func == <RHS>(lhs: Self, rhs: RHS) -> Bool where RHS : StringProtocol {
        return lhs.lockingForWithValue { ptr in
            return ptr.pointee == rhs
        }
    }
    
    static func != <RHS>(lhs: Self, rhs: RHS) -> Bool where RHS : StringProtocol {
        return lhs.lockingForWithValue { ptr in
            return ptr.pointee != rhs
        }
    }
}
