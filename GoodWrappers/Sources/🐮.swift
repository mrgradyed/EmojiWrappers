
import Foundation

/// A property wrapper that provides the COW 🐮 (Copy-On-Write) optimization for any Value type.

@propertyWrapper
public struct 🐮<Value> {
    private var wrapper: Reference<Value>

    public init(wrappedValue: Value) {
        wrapper = Reference(wrappedValue)
    }

    public var wrappedValue: Value {
        get { // upon "reading", simply return the current value stored inside the wrapper class instance
            wrapper.value
        }

        set { // upon "writing", if the wrapper class has more than 1 strong reference, create a new instance of the wrapper with the new value
            if isKnownUniquelyReferenced(&wrapper) == false {
                wrapper = Reference(newValue)

                return
            }

            // otherwise if there's only 1 strong reference to the wrapping class, set the new value in the current instance, discarding the old one
            wrapper.value = newValue // replace
        }
    }
}

private final class Reference<Value> { // wrapping class
    var value: Value

    init(_ val: Value) {
        value = val
    }
}

extension 🐮: Equatable where Value: Equatable { // Equatable conformance for "COW wrapped" values
    public static func == (lhs: 🐮<Value>, rhs: 🐮<Value>) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}

extension 🐮: Decodable where Value: Decodable { // Decodable conformance for "COW wrapped" values
    public init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(Value.self)
        self = 🐮(wrappedValue: value)
    }
}

extension 🐮: Encodable where Value: Encodable { // Encodable conformance for "COW wrapped" values
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}
