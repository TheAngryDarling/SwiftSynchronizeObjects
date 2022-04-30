//
//  SynchronizableStorage+Collection.swift
//  
//
//  Created by Tyler Anger on 2022-04-24.
//

import Foundation

public extension SynchronizableStorage where Storage: Collection {
    typealias Index = Storage.Index
    
    #if !swift(>=4.1)
    typealias IndexDistance = Storage.IndexDistance
    #endif
    #if swift(>=4.1)
    var count: Int {
        return self.lockingForWithValue { ptr in
            return ptr.pointee.count
        }
    }
    #else
    var count: IndexDistance {
        return self.lockingForWithValue { ptr in
            return ptr.pointee.count
        }
    }
    #endif
    
    var startIndex: Self.Index {
        return self.lockingForWithValue { ptr in
            return ptr.pointee.startIndex
        }
    }
    
    var endIndex: Self.Index {
        return self.lockingForWithValue { ptr in
            return ptr.pointee.endIndex
        }
    }
    
    var isEmpty: Bool {
        return self.lockingForWithValue { ptr in
            return ptr.pointee.isEmpty
        }
    }
    
    var first: Self.Element? {
        return self.lockingForWithValue { ptr in
            return ptr.pointee.first
        }
    }
    
    subscript(index: Self.Index) -> Self.Element {
        return self.lockingForWithValue { ptr in
            return ptr.pointee[index]
        }
    }
    
    subscript(bounds: Range<Self.Index>) -> Storage.SubSequence {
        return self.lockingForWithValue { ptr in
            return ptr.pointee[bounds]
        }
    }
    
}

public extension SynchronizableStorage where Storage: BidirectionalCollection {
    var last: Self.Element? {
        return self.lockingForWithValue { ptr in
            return ptr.pointee.last
        }
    }
}


