//
//  SynchronizableStorage.swift
//  
//
//  Created by Tyler Anger on 2022-04-24.
//

import Foundation

/// Protocol defining an object that provides synchronized access
/// to a value
public protocol SynchronizableStorage {
    associatedtype Storage
    /// Synchronized access to the storage value
    var value: Storage { get set }
    
    /// Method used to lock the resource for the execution of the block
    func lockingFor(_ block: @escaping () -> Void)
    
    /// Method used to lock the resource for the execution of the block
    func lockingFor(_ block: @escaping () throws -> Void) throws
    
    /// Method used to lock the resource for the execution of the block
    func lockingFor<T>(_ block: @escaping () -> T) -> T
    
    /// Method used to lock the resource for the execution of the block
    func lockingFor<T>(_ block: @escaping () throws -> T) throws -> T
    
    /// Method used to lock the resource for the execution of the block
    func lockingForWithValue(_ block: @escaping (UnsafeMutablePointer<Storage>) -> Void)
    
    /// Method used to lock the resource for the execution of the block
    func lockingForWithValue(_ block: @escaping (UnsafeMutablePointer<Storage>) throws -> Void) throws
    
    /// Method used to lock the resource for the execution of the block
    func lockingForWithValue<T>(_ block: @escaping (UnsafeMutablePointer<Storage>) -> T) -> T
    
    /// Method used to lock the resource for the execution of the block
    func lockingForWithValue<T>(_ block: @escaping (UnsafeMutablePointer<Storage>) throws -> T) throws -> T
}
