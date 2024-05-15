
import Foundation

/// A property wrapper that allows to ignore a property when performing an equality check

@propertyWrapper
public struct 🟰<Value>: Equatable {
    public var wrappedValue: Value

    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }

    public static func == (_: 🟰<Value>, _: 🟰<Value>) -> Bool {
        true // always equal
    }
}
