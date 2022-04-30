//
//  SynchronizableStorage+Numeric.swift
//  
//
//  Created by Tyler Anger on 2022-04-24.
//

import Foundation

#if swift(>=5.0)
public extension SynchronizableStorage where Storage: Numeric {
    static func *(lhs: Self,
                   rhs: Self) -> Storage {
        return lhs.lockingForWithValue { ptr in
            return ptr.pointee * rhs.value
        }
    }
    static func *=(lhs: inout Self,
                   rhs: Self) {
        lhs.lockingForWithValue { ptr in
            ptr.pointee *= rhs.value
        }
    }
    static func *(lhs: Self,
                   rhs: Storage) -> Storage {
        return lhs.lockingForWithValue { ptr in
            return ptr.pointee * rhs
        }
    }
    static func *=(lhs: inout Self,
                   rhs: Storage) {
        lhs.lockingForWithValue { ptr in
            ptr.pointee *= rhs
        }
    }
}
#else
public extension SynchronizableStorage where Storage: BinaryInteger {
    static func *(lhs: Self,
                   rhs: Self) -> Storage {
        return lhs.lockingForWithValue { ptr in
            return ptr.pointee * rhs.value
        }
    }
    static func *=(lhs: inout Self,
                   rhs: Self) {
        lhs.lockingForWithValue { ptr in
            ptr.pointee *= rhs.value
        }
    }
    static func *(lhs: Self,
                   rhs: Storage) -> Storage {
        return lhs.lockingForWithValue { ptr in
            return ptr.pointee * rhs
        }
    }
    static func *=(lhs: inout Self,
                   rhs: Storage) {
        lhs.lockingForWithValue { ptr in
            ptr.pointee *= rhs
        }
    }
}
#endif

