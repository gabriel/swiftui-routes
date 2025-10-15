import PackageA
import PackageB
import SwiftUI
import SwiftUIRoutes

public struct ExampleView: View {
    let routes = Routes()
    @State var path = RoutePath()

    public init() {
        PackageA.register(routes: routes)
        PackageB.register(routes: routes)
    }

    public var body: some View {
        NavigationStack(path: $path) {
            List {
                Button("Package A (Type)") {
                    path.push(value: PackageA.Value(text: "Hello World!"))
                }

                Button("Package A (URL)") {
                    path.push(path: "/package-a/value", params: ["text": "Hello!"])
                }

                Button("Package B (Type)") {
                    path.push(value: PackageB.Value(systemImage: "heart.fill"))
                }

                Button("Package B (URL)") {
                    path.push(path: "/package-b/value", params: ["systemName": "heart"])
                }
            }
            .navigationTitle("Example")
            .routesDestination(routes: routes, path: $path)
        }
    }
}

#Preview {
    ExampleView()
}
