
import Foundation

/// A property wrapper that provides the COW 🐮 (Copy-On-Write) optimization for any Value type.
/// https://github.com/apple/swift/blob/main/docs/OptimizationTips.rst#advice-use-copy-on-write-semantics-for-large-values
@propertyWrapper
public struct 🐮<V> {
    private var wrapper: Reference<V>

    public init(wrappedValue: V) {
        wrapper = Reference(wrappedValue)
    }

    public var wrappedValue: V {
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

private final class Reference<V> { // wrapping class
    var value: V

    init(_ val: V) {
        value = val
    }
}

extension 🐮: Equatable where V: Equatable { // Equatable conformance for "COW wrapped" values
    public static func == (lhs: 🐮<V>, rhs: 🐮<V>) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}

extension 🐮: Decodable where V: Decodable { // Decodable conformance for "COW wrapped" values
    public init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(V.self)
        self = 🐮(wrappedValue: value)
    }
}

extension 🐮: Encodable where V: Encodable { // Encodable conformance for "COW wrapped" values
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}
