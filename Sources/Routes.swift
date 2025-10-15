import Observation
import SwiftUI

@MainActor
public final class Routes {
    private var objects: [ObjectIdentifier: (Any) -> AnyView] = [:]
    private var exactPaths: [String: (Route) -> AnyView] = [:]
    private var parameterizedPaths: [ParameterizedPath] = []

    public init() {}    

    public func register<T>(type: T.Type, _ build: @escaping (T) -> some View) {
        let id = ObjectIdentifier(type)
        objects[id] = { any in
            guard let t = any as? T else { return AnyView(Text("SwiftUIRoutes: Type mismatch")) }
            return AnyView(build(t))
        }
    }

    public func register(path: String, @ViewBuilder _ build: @escaping (Route) -> some View) {
        let builder: (Route) -> AnyView = { resource in
            AnyView(build(resource))
        }
        store(path: path, builder: builder)
    }

    public func register(paths: [String], @ViewBuilder _ build: @escaping (Route) -> some View) {
        for path in paths {
            let builder: (Route) -> AnyView = { resource in
                AnyView(build(resource))
            }
            store(path: path, builder: builder)
        }
    }

    @ViewBuilder
    public func view(_ routable: Routable) -> some View {
        let resolved = (routable as? AnyRoutable)?.base ?? routable

        if resolved is String || resolved is URL || resolved is Route {
            let route = resolved.route
            view(path: route.path, params: route.params)
        } else {
            view(value: resolved)
        }
    }

    func view(value: Any) -> AnyView {
        let id = ObjectIdentifier(type(of: value))
        guard let builder = objects[id] else {
            return AnyView(Text("SwiftUIRoutes: No destination registered for \(String(describing: type(of: value)))"))
        }
        return builder(value)
    }

    @ViewBuilder
    func view(path: String, params: [String: String] = [:]) -> some View {
        if let builder = exactPaths[path] {
            builder(Route(path, params))
        } else {
            if let (matchedBuilder, combinedParams) = matchParameterizedPath(path: path, params: params) {
                matchedBuilder(Route(path, combinedParams))
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
        let builder: (Route) -> AnyView

        init(pattern: String, builder: @escaping (Route) -> AnyView) {
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


private extension Routes {
    func store(path: String, builder: @escaping (Route) -> AnyView) {
        if path.contains(":") {
            parameterizedPaths.append(ParameterizedPath(pattern: path, builder: builder))
        } else {
            exactPaths[path] = builder
        }
    }

    func matchParameterizedPath(path: String, params: [String: String]) -> ((Route) -> AnyView, [String: String])? {
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
