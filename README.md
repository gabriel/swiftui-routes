# SwiftUI Routes

Alternative to NavigationPath to allow for more flexibility when using and defining navigation routes across packages with complex dependencies.

Routes are based on either URLs (loosely coupled, requires a resource fetch) or Types (strongly coupled, no resource fetch).

Route values don't have to implement Hashable, only Routable.

## URL

URL registered routes are loosely coupled, good for deep linking and complex package dependencies.

```swift
import SwiftUIRoutes

@State var routes = Routes()

func register(routes: Routes) {
    routes.register(path: "/album/:id") { url in
        if let id = url.param("id") {
            AlbumView(id: id) // Will fetch Album data from id
        }
    }
}

// Use the route
routes.push(path: "/album/123")
```

## Types

Type registered routes are strongly coupled, compiled, good for ensuring correct behavior.

```swift
import SwiftUIRoutes

@State var routes = Routes()

func register(routes: Routes) {
    routes.register(type: Album.self) { album in 
        AlbumView(album: album)
    }
}

// Use the route
let album: Album = ... 
routes.push(value: album)
```

## Observable

Routes is an Observable accessible from the Environment (view hierarchy) for any registered views.
You can use the Routes instance to change push and pop routes from the current navigation stack.

```swift
import SwiftUI
import SwiftUIRoutes

struct MyApp: View {
    @State var routes: Routes

    init() {        
        let routes = Routes()        
        routes.register(path: "/album/:id") { url in
            if let id = url.param("id") {
                AlbumView(id: id)
            }
        }
        _routes = State(initialValue: routes)
    }

    var body: some View {
        NavigationStack(path: routes.path) {
            MyAppView()                
                // This configures the routes for navigation stack and adds it to the environment
                .routesDestination(routes)
        }
    }
}

struct MyAppView: View {
    // Routes is accessible via the Environment to push
    @Environment(Routes.self) var routes

    var body: some View {
        Button("Album (123)") {
            routes.push(path: "/album/123")
        }
    }
}

struct AlbumView: View {
    // Routes is accessible via the Environment to pop
    @Environment(Routes.self) var routes

    var body: some View {
        Button("Go back") {
            routes.pop()
        }
    }
}
```

## Requirements

- iOS 17.0+ / macOS 15.0+
- Swift 6.0+

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/gabriel/swiftui-routes", from: "0.2.1")
]

.target(
    dependencies: [
        .product(name: "SwiftUIRoutes", package: "swiftui-routes"),
    ]
)
```

## Example (Multiple Packages)

Here we register routes from package A and package B. We use url based routing for loose coupling.
This can be helpful for avoiding cyclical dependencies when two different packages need to route to each other.

```swift
import PackageA
import PackageB
import SwiftUI
import SwiftUIRoutes

public struct ExampleView: View {
    @State private var routes: Routes

    public init() {
        let routes = Routes()
        PackageA.register(routes: routes)
        PackageB.register(routes: routes)
        _routes = State(initialValue: routes)
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
            .routesDestination(routes)
            .navigationTitle("Example")
        }
    }
}

#Preview {
    ExampleView()

```

### Register (in Package)

```swift
import SwiftUI
import SwiftUIRoutes

@MainActor
public func register(routes: Routes) {
    routes.register(type: Value.self) { value in
        MyView(value: value)
    }
    routes.register(path: "/package-b/value") { url in
        MyView(value: Value(systemImage: url.params["systemName"] ?? "heart.fill"))
    }
}

struct MyView: View {
    @Environment(Routes.self) var routes

    let value: Value

    var body: some View {
        VStack {
            Button("Back") {
                routes.pop()
            }
            .buttonStyle(.bordered)

            Button("Push") {
                routes.push(path: "/package-a/value")
            }
            .buttonStyle(.bordered)

            value.image
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationTitle("Package B")
    }
}

```
