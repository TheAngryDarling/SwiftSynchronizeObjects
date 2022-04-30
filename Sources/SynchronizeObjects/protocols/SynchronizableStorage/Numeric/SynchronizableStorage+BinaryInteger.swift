//
//  SynchronizableStorage+BinaryInteger.swift
//  
//
//  Created by Tyler Anger on 2022-04-24.
//

import Foundation

public extension SynchronizableStorage where Storage: BinaryInteger {
    
}
public extension SynchronizableStorage where Storage: BinaryInteger {
    static func /(lhs: Self,
                   rhs: Self) -> Storage {
        return lhs.lockingForWithValue { ptr in
            return ptr.pointee / rhs.value
        }
    }
    static func /=(lhs: inout Self,
                   rhs: Self) {
        lhs.lockingForWithValue { ptr in
            ptr.pointee /= rhs.value
        }
    }
    static func /(lhs: Self,
                   rhs: Storage) -> Storage {
        return lhs.lockingForWithValue { ptr in
            return ptr.pointee / rhs
        }
    }
    static func /=(lhs: inout Self,
                   rhs: Storage) {
        lhs.lockingForWithValue { ptr in
            ptr.pointee /= rhs
        }
    }
}

public extension SynchronizableStorage where Storage: BinaryInteger {
    static func %(lhs: Self,
                   rhs: Self) -> Storage {
        return lhs.lockingForWithValue { ptr in
            return ptr.pointee % rhs.value
        }
    }
    static func %=(lhs: inout Self,
                   rhs: Self) {
        lhs.lockingForWithValue { ptr in
            ptr.pointee %= rhs.value
        }
    }
    static func %(lhs: Self,
                   rhs: Storage) -> Storage {
        return lhs.lockingForWithValue { ptr in
            return ptr.pointee % rhs
        }
    }
    static func %=(lhs: inout Self,
                   rhs: Storage) {
        lhs.lockingForWithValue { ptr in
            ptr.pointee %= rhs
        }
    }
}

public extension SynchronizableStorage where Storage: BinaryInteger {
    static func &(lhs: Self,
                   rhs: Self) -> Storage {
        return lhs.lockingForWithValue { ptr in
            return ptr.pointee & rhs.value
        }
    }
    static func &=(lhs: inout Self,
                   rhs: Self) {
        lhs.lockingForWithValue { ptr in
            ptr.pointee &= rhs.value
        }
    }
    static func &(lhs: Self,
                   rhs: Storage) -> Storage {
        return lhs.lockingForWithValue { ptr in
            return ptr.pointee & rhs
        }
    }
    static func &=(lhs: inout Self,
                   rhs: Storage) {
        lhs.lockingForWithValue { ptr in
            ptr.pointee &= rhs
        }
    }
}

public extension SynchronizableStorage where Storage: BinaryInteger {
    static func |(lhs: Self,
                   rhs: Self) -> Storage {
        return lhs.lockingForWithValue { ptr in
            return ptr.pointee | rhs.value
        }
    }
    static func |=(lhs: inout Self,
                   rhs: Self) {
        lhs.lockingForWithValue { ptr in
            ptr.pointee |= rhs.value
        }
    }
    static func |(lhs: Self,
                   rhs: Storage) -> Storage {
        return lhs.lockingForWithValue { ptr in
            return ptr.pointee | rhs
        }
    }
    static func |=(lhs: inout Self,
                   rhs: Storage) {
        lhs.lockingForWithValue { ptr in
            ptr.pointee |= rhs
        }
    }
}

public extension SynchronizableStorage where Storage: BinaryInteger {
    static func ^(lhs: Self,
                   rhs: Self) -> Storage {
        return lhs.lockingForWithValue { ptr in
            return ptr.pointee ^ rhs.value
        }
    }
    static func ^=(lhs: inout Self,
                   rhs: Self) {
        lhs.lockingForWithValue { ptr in
            ptr.pointee ^= rhs.value
        }
    }
    static func ^(lhs: Self,
                   rhs: Storage) -> Storage {
        return lhs.lockingForWithValue { ptr in
            return ptr.pointee ^ rhs
        }
    }
    static func ^=(lhs: inout Self,
                   rhs: Storage) {
        lhs.lockingForWithValue { ptr in
            ptr.pointee ^= rhs
        }
    }
}


public extension SynchronizableStorage where Storage: BinaryInteger {
    static func == <RHS>(lhs: Self,
                        rhs: RHS) -> Bool where RHS: BinaryInteger {
        return lhs.value == rhs
    }
    static func != <RHS>(lhs: Self,
                        rhs: RHS) -> Bool where RHS: BinaryInteger {
        return lhs.value != rhs
    }
    
    static func > <RHS>(lhs: Self,
                        rhs: RHS) -> Bool where RHS: BinaryInteger {
        return lhs.value > rhs
    }
    static func >= <RHS>(lhs: Self,
                        rhs: RHS) -> Bool where RHS: BinaryInteger {
        return lhs.value >= rhs
    }
    static func < <RHS>(lhs: Self,
                        rhs: RHS) -> Bool where RHS: BinaryInteger {
        return lhs.value < rhs
    }
    
    
    static func <= <RHS>(lhs: Self,
                        rhs: RHS) -> Bool where RHS: BinaryInteger {
        return lhs.value <= rhs
    }
}
