
import Foundation
import EmojiWrappers
import XCTest

class 🐮Tests: XCTestCase {
    struct TestStruct: Equatable {
        var propA: String = "123"
        var propB: Int = 456
    }

    func testNotWrappedRead() {
        DispatchQueue.main.async {
            struct NotWrapped: Equatable {
                var propC: TestStruct = .init()
            }

            var a = NotWrapped()
            var b = a

            XCTAssertFalse(withUnsafePointer(to: &a.propC) { $0 } == withUnsafePointer(to: &b.propC) { $0 })
        }
    }

    func testWrappedRead() {
        DispatchQueue.main.async {
            struct Wrapped: Equatable {
                @🐮 var propC: TestStruct = .init()
            }

            var a = Wrapped()
            var b = a

            XCTAssertTrue(withUnsafePointer(to: &a.propC) { $0 } == withUnsafePointer(to: &b.propC) { $0 })
        }
    }
}
