import SwiftUI

struct RouteA: Routable {
    var route: Route { "/route/a" }
}

struct RouteB: Routable {
    let message: String

    var route: Route {
        Route(string: "/route/b?message=\(self.message)")
    }
}

struct NavigationStackExample: View {
    let routes: Routes = Routes()
    @State var path = RoutePath()

    init() {
        routes.register(path: "/route/a") { _ in
            AView()
        }
        routes.register(path: "/route/b") { url in
            BView(message: String(describing: url.params))
        }

        routes.register(type: RouteA.self) { value in
            AView()
        }
        routes.register(type: RouteB.self) { value in
            BView(message: String(value.message))
        }
    }

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Text("Routes Example")
                    .font(.title)

                Button("Go to /route/a") {
                    path.push(path: "/route/a")
                }
                .buttonStyle(.borderedProminent)

                Button("Go to /route/a (value)") {
                    path.push(value: RouteA())
                }
                .buttonStyle(.bordered)

                Button("Go to /route/b") {
                    path.push(path: "/route/b", params: ["key1": "value1"])
                }
                .buttonStyle(.borderedProminent)

                Button("Go to /route/b (value)") {
                    path.push(value: RouteB(message: "Hi!"))
                }
                .buttonStyle(.bordered)
            }
            .routesDestination(routes: routes, path: $path)
        }
    }
}

struct AView: View {
    @Environment(\.routePath) var path

    var body: some View {
        VStack {
            Text("View A")

            Button("Go to /route/b") {
                path.push(path: "/route/b", params: ["key2": "value2"])
            }
            .buttonStyle(.bordered)
        }
    }
}

struct BView: View {
    @Environment(\.routePath) var path

    let message: String

    var body: some View {
        VStack {
            Text("View B")

            Text(verbatim: message)

            Button("Go to /route/a") {
                path.push(path: "/route/a")
            }
            .buttonStyle(.bordered)
        }
    }
}

#Preview {
    NavigationStackExample()
}
