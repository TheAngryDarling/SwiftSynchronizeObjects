//
//  SyncObj.swift
//  
//
//  Created by Tyler Anger on 2022-04-12.
//

import Foundation
import Dispatch

public protocol SynchronizableStorage {
    associatedtype Storage
    
    var value: Storage { get set }
}

public class SynchronizableObject<Object>: SynchronizableStorage {
    
    private var _value: Object
    fileprivate let _lock: (@escaping () -> Object) -> Object
    
    /// Synchronized access to the resource
    public var value: Object {
        get { return self._lock { return self._value } }
        set { _ = self._lock { self._value = newValue; return newValue } }
    }
    /// Access to the resource without synchronization
    public var unsafeValue: Object {
        get { return  self._value }
        set { self._value = newValue }
    }
    
    public init(value: Object,
                locking: @escaping ( @escaping () -> Object) -> Object) {
        self._value = value
        self._lock = locking
    }
    /// Method used to lock the resource for the execution of the block
    public func lockingFor(_ block: @escaping () -> Void) {
        _ = self._lock {
           block()
            return self.unsafeValue
        }
    }
    
}

public extension SynchronizableObject where Object: Equatable {
    static func ==(lhs: SynchronizableObject,
                   rhs: SynchronizableObject) -> Bool {
        return lhs.value == rhs.value
    }
    static func ==(lhs: SynchronizableObject,
                   rhs: Object) -> Bool {
        return lhs.value == rhs
    }
    static func !=(lhs: SynchronizableObject,
                   rhs: SynchronizableObject) -> Bool {
        return lhs.value != rhs.value
    }
    static func !=(lhs: SynchronizableObject,
                   rhs: Object) -> Bool {
        return lhs.value != rhs
    }
}

public extension SynchronizableObject where Object: Comparable {
    static func <(lhs: SynchronizableObject,
                  rhs: SynchronizableObject) -> Bool {
        return lhs.value < rhs.value
    }
    static func <(lhs: SynchronizableObject,
                  rhs: Object) -> Bool {
        return lhs.value < rhs
    }
    static func <=(lhs: SynchronizableObject,
                   rhs: SynchronizableObject) -> Bool {
        return lhs.value <= rhs.value
    }
    static func <=(lhs: SynchronizableObject,
                   rhs: Object) -> Bool {
        return lhs.value <= rhs
    }
    static func >(lhs: SynchronizableObject,
                   rhs: SynchronizableObject) -> Bool {
        return lhs.value > rhs.value
    }
    static func >(lhs: SynchronizableObject,
                   rhs: Object) -> Bool {
        return lhs.value > rhs
    }
    static func >=(lhs: SynchronizableObject,
                   rhs: SynchronizableObject) -> Bool {
        return lhs.value >= rhs.value
    }
    static func >=(lhs: SynchronizableObject,
                   rhs: Object) -> Bool {
        return lhs.value >= rhs
    }
}

public extension SynchronizableObject where Object: Numeric {
    static func +=(lhs: inout SynchronizableObject,
                   rhs: SynchronizableObject) {
        lhs.value += rhs.value
    }
    static func +=(lhs: inout SynchronizableObject,
                   rhs: Object) {
        lhs.value += rhs
    }
    static func -=(lhs: inout SynchronizableObject,
                   rhs: SynchronizableObject) {
        lhs.value -= rhs.value
    }
    static func -=(lhs: inout SynchronizableObject,
                   rhs: Object) {
        lhs.value -= rhs
    }
    static func *=(lhs: inout SynchronizableObject,
                   rhs: SynchronizableObject) {
        lhs.value *= rhs.value
    }
    static func *=(lhs: inout SynchronizableObject,
                   rhs: Object) {
        lhs.value *= rhs
    }
}

public extension SynchronizableObject where Object: FixedWidthInteger {
    /// Increate the value of the resurce by 1 and return the new value
    func incrementalValue() -> Object {
        return self._lock {
            var rtn = self.unsafeValue
            rtn += 1
            self.unsafeValue = rtn
            return rtn
        }
    }
    /// Decrease the value of the resource by 1 and return the new value
    func decrementalValue() -> Object {
        return self._lock {
            var rtn = self.unsafeValue
            rtn += 1
            self.unsafeValue = rtn
            return rtn
        }
    }
}

public extension SynchronizableObject where Object == String {
    static func +=(lhs: inout SynchronizableObject,
                   rhs: SynchronizableObject) {
        lhs.value += rhs.value
    }
    static func +=(lhs: inout SynchronizableObject,
                   rhs: Object) {
        lhs.value += rhs
    }
}
 
/// A Class that can synchronize access to an object
public class SyncObj<Object, Lock>: SynchronizableObject<Object> where Lock: Lockable {
    /// the object locking the resource
    public let lock: Lock
    
    /// Create new Synchronized Object
    /// - Parameters:
    ///   - value: The value of the resource
    ///   - lock: The object used to synchronize access to the resoruce
    public init(value: Object, lock: Lock) {
        self.lock = lock
        super.init(value: value) { f in
            return lock.lockingFor(f)
        }
    }
}

/// Typealias of SyncObj where Lock = NSLock
public typealias SyncLockObj<Object> = SyncObj<Object, NSLock>
public extension SyncObj where Lock == NSLock {
    /// Create new Instance of SyncObj
    /// - Parameters:
    ///   - object: The object to keep in sync
    ///   - lockName: The name to give the NSLock
    convenience init(value: Object, lockName: String? = nil) {
        let lock = NSLock()
        if let n = lockName {
            lock.name = n
        }
        self.init(value: value, lock: lock)
    }
}
/// Typealias of SyncObj where Lock = NSRecursiveLock
public typealias SyncRecursiveLockObj<Object> = SyncObj<Object, NSRecursiveLock>
public extension SyncObj where Lock == NSRecursiveLock {
    /// Create new Instance of SyncObj
    /// - Parameters:
    ///   - object: The object to keep in sync
    ///   - lockName: The name to give the NSRecursiveLock
    convenience init(value: Object, lockName: String? = nil) {
        let lock = NSRecursiveLock()
        if let n = lockName {
            lock.name = n
        }
        self.init(value: value, lock: lock)
    }
}

/// Typealias of SyncObj where Lock = DispatchQueue
public typealias SyncQueueObj<Object> = SyncObj<Object, DispatchQueue>
public extension SyncObj where Lock == DispatchQueue {
    /// Create new Instance of SyncObj
    /// - Parameters:
    ///   - object: The object to keep in sync
    ///   - lockingQueueName: The label of the DispatchQueue
    ///   - lockingQueueQoS: The quality of service for the DispatchQueue
    convenience init(value: Object,
                     lockingQueueName: String = "SyncQueueObj.lock",
                     lockingQueueQoS: DispatchQoS = .unspecified) {
        let lock = DispatchQueue(label: lockingQueueName,
                                 qos: lockingQueueQoS)
        self.init(value: value,
                  lock: lock)
    }
}

/// Typealias of SyncObj where Lock = OperationQueue
public typealias SyncOptQueueObj<Object> = SyncObj<Object, OperationQueue>
public extension SyncObj where Lock == OperationQueue {
    
    /// - Parameters:
    ///   - object: The object to keep in sync
    ///   - lockingQueueName: The name of the OperationQueue
    ///   - lockingQueueQoS: The quality of service for the OperationQueue
    convenience init(value: Object,
                     lockingQueueName: String? = nil,
                     lockingQueueQoS: QualityOfService = .default) {
        let lock = OperationQueue()
        if let n = lockingQueueName {
            lock.name = n
        }
        lock.qualityOfService = lockingQueueQoS
        self.init(value: value,
                  lock: lock)
    }
}
