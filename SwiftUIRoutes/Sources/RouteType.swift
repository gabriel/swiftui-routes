import Foundation

/// Route for value types
public struct RouteType: Hashable {
    public let id: ObjectIdentifier
    public let value: AnyHashable

    public init(_ value: some Hashable) {
        id = ObjectIdentifier(type(of: value))
        self.value = AnyHashable(value)
    }
}
