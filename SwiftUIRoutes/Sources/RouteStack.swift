import SwiftUI

public struct RouteStack<Content: View>: View {
    @State private var routes: Routes

    public init(routes: Routes, @ViewBuilder content: () -> Content) {
        _routes = State(initialValue: routes)
        self.content = content()
    }

    let content: Content

    public var body: some View {
        NavigationStack(path: $routes.path) {
            content
                .routesDestination(routes)
        }
        .environment(routes)
    }
}

struct RouteStackExample: View {
    let routes = Routes()

    init() {
        routes.register(path: "/route-a", routeA)
        routes.register(path: "/route-b", routeB)
    }

    @ViewBuilder
    func routeA(url _: RouteURL) -> some View {
        MyView()
    }

    @ViewBuilder
    func routeB(url: RouteURL) -> some View {
        OtherView(params: url.params)
    }

    var body: some View {
        RouteStack(routes: routes) {
            VStack {
                Text("Routes Example")
                    .font(.title)

                Button("Go to /route-a") {
                    routes.push("/route-a")
                }
                .buttonStyle(.borderedProminent)

                Button("Go to /route-b") {
                    routes.push("/route-b", params: ["key1": "value1"])
                }
                .buttonStyle(.bordered)
            }
        }
    }
}

struct MyView: View {
    @Environment(Routes.self) var routes

    var body: some View {
        VStack {
            Text("My View")

            Button("Go to /route-b") {
                routes.push("/route-b", params: ["key2": "value2"])
            }
            .buttonStyle(.bordered)
        }
    }
}

struct OtherView: View {
    @Environment(Routes.self) var routes

    let params: [String: String]

    var body: some View {
        VStack {
            Text("Other View")

            Text("Params: \(params)")

            Button("Go to /route-a") {
                routes.push("/route-a")
            }
            .buttonStyle(.bordered)
        }
    }
}

#Preview {
    RouteStackExample()
}
