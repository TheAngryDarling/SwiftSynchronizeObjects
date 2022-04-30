//
//  SynchronizableObject+MutableCollection.swift
//
// Mutating properties and methods here are extended
// to SyncObj and not SynchronizableStorage because
// we want the storage object to be a let and not a var
// otherwise the storage object could be replaced and
// not just the value being updated
//
//  Created by Tyler Anger on 2022-04-29.
//

import Foundation

public extension SynchronizableObject where Object: MutableCollection {
    subscript(index: Index) -> Element {
        get {
            return self.lockingForWithValue { ptr in
                return ptr.pointee[index]
            }
        }
        set {
            self.lockingForWithValue { ptr in
                ptr.pointee[index] = newValue
            }
        }
    }
}

public extension SynchronizableObject where Object: RangeReplaceableCollection {
    func append(_ newElement: Element) {
        self.lockingForWithValue { ptr in
            ptr.pointee.append(newElement)
        }
    }
    func append<S>(contentsOf newElements: S) where S : Sequence, Element == S.Element {
        self.lockingForWithValue { ptr in
            ptr.pointee.append(contentsOf: newElements)
        }
    }
    func insert(_ newElement: Element, at i: Index) {
        self.lockingForWithValue { ptr in
            ptr.pointee.insert(newElement, at: i)
        }
    }
}
