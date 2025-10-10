import SwiftUI

struct NavigationStackExample: View {
    let routes = Routes()

    struct RouteA { }

    struct RouteB {
        let params: [String: String]
    }

    init() {
        routes.register(path: "/route/a") { _ in
            AView()
        }
        routes.register(path: "/route/b") { url in
            BView(params: url.params)
        }

        routes.register(type: RouteA.self) { value in
            AView()
        }
        routes.register(type: RouteB.self) { value in
            BView(params: value.params)
        }
    }

    var body: some View {
        NavigationStack(path: routes.path) {
            VStack {
                Text("Routes Example")
                    .font(.title)

                Button("Go to /route/a") {
                    routes.push(path: "/route/a")
                }
                .buttonStyle(.borderedProminent)

                Button("Go to /route/a (value)") {
                    routes.push(value: RouteA())
                }
                .buttonStyle(.bordered)

                Button("Go to /route/b") {
                    routes.push(path: "/route/b", params: ["key1": "value1"])
                }
                .buttonStyle(.borderedProminent)

                Button("Go to /route/b (value)") {
                    routes.push(value: RouteB(params: ["key1": "value1"]))
                }
                .buttonStyle(.bordered)
            }
            .routesDestination(routes)
        }
    }
}

struct AView: View {
    @Environment(Routes.self) var routes

    var body: some View {
        VStack {
            Text("View A")

            Button("Go to /route/b") {
                routes.push(path: "/route/b", params: ["key2": "value2"])
            }
            .buttonStyle(.bordered)
        }
    }
}

struct BView: View {
    @Environment(Routes.self) var routes

    let params: [String: String]

    var body: some View {
        VStack {
            Text("View B")

            Text(verbatim: "Params: \(params)")

            Button("Go to /route/a") {
                routes.push(path: "/route/a")
            }
            .buttonStyle(.bordered)
        }
    }
}

#Preview {
    NavigationStackExample()
}
