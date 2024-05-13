
import Foundation
import GoodWrappers
import XCTest

class 🐮Tests: XCTestCase {
    struct Custom {
        var props: String = "123"
        var propi: Int = 456
    }

    func testRead🐮() {
        let cow = 🐮(wrappedValue: Custom())
        let cowCopy = cow // copy "cowed" value type

        XCTAssert(cow.wrapper === cowCopy.wrapper) // both pointing to the same wrapper class
    }

    func testWrite🐮() {
        let cow = 🐮(wrappedValue: Custom())
        var cowCopy = cow // copy "cowed" value type
        cowCopy.wrappedValue = .init() // set new value type

        XCTAssert(cow.wrapper !== cowCopy.wrapper) // different wrapper instances
    }
}
