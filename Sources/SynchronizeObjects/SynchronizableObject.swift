//
//  SynchronizableObject.swift
//  
//
//  Created by Tyler Anger on 2022-04-24.
//

import Foundation

public class SynchronizableObject<Object>: SynchronizableStorage {
    /// Defining method type used to lock a resource for the execution of a block
    public typealias LockingFor = (@escaping () -> Void) -> Void
    
    private var _value: Object
    fileprivate private(set) var _lock: LockingFor
    
    /// Synchronized access to the resource
    public var value: Object {
        get { return self.lockingFor { return self._value } }
        set { _ = self._lock { self._value = newValue; } }
    }
    /// Access to the resource without synchronization
    public var unsafeValue: Object {
        get { return  self._value }
        set { self._value = newValue }
    }
    
    /// Create new Synchronizable Object
    /// - Parameters:
    ///   - value: The Object to keep synchronized
    ///   - locking: The locking method
    public init(value: Object,
                locking: @escaping LockingFor) {
        self._value = value
        self._lock = locking
    }
    
    /// Create new Synchronizable Object
    /// - Parameters:
    ///   - value: The Object to keep synchronized
    ///   - locking: The locking method
    @available(*, deprecated, renamed: "init(value:locking:)")
    public init(value: Object,
                locking: @escaping ( @escaping () -> Object) -> Object) {
        self._value = value
        /// This is done to fix using self within a closure
        self._lock = { _ in return }
        self._lock = { [unowned self] f in
            func lock() -> Object {
                f()
                return self._value
            }
            _ = locking(lock)
        }
    }
    /// Method used to lock the resource for the execution of the block
    public func lockingFor(_ block: @escaping () -> Void) {
        self._lock {
           block()
        }
    }
    
    /// Method used to lock the resource for the execution of the block
    public func lockingFor(_ block: @escaping () throws -> Void) throws {
        var err: Error?
        self._lock {
            do {
                try block()
            } catch {
                err = error
            }
        }
        if let e = err {
            throw e
        }
    }
    
    /// Method used to lock the resource for the execution of the block
    public func lockingFor<T>(_ block: @escaping () -> T) -> T {
        var rtn: T? = nil
        self._lock {
           rtn = block()
        }
        return rtn!
    }
    
    /// Method used to lock the resource for the execution of the block
    public func lockingFor<T>(_ block: @escaping () throws -> T) throws -> T {
        var rtn: T?
        var err: Error?
        self._lock {
            do {
                rtn = try block()
            } catch {
                err = error
            }
        }
        if let e = err {
            throw e
        }
        return rtn!
    }
    
    
    
    /// Method used to lock the resource for the execution of the block
    public func lockingForWithValue(_ block: @escaping (UnsafeMutablePointer<Object>) -> Void) {
        self._lock {
            block(&self._value)
        }
    }
    
    /// Method used to lock the resource for the execution of the block
    public func lockingForWithValue(_ block: @escaping (UnsafeMutablePointer<Object>) throws -> Void) throws {
        var err: Error?
        self._lock {
            do {
                try block(&self._value)
            } catch {
                err = error
            }
        }
        if let e = err {
            throw e
        }
    }
    
    /// Method used to lock the resource for the execution of the block
    public func lockingForWithValue<T>(_ block: @escaping (UnsafeMutablePointer<Object>) -> T) -> T {
        var rtn: T? = nil
        self._lock {
           rtn = block(&self._value)
        }
        return rtn!
    }
    
    /// Method used to lock the resource for the execution of the block
    public func lockingForWithValue<T>(_ block: @escaping (UnsafeMutablePointer<Object>) throws -> T) throws -> T {
        var rtn: T?
        var err: Error?
        self._lock {
            do {
                rtn = try block(&self._value)
            } catch {
                err = error
            }
        }
        if let e = err {
            throw e
        }
        return rtn!
    }
    
}

#if swift(>=4.1)
extension SynchronizableObject: Equatable where Object: Equatable { }

// Would like to do this but gives an error about multiple matches of
// the >, >=, <, <= which are implemented in SynchronizableStorage+Comparable.swift
// extension SynchronizableObject: Comparable where Object: Comparable { }
#endif
