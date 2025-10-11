import Foundation

/// We need a generic wrapper for Routes so we can use a [Route] array for NavigationStack path.
/// We could use NavigationPath, with mixed types but it doesn't support things like last().
public enum Route: Hashable {
    case value(AnyHashable)
    case url(path: String, params: [String: String])

    public func hash(into hasher: inout Hasher) {
        switch self {
        case let .value(value):
            hasher.combine(value)
        case .url(let path, let params):
            hasher.combine(path)
            hasher.combine(params)
        }
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.value(let lhs), .value(let rhs)):
            return lhs == rhs
        case (.url(let lhsPath, let lhsParams), .url(let rhsPath, let rhsParams)):
            return lhsPath == rhsPath && lhsParams == rhsParams
        default:
            return false
        }
    }
}
