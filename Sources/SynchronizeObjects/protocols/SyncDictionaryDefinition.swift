//
//  SyncDictionaryDefinition.swift
//
//
//  Created by Tyler Anger on 2022-04-24.
//

import Foundation

///  Protocol defining a dictionary.
///  Intended use is in generic inits / methods / objects
public protocol SyncDictionaryDefinition: Collection where Element == (key: Key, value: Value) {
    associatedtype Key: Hashable
    associatedtype Value
    
    subscript(key: Key) -> Value? { get set }
    subscript(key: Key, default defaultValue: @autoclosure () -> Value) -> Value { get set }
}


extension Dictionary: SyncDictionaryDefinition { }


// Provides access to a dictionary value
// Read only access on protocol to ensure that let variables can access
public extension SynchronizableStorage where Storage: SyncDictionaryDefinition {
    subscript(key: Storage.Key) -> Storage.Value? {
        get {
            return self.lockingForWithValue { return $0.pointee[key]  }
        }
    }
    subscript(key: Storage.Key,
              default defaultValue: @autoclosure () -> Storage.Value) -> Storage.Value {
        get {
            return self.lockingForWithValue { return $0.pointee[key] } ?? defaultValue()
        }
    }
}

// Provides access to a dictionary value
// Read / write access on class to ensrue that let variables can update
public extension SynchronizableObject where Object: SyncDictionaryDefinition {
    subscript(key: Storage.Key) -> Storage.Value? {
        get {
            return self.lockingForWithValue { return $0.pointee[key]  }
        }
        set {
            self.lockingForWithValue { $0.pointee[key] = newValue}
        }
    }
    subscript(key: Storage.Key,
              default defaultValue: @autoclosure () -> Storage.Value) -> Storage.Value {
        get {
            return self.lockingForWithValue { return $0.pointee[key] } ?? defaultValue()
        }
        set {
            self.lockingForWithValue { $0.pointee[key] = newValue}
        }
    }
}
