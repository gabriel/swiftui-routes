import SwiftUI

@MainActor @Observable
public class Routes {
    public var path: RoutePath = []

    var objects: [ObjectIdentifier: (Any) -> AnyView] = [:]
    var paths: [String: (RouteURL) -> AnyView] = [:]

    public init(initialPath: RoutePath = []) {
        path = initialPath
    }

    public func register<T>(type: T.Type, _ build: @escaping (T) -> some View) {
        let id = ObjectIdentifier(type)
        objects[id] = { any in
            guard let t = any as? T else { return AnyView(Text("SwiftUIRoutes: Type mismatch")) }
            return AnyView(build(t).environment(self))
        }
    }

    public func register(path: String, _ build: @escaping (RouteURL) -> some View) {
        paths[path] = { url in
            AnyView(build(url).environment(self))
        }
    }

    public func push(_ route: Route) {
        path.append(route)
    }

    public func push(_ value: some Hashable) {
        let id = ObjectIdentifier(type(of: value))
        push(Route.value(id, value))
    }

    public func push(_ path: String, params: [String: String] = [:]) {
        push(Route.url(path: path, params: params))
    }

    public func pop() {
        path.removeLast()
    }

    public func view(route: Route) -> AnyView {
        switch route {
        case let .value(id, value):
            guard let builder = objects[id] else {
                return AnyView(Text("SwiftUIRoutes: No destination registered for type \(id))"))
            }
            return builder(value)
        case let .url(path, params):
            return view(path: path, params: params)
        }
    }

    public func view(_ value: some Hashable) -> AnyView {
        let id = ObjectIdentifier(type(of: value))
        guard let builder = objects[id] else {
            return AnyView(Text("SwiftUIRoutes: No destination registered for type \(id))"))
        }
        return builder(value)
    }

    public func view(path: String, params: [String: String] = [:]) -> AnyView {
        guard let builder = paths[path] else {
            return AnyView(
                VStack(alignment: .leading) {
                    Text("Oops")
                        .font(.title)
                    Text("No destination registered for path \(path)")
                    Text("# of paths: \(paths.count)")
                    ForEach(paths.keys.sorted(), id: \.self) { p in
                        Text("Path: \(p)")
                    }
                }
                .padding()
            )
        }
        return builder(RouteURL(path: path, params: params))
    }
}

public extension View {
    func routesDestination(_ routes: Routes) -> some View {
        navigationDestination(for: Route.self) { route in
            routes.view(route: route)
        }
        .environment(routes)
    }
}
