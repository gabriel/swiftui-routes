import PackageA
import PackageB
import SwiftUI
import SwiftUIRoutes

public struct ExampleView: View {
    @State private var routes = Routes()

    public init() {
        PackageA.register(routes: routes)
        PackageB.register(routes: routes)
    }

    public var body: some View {
        NavigationStack(path: routes.path) {
            List {
                Button("Package A (Type)") {
                    routes.push(value: PackageA.Value(text: "Hello World!"))
                }

                Button("Package A (URL)") {
                    routes.push(path: "/package-a/value", params: ["text": "Hello!"])
                }

                Button("Package B (Type)") {
                    routes.push(value: PackageB.Value(systemImage: "heart.fill"))
                }

                Button("Package B (URL)") {
                    routes.push(path: "/package-b/value", params: ["systemName": "heart"])
                }
            }
            .navigationTitle("Example")
            .routesDestination(routes)
        }
    }
}

#Preview {
    ExampleView()
}
