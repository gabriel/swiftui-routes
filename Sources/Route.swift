import Foundation

// Instead of forcing route values to be Hashable, make them conform to a Routable resource.
public protocol Routable {
    var resource: RouteResource { get }
}

/// We need a generic wrapper for Routes so we can use a [Route] array for NavigationStack path.
/// We could use NavigationPath, with mixed types but it doesn't support things like last().
public enum Route: Hashable {
    case value(Routable)
    case url(path: String, params: [String: String])

    public func hash(into hasher: inout Hasher) {
        switch self {
        case let .value(value):
            hasher.combine(value.resource)
        case .url(let path, let params):
            hasher.combine(path)
            hasher.combine(params)
        }
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.value(let lhs), .value(let rhs)):
            return lhs.resource == rhs.resource
        case (.url(let lhsPath, let lhsParams), .url(let rhsPath, let rhsParams)):
            return lhsPath == rhsPath && lhsParams == rhsParams
        default:
            return false
        }
    }
}
