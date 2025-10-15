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
    @State var sheet: Routable?

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
            ScrollView {
                VStack(spacing: 20) {
                    Text("Push (Button)")
                        .font(.title)

                    Button("Push /route/a") {
                        path.push("/route/a")
                    }
                    .buttonStyle(.borderedProminent)

                    Button("Push /route/a (value)") {
                        path.push(RouteA())
                    }
                    .buttonStyle(.bordered)

                    Button("Push /route/b?key1=value1") {
                        path.push(Route("/route/b", ["key1": "value1"]))
                    }
                    .buttonStyle(.borderedProminent)

                    Button("Push /route/b (value)") {
                        path.push(RouteB(message: "Hi!"))
                    }
                    .buttonStyle(.bordered)

                    Divider()

                    Text("Push (Modifier)")
                        .font(.title)

                    Text("Push /route/a (plain)")
                        .push("/route/a")

                    Text("Push /route/a (button)")
                        .push("/route/a", style: .button(.default))

                    Text("Push /route/a (bordered)")
                        .push("/route/a", style: .button(.default))
                        .buttonStyle(.bordered)

                    Text("Push /route/a (tap)")
                        .push("/route/a", style: .tap)

                    Divider()

                    Text("Sheet")
                        .font(.title)

                    Button("Present /route/a") {
                        sheet = "/route/a"
                    }
                    .buttonStyle(.bordered)

                    Text("Present /route/b?key3=value3")
                        .sheet(Route("/route/b", ["key3": "value3"]), style: .button(.default))
                }

            }
            .routesDestination(routes: routes, path: $path)
            .routesSheet(routes: routes, item: $sheet, path: $path)
        }
    }
}

struct AView: View {
    @Environment(\.routePath) var path

    var body: some View {
        VStack {
            Text("View A")

            Button("Go to /route/b?key2=value2") {
                path.push(Route("/route/b", ["key2": "value2"]))
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
                path.push("/route/a")
            }
            .buttonStyle(.bordered)
        }
    }
}

#Preview {
    NavigationStackExample()
}
