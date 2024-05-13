
import Foundation

/// A property wrapper that allows to ignore a property when performing an equality check

@propertyWrapper
public struct IgnoreEquatable<Value>: Equatable {
    public var wrappedValue: Value

    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }

    public static func == (_: IgnoreEquatable<Value>, _: IgnoreEquatable<Value>) -> Bool {
        true // always equal
    }
}
