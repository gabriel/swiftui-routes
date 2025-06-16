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

```swift

import PackageA
import PackageB
import Routes
import SwiftUI

public struct ExampleView: View {
    public init(routePath: Binding<RoutePath>) {
        _routePath = routePath
        PackageA.register(registry: registry)
        PackageB.register(registry: registry)
    }

    @Binding var routePath: RoutePath

    private var registry = RouteRegistry()

    public var body: some View {
        NavigationStack(path: $routePath) {
            List {
                Button("PackageA Text") {
                    routePath.append(Route(PackageAText(text: "Hello World!")))
                }
                Button("PackageA Image") {
                    routePath.append(Route(PackageAImage(image: Image(systemName: "heart.fill"))))
                }

                Button("PackageB Text") {
                    routePath.append(Route(PackageBText(text: "Hello World!")))
                }
                Button("PackageB Image") {
                    routePath.append(Route(PackageBImage(image: Image(systemName: "heart.fill"))))
                }
            }
            .navigationTitle("Example")
            .navigationDestination(for: Route.self) { route in
                registry.view(for: route)
            }
        }
    }
}

#Preview {
    @Previewable @State var routePath: RoutePath = []

    ExampleView(routePath: $routePath)
}
```
