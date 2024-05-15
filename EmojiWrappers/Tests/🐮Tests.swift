
import EmojiWrappers
import Foundation
import XCTest

class 🐮Tests: XCTestCase {
    func testNotWrappedRead() {
        struct NotWrapped: Equatable {
            var propC: TestStruct
        }

        let a = NotWrapped(propC: TestStruct(propA: "k", propB: 97))
        let b = a

        DispatchQueue.main.async {
            XCTAssertTrue(address(of: a.propC) != address(of: b.propC))
        }
    }

    func testWrappedRead() {
        struct Wrapped: Equatable {
            @🐮 var propC: TestStruct
        }

        let a = Wrapped(propC: TestStruct(propA: "k", propB: 97))
        let b = a

        DispatchQueue.main.async {
            XCTAssertTrue(address(of: a.propC) == address(of: b.propC))
        }
    }

    func testWrappedWriteSingleRef() {
        struct Wrapped: Equatable {
            @🐮 var propC: TestStruct
        }

        var a = Wrapped(propC: TestStruct(propA: "k", propB: 97))
        a.propC = TestStruct(propA: "changed", propB: 57)

        XCTAssertTrue(a.propC == TestStruct(propA: "changed", propB: 57))
    }

    func testWrappedWriteMultiRef() {
        struct Wrapped: Equatable {
            @🐮 var propC: TestStruct
        }

        let a = Wrapped(propC: TestStruct(propA: "k", propB: 97))
        var b = a
        b.propC = TestStruct(propA: "changed", propB: 57)

        DispatchQueue.main.async {
            XCTAssertTrue(address(of: a.propC) != address(of: b.propC))
        }
    }

    func testWrappedEquality() {
        struct Wrapped: Equatable {
            @🐮 var propC: TestStruct
        }

        let a = Wrapped(propC: TestStruct(propA: "k", propB: 97))
        var b = a

        XCTAssertTrue(a == b)
        b.propC = TestStruct(propA: "k", propB: 97)

        XCTAssertTrue(a == b)
    }

    func testWrappedDecodable() {
        struct Wrapped: Equatable, Decodable {
            @🐮 var propC: TestStruct
        }

        let json = "{\"propC\":{\"propA\":\"propA\",\"propB\":100}}"
        let wrapped = try! JSONDecoder().decode(Wrapped.self, from: json.data(using: .utf8)!)

        XCTAssertTrue(wrapped.propC == .init(propA: "propA", propB: 100))
    }

    func testWrappedEncodable() {
        struct Wrapped: Equatable, Encodable {
            @🐮 var propC: TestStruct
        }

        let wrapped = Wrapped(propC: .init(propA: "propA", propB: 100))
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        let encodedData = try! encoder.encode(wrapped)
        let encodedString = String(data: encodedData, encoding: .utf8)

        XCTAssertTrue(encodedString == "{\"propC\":{\"propA\":\"propA\",\"propB\":100}}")
    }
}

struct TestStruct: Equatable, Codable {
    var propA: String
    var propB: Int
}

func address(of value: some Any) -> String {
    withUnsafePointer(to: value) { "\($0)" }
}
