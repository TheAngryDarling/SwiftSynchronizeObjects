//
//  SynchronizableStorage+FixedWidthInteger.swift
//  
//
//  Created by Tyler Anger on 2022-04-24.
//

import Foundation

public extension SynchronizableStorage where Storage: FixedWidthInteger {
    /// Increate the value of the resurce by 1 and return the new value
    func incrementalValue() -> Storage {
        return self.lockingForWithValue { ptr in
            ptr.pointee += 1
            return ptr.pointee
        }
    }
    /// Decrease the value of the resource by 1 and return the new value
    func decrementalValue() -> Storage {
        return self.lockingForWithValue { ptr in
            ptr.pointee -= 1
            return ptr.pointee
        }
    }
}
