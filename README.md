# SwiftUI Routes

Alternative to NavigationPath to allow for more flexibility when using and defining navigation routes.

## Requirements

- iOS 17.0+ / macOS 15.0+
- Swift 6.0+

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/gabriel/swiftui-routes", from: "0.1.1")
]

.testTarget(
    dependencies: [
        .product(name: "SwiftUIRoutes", package: "swiftui-routes"),
    ]
)
```

## Example

Here we register routes from packages.

```swift
import PackageA
import PackageB
import PackageC
import SwiftUIRoutes
import SwiftUI

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
                Button("PackageA") {
                    routePath.append(Route.byType(PackageAValue(text: "Hello World!")))
                }
                
                Button("PackageB") {
                    routePath.append(Route.byType(PackageBValue(systemImage: "heart.fill")))
                }

                Button("PackageC") {
                    routePath.append(Route.url(path: "/package-c/image", params: ["systemName": "heart.fill"]))
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
```

### Register (in Package)

```swift
import SwiftUI
import SwiftUIRoutes

public func register(registry: RouteRegistry) {
    registry.register(type: PackageAValue.self, someView)
    registry.register(path: "/package-a/image", imageView)
}

@ViewBuilder
func someView(_ value: PackageAValue) -> some View {
    // View for value
}

@ViewBuilder
func imageView(params: RouteParams) -> some View {
    // View for url params
}
```
