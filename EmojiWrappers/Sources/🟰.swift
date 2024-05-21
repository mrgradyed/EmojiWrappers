
import Foundation

/// A property wrapper that allows to ignore a property when performing an equality check

@propertyWrapper
public struct 🟰<V>: Equatable {
    public var wrappedValue: V

    public init(wrappedValue: V) {
        self.wrappedValue = wrappedValue
    }

    public static func == (_: 🟰<V>, _: 🟰<V>) -> Bool {
        true // always equal
    }
}

extension 🟰: Decodable where V: Decodable { // Decodable conformance
    public init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(V.self)
        self = 🟰(wrappedValue: value)
    }
}

extension 🟰: Encodable where V: Encodable { // Encodable conformance
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}
