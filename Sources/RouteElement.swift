import Foundation

/// We need a generic wrapper for Routes so we can use a [RouteElement] array for NavigationStack path.
/// We could use NavigationPath, with mixed types but it doesn't support things like last().
public enum RouteElement: Hashable {
    case value(Routable)
    case url(path: String, params: [String: String])

    public func hash(into hasher: inout Hasher) {
        switch self {
        case let .value(value):
            hasher.combine(value.route)
        case .url(let path, let params):
            hasher.combine(path)
            hasher.combine(params)
        }
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.value(let lhs), .value(let rhs)):
            return lhs.route == rhs.route
        case (.url(let lhsPath, let lhsParams), .url(let rhsPath, let rhsParams)):
            return lhsPath == rhsPath && lhsParams == rhsParams
        default:
            return false
        }
    }
}
