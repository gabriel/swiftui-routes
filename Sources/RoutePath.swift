import Foundation
import SwiftUI

public typealias RoutePath = [AnyRoutable]

public extension View {
    func routesDestination(routes: Routes, path: Binding<RoutePath>) -> some View {
        navigationDestination(for: AnyRoutable.self) { route in
            routes.view(route)
        }
        .environment(\.routePath, path)
    }
}

@preconcurrency
private struct RoutePathEnvironmentKey: EnvironmentKey {
    static let defaultValue: Binding<RoutePath> = .constant(RoutePath())
}

@preconcurrency
private struct RouteSheetEnvironmentKey: EnvironmentKey {
    static let defaultValue: Binding<Routable?> = .constant(nil)
}

public extension EnvironmentValues {
    var routePath: Binding<RoutePath> {
        get { self[RoutePathEnvironmentKey.self] }
        set { self[RoutePathEnvironmentKey.self] = newValue }
    }

    var routeSheet: Binding<Routable?> {
        get { self[RouteSheetEnvironmentKey.self] }
        set { self[RouteSheetEnvironmentKey.self] = newValue }
    }
}

public extension Binding where Value == RoutePath {
    func push(_ value: Routable) {
        var newValue = wrappedValue
        newValue.push(value)
        wrappedValue = newValue
    }

    func push(_ value: AnyRoutable) {
        var newValue = wrappedValue
        newValue.push(value)
        wrappedValue = newValue
    }

    func push(value: Routable) {
        push(value)
    }

    func push(path: String, params: [String: String] = [:]) {
        push(Route(path, params))
    }

    func pop() {
        guard !wrappedValue.isEmpty else { return }
        var newValue = wrappedValue
        newValue.pop()
        wrappedValue = newValue
    }
}

public extension RoutePath {
    mutating func push(_ value: Routable) {
        self.append(AnyRoutable(value))
    }

    mutating func push(_ value: AnyRoutable) {
        self.append(value)
    }

    mutating func push(value: Routable) {
        push(value)
    }

    mutating func push(path: String, params: [String: String] = [:]) {
        push(Route(path, params))
    }

    mutating func pop() {
        guard !isEmpty else { return }
        self.removeLast()
    }
}
