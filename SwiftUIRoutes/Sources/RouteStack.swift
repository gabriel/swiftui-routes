import SwiftUI

public struct RouteStack<Content: View>: View {
    @StateObject var routes: Routes

    public init(routes: Routes, @ViewBuilder content: () -> Content) {
        _routes = StateObject(wrappedValue: routes)
        self.content = content()
    }

    let content: Content

    public var body: some View {
        NavigationStack(path: $routes.path) {
            content
                .routesDestination(routes)
                .environmentObject(routes)
        }
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
        Text("Route A")
        Button("Go to /route-b") {
            routes.push("/route-b")
        }
    }

    @ViewBuilder
    func routeB(url _: RouteURL) -> some View {
        Text("Route B")
        Button("Go to /route-a") {
            routes.push("/route-a")
        }
    }

    var body: some View {
        RouteStack(routes: routes) {
            Text("Hello, World!")
            Button("Go to /route-a") {
                routes.push("/route-a", params: ["key1": "value"])
            }
        }
    }
}

#Preview {
    RouteStackExample()
}
