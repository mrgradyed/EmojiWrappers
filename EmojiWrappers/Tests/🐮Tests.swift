
import EmojiWrappers
import Foundation
import XCTest

class 🐮Tests: XCTestCase {
    func testWrappedRead() {
        let a = CowStruct(cowValue: CustomStruct(property: ["aoh": 1]))
        let b = a // must assign without copying CustomStruct property

        XCTAssertTrue(a.cowValue == b.cowValue)
        XCTAssertTrue(b.cowValueWrapper.isPointingToSameRefOf(a.cowValueWrapper)) // a and b should point to the same reference wrapper class
    }

    func testWrappedWriteSingleReference() {
        var a = CowStruct(cowValue: CustomStruct(property: ["aoh": 1]))
        a.cowValue = CustomStruct(property: ["aoh": 2])

        XCTAssertTrue(a.cowValue == CustomStruct(property: ["aoh": 2]))
    }

    func testWrappedWriteMultipleReferences() {
        let a = CowStruct(cowValue: CustomStruct(property: ["aoh": 1]))
        var b = a // must assign without copying CustomStruct property
        b.cowValue = CustomStruct(property: ["aoh": 2])

        XCTAssertTrue(a != b)
        XCTAssertTrue(b.cowValue == CustomStruct(property: ["aoh": 2]))
        XCTAssertFalse(b.cowValueWrapper.isPointingToSameRefOf(a.cowValueWrapper)) // a and b should NOT point to the same reference wrapper class
    }

    func testWrappedEquality() {
        let a = CowStruct(cowValue: CustomStruct(property: ["aoh": 1]))
        var b = a
        XCTAssertTrue(a == b)

        b.cowValue = CustomStruct(property: ["aoh": 2])
        XCTAssertTrue(a != b)
    }

    func testWrappedDecodable() {
        let json = "{\"cowValue\":{\"property\":{\"aoh\":1}}}"
        let cowStruct = try! JSONDecoder().decode(CowStruct.self, from: json.data(using: .utf8)!)

        XCTAssertTrue(cowStruct.cowValue == CustomStruct(property: ["aoh": 1]))
    }

    func testWrappedEncodable() {
        let cowStruct = CowStruct(cowValue: CustomStruct(property: ["aoh": 1]))
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        let encodedData = try! encoder.encode(cowStruct)
        let encodedString = String(data: encodedData, encoding: .utf8)

        XCTAssertTrue(encodedString == "{\"cowValue\":{\"property\":{\"aoh\":1}}}")
    }

    struct CustomStruct: Equatable, Codable {
        var property: [String: Int]
    }

    struct CowStruct: Equatable, Codable {
        @🐮 var cowValue: CustomStruct

        var cowValueWrapper: 🐮<CustomStruct> {
            _cowValue
        }
    }
}
