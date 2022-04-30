//
//  SynchronizableStorage+Sequence.swift
//  
//
//  Created by Tyler Anger on 2022-04-24.
//

import Foundation

public extension SynchronizableStorage where Storage: Sequence {
    typealias Element = Storage.Element
    
    func contains(where predicate: @escaping (Self.Element) -> Bool) -> Bool {
        return self.lockingForWithValue { ptr in
            return ptr.pointee.contains(where: predicate)
        }
    }
    func contains(where predicate: @escaping (Self.Element) throws -> Bool) throws -> Bool {
        return try self.lockingForWithValue { ptr in
            return try ptr.pointee.contains(where: predicate)
        }
    }
    
    func first(where predicate: @escaping (Self.Element) -> Bool) -> Self.Element? {
        return self.lockingForWithValue { ptr in
            return ptr.pointee.first(where: predicate)
        }
    }
    
    func first(where predicate: @escaping (Self.Element) throws -> Bool) throws -> Self.Element? {
        return try self.lockingForWithValue { ptr in
            return try ptr.pointee.first(where: predicate)
        }
    }
    
    func filter(_ isIncluded: @escaping (Self.Element) -> Bool) -> [Self.Element] {
        return self.lockingForWithValue { ptr in
            return ptr.pointee.filter(isIncluded)
        }
    }
    
    func filter(_ isIncluded: @escaping (Self.Element) throws -> Bool) throws -> [Self.Element] {
        return try self.lockingForWithValue { ptr in
            return try ptr.pointee.filter(isIncluded)
        }
    }
    
    func map<T>(_ transform: @escaping (Self.Element) -> T) -> [T] {
        return self.lockingForWithValue { ptr in
            return ptr.pointee.map(transform)
        }
    }
    
    func map<T>(_ transform: @escaping (Self.Element) throws -> T) throws -> [T] {
        return try self.lockingForWithValue { ptr in
            return try ptr.pointee.map(transform)
        }
    }
    #if swift(>=4.1)
    func compactMap<T>(_ transform: @escaping (Self.Element) -> T?) -> [T] {
        return self.lockingForWithValue { ptr in
            return ptr.pointee.compactMap(transform)
        }
    }
    
    func compactMap<T>(_ transform: @escaping (Self.Element) throws -> T?) throws -> [T] {
        return try self.lockingForWithValue { ptr in
            return try ptr.pointee.compactMap(transform)
        }
    }
    #endif
    func flatMap<SegmentOfResult>(_ transform: @escaping (Self.Element) -> SegmentOfResult) -> [SegmentOfResult.Element] where SegmentOfResult : Sequence {
        return self.lockingForWithValue { ptr in
            return ptr.pointee.flatMap(transform)
        }
    }
    
    func flatMap<SegmentOfResult>(_ transform: @escaping (Self.Element) throws -> SegmentOfResult) throws -> [SegmentOfResult.Element] where SegmentOfResult : Sequence {
        return try self.lockingForWithValue { ptr in
            return try ptr.pointee.flatMap(transform)
        }
    }
    
    func reduce<Result>(_ initialResult: Result,
                        _ nextPartialResult: @escaping (_ partialResult: Result,
                                                        Self.Element) -> Result) -> Result {
        return self.lockingForWithValue { ptr in
            return ptr.pointee.reduce(initialResult, nextPartialResult)
        }
    }
    
    func reduce<Result>(_ initialResult: Result,
                        _ nextPartialResult: @escaping (_ partialResult: Result,
                                                        Self.Element) throws -> Result) throws -> Result {
        return try self.lockingForWithValue { ptr in
            return try ptr.pointee.reduce(initialResult, nextPartialResult)
        }
    }
    
    func reduce<Result>(into initialResult: Result,
                        _ updateAccumulatingResult: @escaping (_ partialResult: inout Result,
                                                               Self.Element) -> ()) -> Result {
        return self.lockingForWithValue { ptr in
            return ptr.pointee.reduce(into: initialResult, updateAccumulatingResult)
        }
    }
    
    func reduce<Result>(into initialResult: Result,
                        _ updateAccumulatingResult: @escaping (_ partialResult: inout Result,
                                                               Self.Element) throws -> ()) throws -> Result {
        return try self.lockingForWithValue { ptr in
            return try ptr.pointee.reduce(into: initialResult, updateAccumulatingResult)
        }
    }
    
    /// Locks the value and executes a for each before unlocking
    func forEach(_ body: @escaping (Self.Element) throws -> Void) throws {
        try self.lockingForWithValue { ptr in
            try ptr.pointee.forEach(body)
        }
    }
    /// Locks the value and executes a for each before unlocking
    func forEach(_ body: @escaping (Self.Element) -> Void) {
        self.lockingForWithValue { ptr in
            ptr.pointee.forEach(body)
        }
    }
}

public extension SynchronizableStorage where Storage: Sequence, Storage.Element: Equatable {
    func contains(_ element: Self.Element) -> Bool {
        return self.lockingForWithValue { ptr in
            return ptr.pointee.contains(element)
        }
    }
}
