//
//  SyncObj.swift
//  
//
//  Created by Tyler Anger on 2022-04-12.
//

import Foundation
import Dispatch

/// A Class that can synchronize access to an object
public class SyncObj<Object, Lock>: SynchronizableObject<Object> where Lock: Lockable {
    /// the object locking the resource
    public let lock: Lock
    
    /// Create new Synchronized Object
    /// - Parameters:
    ///   - value: The value of the resource
    ///   - lock: The object used to synchronize access to the resoruce
    public init(value: Object,
                lock: Lock = Lock.newSyncLockObject() as! Lock) {
        self.lock = lock
        super.init(value: value) { (f: @escaping () -> Void) -> Void in
            lock.lockingFor(f)
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
    convenience init(value: Object,
                     lockName: String?) {
        self.init(value: value,
                  lock: Lock.newSyncLockObject(lockName: lockName) as! Lock)
    }
}
/// Typealias of SyncObj where Lock = NSRecursiveLock
public typealias SyncRecursiveLockObj<Object> = SyncObj<Object, NSRecursiveLock>
public extension SyncObj where Lock == NSRecursiveLock {
    
    /// Create new Instance of SyncObj
    /// - Parameters:
    ///   - object: The object to keep in sync
    ///   - lockName: The name to give the NSRecursiveLock
    convenience init(value: Object,
                     lockName: String?) {
        self.init(value: value,
                  lock: Lock.newSyncLockObject(lockName: lockName) as! Lock)
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
                     lockingQueueName: String,
                     lockingQueueQoS: DispatchQoS = Lock.DefaultSyncLockQueueQOS) {
        self.init(value: value,
                  lock: Lock.newSyncLockObject(lockingQueueName: lockingQueueName,
                                        lockingQueueQoS: lockingQueueQoS) as! Lock)
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
                     lockingQueueName: String?,
                     lockingQueueQoS: QualityOfService = Lock.DefaultSyncLockQueueQOS) {
        
        self.init(value: value,
                  lock: Lock.newSyncLockObject(lockingQueueName: lockingQueueName,
                                        lockingQueueQoS: lockingQueueQoS) as! Lock)
    }
}
