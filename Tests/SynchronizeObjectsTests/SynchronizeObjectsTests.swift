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

        let lock1 = NSLock()
        let lock2 = DispatchQueue(label: "Lock2")
        let lock3 = OperationQueue()

        test(using: lock1)
        test(using: lock2)
        test(using: lock3)

        lock1.lockingFor {
            // just testing convienience call
        }

        lock2.lockingFor {
            // just testing convienience call
        }

        lock3.lockingFor {
            // just testing convienience call
        }
    }
    
    func testSyncObj() {
        let obj1 = SyncLockObj(value: "Testing1")
        let obj2 = SyncQueueObj(value: "Testing2",
                                lockingQueueName: "DispatchQueueLocking")
        let obj3 = SyncOptQueueObj(value: "Testing3",
                                   lockingQueueName: "OperationQueueLocking")

        XCTAssertEqual(obj1.value, "Testing1")
        obj1.value = "Replaced1"
        XCTAssertEqual(obj1.value, "Replaced1")
        
        XCTAssertEqual(obj2.value, "Testing2")
        obj2.value = "Replaced2"
        XCTAssertEqual(obj2.value, "Replaced2")

        XCTAssertEqual(obj3.value, "Testing3")
        obj3.value = "Replaced3"
        XCTAssertEqual(obj3.value, "Replaced3")
    }


    static var allTests = [
        ("testLockable", testLockable),
        ("testSyncObj", testSyncObj)
    ]
}
