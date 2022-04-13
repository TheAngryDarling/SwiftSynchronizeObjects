//
//  Lockable.swift
//
//
//  Created by Tyler Anger on 2022-04-12.
//
import Foundation
import Dispatch

/// Protocol defining an object used to synchronize calls
///
/// Currently implemented: NSLock, DispatchQueue, OperationQueue
public protocol Lockable {
    ///Lock the resource for the duration of the code execution
    func lockingFor(_ block: @escaping () -> Void)
    ///Lock the resource for the duration of the code execution
    func lockingFor(_ block: @escaping () throws -> Void) throws
    ///Lock the resource for the duration of the code execution
    func lockingFor<T>(_ block: @escaping () -> T) -> T
    ///Lock the resource for the duration of the code execution
    func lockingFor<T>(_ block: @escaping () throws -> T) throws -> T
}

extension NSLock: Lockable {
    public func lockingFor(_ block: @escaping () -> Void) {
        self.lock()
        defer { self.unlock() }
        block()
    }
    public func lockingFor(_ block: @escaping () throws -> Void) throws {
        self.lock()
        defer { self.unlock() }
        try block()
    }
    public func lockingFor<T>(_ block: @escaping () -> T) -> T {
        self.lock()
        defer { self.unlock() }
        return block()
    }
    public func lockingFor<T>(_ block: @escaping () throws -> T) throws -> T {
        self.lock()
        defer { self.unlock() }
        return try block()
    }
}

extension OperationQueue: Lockable {
    /// An operation used to execute code block in OperationQueue and wait for completion
    private class Op<T>: Operation {
        private let task: () throws -> T
        public private(set) var results: T? = nil
        public private(set) var err: Error? = nil
        
        public init(void block: @escaping () -> Void) {
            self.task = { //() throws -> Void
                return (block() as! T)
            }
        }
        public init(nothrow block: @escaping () -> T) {
            self.task = { //() throws -> T
                return block()
            }
        }
        public init(_ block: @escaping () throws -> T) {
            self.task = block
        }
        override func main() {
            guard !self.isCancelled else {
                return
            }
            do {
                self.results = try self.task()
            } catch {
                self.err = error
            }
        }
    }
    public func lockingFor(_ block: @escaping () -> Void) {
        let op = Op<Void>(void: block)
        self.addOperation(op)
        op.waitUntilFinished()
    }
    public func lockingFor(_ block: @escaping () throws -> Void) throws {
        let op = Op<Void>(block)
        self.addOperation(op)
        op.waitUntilFinished()
        if let e = op.err {
            throw e
        }
    }
    public func lockingFor<T>(_ block: @escaping () -> T) -> T {
        let op = Op<T>(nothrow: block)
        self.addOperation(op)
        op.waitUntilFinished()
        return op.results!
    }
    public func lockingFor<T>(_ block: @escaping () throws -> T) throws -> T {
        let op = Op<T>(block)
        self.addOperation(op)
        op.waitUntilFinished()
        if let e = op.err {
            throw e
        }
        return op.results!
    }
}

extension DispatchQueue: Lockable {
    public func lockingFor(_ block: @escaping () -> Void) {
        self.sync(execute: block)
    }
    public func lockingFor(_ block: @escaping () throws -> Void) throws {
        try self.sync(execute: block)
    }
    public func lockingFor<T>(_ block: @escaping () -> T) -> T {
        return self.sync(execute: block)
    }
    public func lockingFor<T>(_ block: @escaping () throws -> T) throws -> T {
        return try self.sync(execute: block)
    }
}
