
import EmojiWrappers
import Foundation
import XCTest

class 🐮Tests: XCTestCase {
    struct TestStruct: Equatable, Codable {
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

            let a = Wrapped()
            let b = a

            XCTAssertTrue(withUnsafePointer(to: a.propC) { $0 } == withUnsafePointer(to: b.propC) { $0 })
        }
    }

    func testWrappedWrite() {
        DispatchQueue.main.async {
            struct Wrapped: Equatable {
                @🐮 var propC: TestStruct = .init()
            }

            let a = Wrapped()
            var b = a

            b.propC = .init()

            XCTAssertFalse(withUnsafePointer(to: a.propC) { $0 } == withUnsafePointer(to: b.propC) { $0 })
        }
    }

    func testWrappedEquality() {
        struct Wrapped: Equatable {
            @🐮 var propC: TestStruct = .init()
        }

        let a = Wrapped()
        var b = a

        XCTAssertTrue(a == b)

        b.propC = .init()

        XCTAssertFalse(a != b)
    }

    func testWrappedDecodable() {
        struct Wrapped: Equatable, Decodable {
            @🐮 var propC: TestStruct = .init()
        }

        let json = """
        { "propC": { "propA" : "propA", "propB" : 100 } }
        """

        let wrapped = try! JSONDecoder().decode(Wrapped.self, from: json.data(using: .utf8)!)

        XCTAssertTrue(wrapped.propC == .init(propA: "propA", propB: 100))
    }

    func testWrappedEncodable() {
        struct Wrapped: Equatable, Encodable {
            @🐮 var propC: TestStruct = .init()
        }

        let wrapped = Wrapped(propC: .init(propA: "propA", propB: 100))
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        let encodedData = try! encoder.encode(wrapped)
        let encodedString = String(data: encodedData, encoding: .utf8)

        XCTAssertTrue(encodedString == "{\"propC\":{\"propA\":\"propA\",\"propB\":100}}")
    }
}
