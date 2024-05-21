
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
