# SwiftUI Routes

SwiftUI Routes centralizes navigation destinations so you can describe navigation by path strings or strongly typed values.

## Register

Start by creating a `Routes` instance and registering destinations. Registrations accept either a resource path (string) or a `Routable` value. Paths can be parameterized to include params (like `id`).

```swift
let routes = Routes()

routes.register(path: "/album/:id") { route in
    AlbumView(id: route.param("id") ?? "unknown")
}

routes.register(type: Album.self) { album in
    AlbumDetailView(album: album)
}
```

- Path registrations use URL-style patterns. The closure receives a `Route` so you can pull out parameters or query items with `route.param(_:)` or `route.params`.
- Type registrations work with any `Routable`. Conforming types define how to turn a value into the resource path that should be presented.

```swift
struct Album: Routable {
    var id: String

    var route: Route { Route("/album/\(id)") }
}
```

## Lookup

Use `Routes.view(_:)` to render a destination directly from a registered path or type.

```swift
struct LookupExample: View {
    private let routes = Routes()

    init() {
        register(routes: routes)
    }

    var body: some View {
        VStack(spacing: 16) {
            routes.view("/album/123")
            routes.view(Album(id: "featured"))
        }
    }
}
```

## NavigationStack

Attach your routes to a `NavigationStack` by keeping a `RoutePath` binding. The modifier installs every registered destination and exposes the binding through `EnvironmentValues.routePath`.

```swift
struct AppScene: View {
    private let routes = Routes()
    @State private var path = RoutePath()

    init() {
        register(routes: routes)
    }

    var body: some View {
        NavigationStack(path: $path) {
            HomeView()
                .routesDestination(routes: routes, path: $path)
        }
    }    
}

// Expose routes registration in your package (optional)
public func register(routes: Routes) {
    routes.register(path: "/album/:id") { route in
        AlbumView(id: route.param("id") ?? "unknown")
    }

    routes.register(type: Album.self) { album in
        AlbumDetailView(album: album)
    }
}
```

Views inside the stack can push routes directly or use the provided view modifiers.

```swift
struct HomeView: View {
    @Environment(\.routePath) private var path

    var body: some View {
        VStack(spacing: 24) {
            Button("Album (123)") {
                path.push("/album/123")
            }

            Button("Featured Album") {
                path.push(Album(id: "featured"))
            }

            Text("Tap to open Latest")
                .push(Album(id: "123"), style: .tap)
        }
    }
}
```

The `push(_:style:)` modifier wraps any view in a navigation trigger while still using the same registrations.

## Sheets

Reuse the same routes for modal sheets by keeping a `Routable?` binding and attaching `routesSheet`.

```swift
struct ContentView: View {
    private let routes = Routes()
    @State private var path = RoutePath()
    @State private var sheet: Routable?

    init() {
        register(routes: routes)
    }

    var body: some View {
        NavigationStack(path: $path) {
            HomeView()
                .routesDestination(routes: routes, path: $path)
                .routesSheet(routes: routes, item: $sheet, path: $path)
        }
    }
}

 func register(routes: Routes) {
    routes.register(path: "/album/:id") { route in
        AlbumView(id: route.param("id") ?? "unknown")
    }

    routes.register(type: Album.self) { album in
        AlbumDetailView(album: album)
    }
}
```

When `routesSheet` is present you can present any registered destination with the same APIs used for stacks.

```swift
struct HomeView: View {
    @Environment(\.routeSheet) private var sheet

    var body: some View {
        VStack(spacing: 24) {
            Button("Preview Album") {
                sheet.wrappedValue = Route("/album/123")
            }

            Text("Show Album")
                .sheet(Album(id: "123"))
        }
    }
}
```

## Requirements

- iOS 17.0+ / macOS 15.0+
- Swift 6.0+

## Installation

### Swift Package Manager

Add the dependency to your `Package.swift`:

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

## Multiple packages

Share a single `Routes` instance across packages without creating cyclical dependencies by letting each package contribute its own registrations. The app owns the `Routes` instance and passes it to package-level helpers that fill in the routes it knows about.

```swift
import PackageA
import PackageB
import SwiftUI
import SwiftUIRoutes

public struct ExampleView: View {
    private let routes = Routes()
    @State private var path = RoutePath()

    public init() {
        PackageA.register(routes: routes)
        PackageB.register(routes: routes)
    }

    public var body: some View {
        NavigationStack(path: $path) {
            List {
                Button("Package A (Type)") {
                    path.push(PackageA.Value(text: "Hello World!"))
                }

                Button("Package A (Path)") {
                    path.push("/package-a/value", params: ["text": "Hello!"])
                }

                Button("Package B (Type)") {
                    path.push(PackageB.Value(systemImage: "heart.fill"))
                }

                Button("Package B (Path)") {
                    path.push("/package-b/value", params: ["systemName": "heart"])
                }
            }
            .routesDestination(routes: routes, path: $path)
            .navigationTitle("Example")
        }
    }
}
```

Each package exposes a simple `register(routes:)` entry point so it never needs to import another package’s views.

```swift
import SwiftUI
import SwiftUIRoutes

public func register(routes: Routes) {
    routes.register(type: Value.self) { value in
        PackageBView(value: value)
    }

    routes.register(path: "/package-b/value") { route in
        PackageBView(value: Value(systemImage: route.params["systemName"] ?? "heart.fill"))
    }
}
```

This keeps navigation declarative and avoids mutual dependencies between packages because the shared `Routes` instance lives in the root target while features register themselves.*** End Patch
