
import Foundation
import GoodWrappers
import XCTest

class IgnoreEquatableTests: XCTestCase {
    public struct Test: Equatable {
        @IgnoreEquatable var propertyA: Int
        var propertyB: Int
    }

    func testIgnoreEquatable() {
        // this equality check must pass, although property A is different
        XCTAssertTrue(Test(propertyA: 1, propertyB: 3) == Test(propertyA: 2, propertyB: 3))

        // this equality check must fail, since property B is different but not wrapped
        XCTAssertFalse(Test(propertyA: 1, propertyB: 3) == Test(propertyA: 2, propertyB: 4))
    }
}
