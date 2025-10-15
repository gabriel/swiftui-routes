import Foundation
import SwiftUI

public typealias RoutePath = [Routable]

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

public extension [Routable] {
    mutating func push(_ value: Routable) {
        self.append(value)
    }

    mutating func pop() {
        guard !isEmpty else { return }
        self.removeLast()
    }
}

public extension Binding where Value == RoutePath {
    func push(_ value: Routable) {
        var newValue = wrappedValue
        newValue.push(value)
        wrappedValue = newValue
    }

    func pop() {
        guard !wrappedValue.isEmpty else { return }
        var newValue = wrappedValue
        newValue.pop()
        wrappedValue = newValue
    }
}
