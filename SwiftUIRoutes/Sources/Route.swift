import Foundation

/// We need a generic wrapper for Routes so we can use a [Route] array for NavigationStack path.
/// We could use NavigationPath, with mixed types but it doesn't support things like last().
public enum Route: Hashable {
    case byType(ObjectIdentifier, AnyHashable)
    case url(path: String, params: [String: String])

    public static func byType(_ value: some Hashable) -> Route {
        let id = ObjectIdentifier(type(of: value))
        return Route.byType(id, AnyHashable(value))
    }
}
