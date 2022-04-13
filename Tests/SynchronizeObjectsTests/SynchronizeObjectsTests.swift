import XCTest
import Dispatch
@testable import SynchronizeObjects

class SynchronizeObjectsTests: XCTestCase {
    enum TestingError: Swift.Error {
        case intentional
    }
    func testLockable() {

        func usingLock1(lock: Lockable, task: @escaping () -> Void) {
            lock.lockingFor(task)
        }
        func usingLock2<T>(lock: Lockable, task: @escaping () -> T) -> T {
            return lock.lockingFor(task)
        }
        func usingLock3<T>(lock: Lockable, task: @escaping () throws -> T) throws -> T {
            return try lock.lockingFor(task)
        }

        let taskResponse: String = "Yes"
        func task1() { }

        func task2() -> String {
            return taskResponse
        }
        
        func task3a() throws -> String {
            return taskResponse
        }
        func task3b() throws -> String {
            throw TestingError.intentional
        }

        func test(using lock: Lockable) {
            usingLock1(lock: lock, task: task1)

            var string = usingLock2(lock: lock, task: task2)
            XCTAssertEqual(string, taskResponse)

            do {
                string = try usingLock3(lock: lock, task: task3a)
                XCTAssertEqual(string, taskResponse)
            } catch {
                XCTFail("\(error)")
            }

            do {
                string = try usingLock3(lock: lock, task: task3b)
                XCTFail("Expected to throw an exception")
            } catch TestingError.intentional {
                // do nothing
            } catch {
                XCTFail("\(error)")
            }
        }

        let locks: [Lockable] = [NSLock(),
                                 NSRecursiveLock(),
                                 DispatchQueue(label: "Lock2"),
                                 OperationQueue()
        ]
        
        for lock in locks  {
            test(using: lock)
            lock.lockingFor {
                // just testing convienience call
            }
        }
        
    }
    
    func testSyncObj() {
        let stringObj1 = SyncLockObj(value: "Testing")
        let stringObj2 = SyncLockObj(value: "Testing")
        let stringObj3 = SyncQueueObj(value: "Testing",
                                      lockingQueueName: "DispatchQueueLocking")
        let stringObj4 = SyncOptQueueObj(value: "Testing",
                                         lockingQueueName: "OperationQueueLocking")
        
        let stringObjects: [SynchronizableObject<String>] = [
            stringObj1,
            stringObj2,
            stringObj3,
            stringObj4
        ]
        
        for object in stringObjects {
            XCTAssertEqual(object.value, "Testing")
            XCTAssertTrue(object == "Testing")
            object.value = "Replaced"
            XCTAssertEqual(object.value, "Replaced")
            XCTAssertNotEqual(object.value, "Testing")
            XCTAssertTrue(object == "Replaced")
            XCTAssertTrue(object != "Testing")
        }

        let optStringObj1 = SyncLockObj(value: Optional<String>.none)
        let optStringObj2 = SyncLockObj(value: Optional<String>.none)
        let optStringObj3 = SyncQueueObj(value: Optional<String>.none,
                                      lockingQueueName: "DispatchQueueLocking")
        let optStringObj4 = SyncOptQueueObj(value: Optional<String>.none,
                                         lockingQueueName: "OperationQueueLocking")
        
        let optStringObjects: [SynchronizableObject<String?>] = [
            optStringObj1,
            optStringObj2,
            optStringObj3,
            optStringObj4
        ]
        
        for object in optStringObjects {
            XCTAssertEqual(object.value, nil)
            
            #if swift(>=4.1)
            XCTAssertTrue(object == nil)
            #endif
            
            object.value = "Replaced"
            XCTAssertEqual(object.value, "Replaced")
            
            #if swift(>=4.1)
            XCTAssertTrue(object == "Replaced")
            XCTAssertTrue(object != nil)
            #endif
        }
    }


    static var allTests = [
        ("testLockable", testLockable),
        ("testSyncObj", testSyncObj)
    ]
}
