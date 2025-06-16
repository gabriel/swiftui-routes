import Combine
import SwiftUI

public class RouteRegistry {
    private var objects: [ObjectIdentifier: (Any) -> AnyView] = [:]

    private var paths: [String: (RouteParams) -> AnyView] = [:]

    public init() {}

    public func register<T>(type: T.Type, _ build: @escaping (T) -> some View) {
        let id = ObjectIdentifier(type)
        objects[id] = { any in
            guard let t = any as? T else { return AnyView(Text("SwiftUIRoutes: Type mismatch")) }
            return AnyView(build(t))
        }
    }

    public func register(path: String, _ build: @escaping (RouteParams) -> some View) {
        paths[path] = { params in
            AnyView(build(params))
        }
    }

    public func view(route: Route) -> AnyView {
        switch route {
        case let .byType(id, value):
            guard let builder = objects[id] else {
                return AnyView(Text("SwiftUIRoutes: No destination registered for type \(id))"))
            }
            return builder(value)
        case let .url(path, params):
            guard let builder = paths[path] else {
                return AnyView(Text("SwiftUIRoutes: No destination registered for path \(path)"))
            }
            return builder(params)
        }
    }
}

public extension View {
    func routesDestination(registry: RouteRegistry) -> some View {
        navigationDestination(for: Route.self) { route in
            registry.view(route: route)
        }
    }
}
