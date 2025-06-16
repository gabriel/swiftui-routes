import Foundation

/// We need a generic wrapper for Routes so we can use a [Route] array for NavigationStack path.
/// We could use NavigationPath, with mixed types but it doesn't support things like last().
public struct Route: Hashable {
    public let id: ObjectIdentifier
    public let value: AnyHashable

    public init<T: Hashable>(_ value: T) {
        id = ObjectIdentifier(type(of: value))
        self.value = AnyHashable(value)
    }
}
