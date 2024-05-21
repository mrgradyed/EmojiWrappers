
import EmojiWrappers
import Foundation
import XCTest

class 🟰Tests: XCTestCase {
    func testEquatable() {
        // this equality check must pass, although property A is different
        XCTAssertTrue(Test(propertyA: 1, propertyB: 3) == Test(propertyA: 2, propertyB: 3))

        // this equality check must fail, since property B is different but not wrapped
        XCTAssertFalse(Test(propertyA: 1, propertyB: 3) == Test(propertyA: 2, propertyB: 4))
    }

    func testDecodable() {
        let json = "{\"propertyA\":0,\"propertyB\":1}"
        let test = try! JSONDecoder().decode(Test.self, from: json.data(using: .utf8)!)

        XCTAssertTrue(test == Test(propertyA: 0, propertyB: 1))
    }

    func testWrappedEncodable() {
        let test = Test(propertyA: 0, propertyB: 1)
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        let encodedData = try! encoder.encode(test)
        let encodedString = String(data: encodedData, encoding: .utf8)

        XCTAssertTrue(encodedString == "{\"propertyA\":0,\"propertyB\":1}")
    }

    public struct Test: Equatable, Codable {
        @🟰 var propertyA: Int
        var propertyB: Int
    }
}
