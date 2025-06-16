# SwiftUI Routes

Alternative to NavigationPath to allow for more flexibility when using and defining navigation routes.

- Routes based on path + params (URL) are loosely coupled, good for deep linking and complex package dependencies.
- Routes based on types are strongly coupled, good for preventing invalid routes.

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

Here we register routes from package A and package B:

```swift
import PackageA
import PackageB
import SwiftUI
import SwiftUIRoutes

public struct ExampleView: View {
    @StateObject private var routes: Routes

    public init() {
        let routes = Routes()
        PackageA.register(routes: routes)
        PackageB.register(routes: routes)
        _routes = StateObject(wrappedValue: routes)
    }

    public var body: some View {
        NavigationStack(path: $routes.path) {
            List {
                Button("Package A (Type)") {
                    routes.push(PackageA.Value(text: "Hello World!"))
                }

                Button("Package A (URL)") {
                    routes.push("/package-a/value", params: ["text": "Hello!"])
                }

                Button("Package B (Type)") {
                    routes.push(PackageB.Value(systemImage: "heart.fill"))
                }

                Button("Package B (URL)") {
                    routes.push("/package-b/value", params: ["systemName": "heart"])
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
```

### Register (in Package)

```swift
import SwiftUI
import SwiftUIRoutes

public func register(routes: Routes) {
    routes.register(type: Value.self, someView)
    routes.register(path: "/package-a/value", someView)
}

@ViewBuilder
func someView(_ value: Value) -> some View {
    // View for value
}

@ViewBuilder
func someView(_ url: RouteURL) -> some View {
    // View for url
}
```
