import PackageA
import PackageB
import PackageC
import SwiftUI
import SwiftUIRoutes

public struct ExampleView: View {
    public init(routePath: Binding<RoutePath>) {
        _routePath = routePath
        PackageA.register(registry: registry)
        PackageB.register(registry: registry)
        PackageC.register(registry: registry)
    }

    @Binding var routePath: RoutePath

    private var registry = RouteRegistry()

    public var body: some View {
        NavigationStack(path: $routePath) {
            List {
                Section("Package A") {
                    Button("Text") {
                        routePath.append(Route.byType(PackageAText(text: "Hello World!")))
                    }
                    Button("Image") {
                        routePath.append(Route.byType(PackageAImage(image: Image(systemName: "heart.fill"))))
                    }
                }

                Section("Package B") {
                    Button("Text") {
                        routePath.append(Route.byType(PackageBText(text: "Hi!")))
                    }
                    Button("Image") {
                        routePath.append(Route.byType(PackageBImage(image: Image(systemName: "heart"))))
                    }
                }

                Section("Package C") {
                    Button("Text") {
                        routePath.append(Route.url(path: "/package-c/text", params: ["text": "Howdy!"]))
                    }
                    Button("Image") {
                        routePath.append(Route.url(path: "/package-c/image", params: ["systemName": "heart.circle"]))
                    }
                }
            }
            .navigationTitle("Example")
            .routesDestination(registry: registry)
        }
    }
}

#Preview {
    @Previewable @State var routePath: RoutePath = []

    ExampleView(routePath: $routePath)
}
