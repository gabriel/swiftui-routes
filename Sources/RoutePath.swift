import Foundation
import SwiftUI

public typealias RoutePath = [RouteElement]

/// We need a generic wrapper for Routes so we can use a [RouteElement] array for NavigationStack path.
/// We could use NavigationPath, with mixed types but it doesn't support things like last().
public enum RouteElement: Hashable, Sendable {
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

@preconcurrency
private struct RoutePathEnvironmentKey: EnvironmentKey {
    static let defaultValue: Binding<RoutePath> = .constant(RoutePath())
}

public extension EnvironmentValues {
    var routePath: Binding<RoutePath> {
        get { self[RoutePathEnvironmentKey.self] }
        set { self[RoutePathEnvironmentKey.self] = newValue }
    }
}

public extension [RouteElement] {
    mutating func push(url: URL) {
        push(path: url.normalizedPath, params: url.params)
    }

    mutating func push(path: String, params: [String: String] = [:]) {
        self.append(RouteElement.url(path: path, params: params))
    }

    mutating func push(value: Routable) {
        self.append(RouteElement.value(value))
    }

    mutating func pop() {
        guard !isEmpty else { return }
        self.removeLast()
    }
}

public extension Binding where Value == RoutePath {
    func push(url: URL) {
        push(path: url.normalizedPath, params: url.params)
    }

    func push(path: String, params: [String: String] = [:]) {
        var newValue = wrappedValue
        newValue.push(path: path, params: params)
        wrappedValue = newValue
    }

    func push(value: Routable) {
        var newValue = wrappedValue
        newValue.push(value: value)
        wrappedValue = newValue
    }

    func pop() {
        guard !wrappedValue.isEmpty else { return }
        var newValue = wrappedValue
        newValue.pop()
        wrappedValue = newValue
    }
}
