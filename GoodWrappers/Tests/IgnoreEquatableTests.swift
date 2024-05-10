
import Foundation
import GoodWrappers
import XCTest

class IgnoreEquatableTests: XCTestCase {
    public struct Test: Equatable {
        @IgnoreEquatable var propertyA: Int
        var propertyB: Int
    }

    func testIgnoreEquatable() {
        XCTAssertTrue(Test(propertyA: 1, propertyB: 3) == Test(propertyA: 2, propertyB: 3))
        XCTAssertFalse(Test(propertyA: 1, propertyB: 3) == Test(propertyA: 2, propertyB: 4))
    }
}
