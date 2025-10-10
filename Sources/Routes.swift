import SwiftUI

@MainActor @Observable
public class Routes {
    private var _path: RoutePath = []

    private var objects: [ObjectIdentifier: (Any) -> AnyView] = [:]
    private var exactPaths: [String: (RouteURL) -> AnyView] = [:]
    private var parameterizedPaths: [ParameterizedPath] = []
    public var path: Binding<RoutePath> {
        Binding(
            get: { self._path },
            set: { self._path = $0 }
        )
    }

    public init(initialPath: RoutePath = []) {
        _path = initialPath
    }

    public func register<T>(type: T.Type, _ build: @escaping (T) -> some View) {
        let id = ObjectIdentifier(type)
        objects[id] = { any in
            guard let t = any as? T else { return AnyView(Text("SwiftUIRoutes: Type mismatch")) }
            return AnyView(build(t).environment(self))
        }
    }

    public func register(path: String, @ViewBuilder _ build: @escaping (RouteURL) -> some View) {
        let builder: (RouteURL) -> AnyView = { url in
            AnyView(build(url).environment(self))
        }
        store(path: path, builder: builder)
    }

    public func register(paths: [String], @ViewBuilder _ build: @escaping (RouteURL) -> some View) {
        for path in paths {
            let builder: (RouteURL) -> AnyView = { url in
                AnyView(build(url).environment(self))
            }
            store(path: path, builder: builder)
        }
    }

    public func push(url: URL) {
        push(path: url.normalizedPath, params: url.params)
    }

    public func push(path: String, params: [String: String] = [:]) {
        _path.append(Route.url(path: path, params: params))
    }

    public func push(_ path: String) {
        push(path: path)
    }

    public func push<T: Any>(value: T) {
        _path.append(Route.value(ObjectIdentifier(T.self), value))
    }

    public func pop() {
        guard !path.isEmpty else { return }
        _path.removeLast()
    }

    @ViewBuilder
    public func view(route: Route) -> some View {
        switch route {
        case let .url(path, params):
            view(path: path, params: params)
        case .value(let type, let value):
            view(value)
        }
    }

    public func view(_ value: Any) -> AnyView {
        let id = ObjectIdentifier(type(of: value))
        guard let builder = objects[id] else {
            return AnyView(Text("SwiftUIRoutes: No destination registered for type \(id))"))
        }
        return builder(value)
    }

    @ViewBuilder
    public func view(path: String, params: [String: String] = [:]) -> some View {
        if let builder = exactPaths[path] {
            builder(RouteURL(path: path, params: params))
        } else {
            if let (matchedBuilder, combinedParams) = matchParameterizedPath(path: path, params: params) {
                matchedBuilder(RouteURL(path: path, params: combinedParams))
            } else {
                let registeredPaths = (Array(exactPaths.keys) + parameterizedPaths.map(\.pattern)).sorted()

                VStack(alignment: .leading) {
                    Text("Oops")
                        .font(.title)
                    Text("No destination registered for path \(path)")
                    Text("# of paths: \(exactPaths.count + parameterizedPaths.count)")
                    ForEach(registeredPaths, id: \.self) { p in
                        Text("Path: \(p)")
                    }
                }
                .padding()
            }
        }
    }

    private struct ParameterizedPath {
        enum Segment {
            case literal(String)
            case parameter(String)
        }

        let pattern: String
        let segments: [Segment]
        let builder: (RouteURL) -> AnyView

        init(pattern: String, builder: @escaping (RouteURL) -> AnyView) {
            self.pattern = pattern
            self.segments = pattern.split(separator: "/", omittingEmptySubsequences: true).map { substring in
                if substring.hasPrefix(":"), substring.count > 1 {
                    return .parameter(String(substring.dropFirst()))
                }
                return .literal(String(substring))
            }
            self.builder = builder
        }

        func match(path: String) -> [String: String]? {
            let parts = path.split(separator: "/", omittingEmptySubsequences: true)
            guard parts.count == segments.count else { return nil }

            var params: [String: String] = [:]

            for (segment, part) in zip(segments, parts) {
                switch segment {
                case .literal(let value):
                    guard value == part else { return nil }
                case .parameter(let name):
                    let stringValue = String(part)
                    params[name] = stringValue
                    params[":\(name)"] = stringValue
                }
            }

            return params
        }
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

private extension Routes {
    func store(path: String, builder: @escaping (RouteURL) -> AnyView) {
        if path.contains(":") {
            parameterizedPaths.append(ParameterizedPath(pattern: path, builder: builder))
        } else {
            exactPaths[path] = builder
        }
    }

    func matchParameterizedPath(path: String, params: [String: String]) -> ((RouteURL) -> AnyView, [String: String])? {
        for candidate in parameterizedPaths {
            guard let matchedParams = candidate.match(path: path) else { continue }
            var combined: [String: String] = matchedParams
            params.forEach { key, value in
                combined[key] = value
            }
            return (candidate.builder, combined)
        }

        return nil
    }
}
