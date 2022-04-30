//
//  SyncObj+DefaultInit.swift
//
//  Extending SyncObj where Object: SyncDefaultInit
//  to allow initialization with no value parameter
//
//  Created by Tyler Anger on 2022-04-29.
//

import Foundation
import Dispatch

public extension SyncObj where Object: SyncDefaultInit {
    convenience init(lock: Lock = Lock.newSyncLockObject() as! Lock) {
        self.init(value: Object(), lock: lock)
    }
}


public extension SyncObj where Object: SyncDefaultInit, Lock == NSLock {
    /// Create new Instance of SyncObj
    /// - Parameters:
    ///   - lockName: The name to give the NSLock
    convenience init(lockName: String?) {
        self.init(value: Object(),
                  lock: Lock.newSyncLockObject(lockName: lockName) as! Lock)
    }
}
public extension SyncObj where Object: SyncDefaultInit, Lock == NSRecursiveLock {
    /// Create new Instance of SyncObj
    /// - Parameters:
    ///   - lockName: The name to give the NSRecursiveLock
    convenience init(lockName: String?) {
        self.init(value: Object(),
                  lock: Lock.newSyncLockObject(lockName: lockName) as! Lock)
    }
}

public extension SyncObj where Object: SyncDefaultInit, Lock == DispatchQueue {
    /// Create new Instance of SyncObj
    /// - Parameters:
    ///   - lockingQueueName: The label of the DispatchQueue
    ///   - lockingQueueQoS: The quality of service for the DispatchQueue
    convenience init(lockingQueueName: String,
                     lockingQueueQoS: DispatchQoS = Lock.DefaultSyncLockQueueQOS) {
        self.init(value: Object(),
                  lock: Lock.newSyncLockObject(lockingQueueName: lockingQueueName,
                                        lockingQueueQoS: lockingQueueQoS) as! Lock)
    }
}

public extension SyncObj where Object: SyncDefaultInit, Lock == OperationQueue {
    /// - Parameters:
    ///   - lockingQueueName: The name of the OperationQueue
    ///   - lockingQueueQoS: The quality of service for the OperationQueue
    convenience init(lockingQueueName: String?,
                     lockingQueueQoS: QualityOfService = Lock.DefaultSyncLockQueueQOS) {
        self.init(value: Object(),
                  lock: Lock.newSyncLockObject(lockingQueueName: lockingQueueName,
                                        lockingQueueQoS: lockingQueueQoS) as! Lock)
    }
}
