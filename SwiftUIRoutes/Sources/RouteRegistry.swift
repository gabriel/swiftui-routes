import Combine
import SwiftUI

public class RouteRegistry {
    private var builders: [ObjectIdentifier: (Any) -> AnyView] = [:]

    public init() {}

    public func register<T>(_ type: T.Type, _ build: @escaping (T) -> some View) {
        let id = ObjectIdentifier(type)
        builders[id] = { any in
            guard let t = any as? T else { return AnyView(Text("SwiftUIRoutes: Type mismatch")) }
            return AnyView(build(t))
        }
    }

    public func view(for route: Route) -> AnyView {
        let id = route.id
        guard let builder = builders[id] else {
            return AnyView(Text("SwiftUIRoutes: No destination registered for \(type(of: route.value))"))
        }
        return builder(route.value)
    }
}
