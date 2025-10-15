# SwiftUI Routes

SwiftUI Routes wraps `NavigationStack` with a small set of tools that let you register destinations by path or type and drive navigation without forcing your data to conform to `Hashable`. You decide how the routes are declared; views push values or paths and the library turns them into real destinations.

## Core Concepts

- **Routes** – register destinations for URL-like paths or strongly typed values.
- **RoutePath** – the `NavigationStack` path (`[RouteElement]`) you mutate to drive navigation.
- **RouteElement** – values (`.value`) or URLs (`.url`) placed on the path.
- **Route** – helper type available inside path handlers for accessing route parameters.

### Register destinations

```swift
let routes = Routes()

routes.register(path: "/album/:id") { route in
    if let id = route.param("id") {
        AlbumView(id: id)
    }
}

routes.register(type: Album.self) { album in
    // Album conforms to Routable and supplies a stable Route.
    AlbumDetailView(album: album)
}
```

- `path` routes accept URL-style patterns. Parameters are exposed through `Route.param(_:)` and in `route.params`.
- `type` routes take any `Routable` value. Conforming values only need to supply a stable `Route` (no `Hashable` requirement).

### Wire up `NavigationStack`

```swift
struct MyApp: View {
    private let routes = Routes()
    @State private var path = RoutePath()

    init() {
        routes.register(path: "/album/:id") { route in
            AlbumView(id: route.param("id") ?? "unknown")
        }
        routes.register(type: Album.self) { album in
            AlbumDetailView(album: album)
        }
    }

    var body: some View {
        NavigationStack(path: $path) {
            HomeView()
                .routesDestination(routes: routes, path: $path)
        }
    }
}
```

`routesDestination` installs the registered destinations and exports the `RoutePath` binding through the environment (`\.routePath`) so any view in the hierarchy can push or pop.

### Push and pop from views

```swift
struct HomeView: View {
    @Environment(\.routePath) private var path

    var body: some View {
        VStack {
            Button("Album (123)") {
                path.push(path: "/album/123")
            }

            Button("Featured Album") {
                // Album conforms to Routable.
                path.push(value: Album(id: "featured"))
            }
        }
    }
}

struct AlbumView: View {
    @Environment(\.routePath) private var path

    let id: String

    var body: some View {
        Button("Back") { path.pop() }
    }
}
```

Prefer a declarative modifier? Wrap any view in a `route` call:

```swift
Text("Open Album")
    .route(path: "/album/123")

MyAlbumRow(album: album)
    .route(value: album, style: .tap())
```

The modifier can behave like a plain button (`.button()`) or add a tap gesture (`.tap()`), and always pushes by default (`.push()`).

### Present routes in a sheet

Reuse the same registrations with sheets by keeping a `RouteElement?` binding and attaching `routesSheet`. Any `route` modifier can swap to `.sheet()` to present instead of pushing.

```swift
@State private var sheet: RouteElement?

var body: some View {
    NavigationStack(path: $path) {
        HomeView()
            .routesDestination(routes: routes, path: $path)
            .routesSheet(routes: routes, item: $sheet, path: $path)
    }
}

// Somewhere inside HomeView.
Button("Album Sheet") {
    sheet = .url(path: "/album/123")
}

Text("Featured Album")
    .route(value: Album(id: "featured"), style: .button(.default).sheet())
```

### Render registered destinations manually

`Routes` can also build a view for a registered path or value outside of a navigation stack:

```swift
let view = routes.view(path: "/album/999", params: ["preview": "true"])
```

### Working with `Route`

`Route` is passed to every path builder. It normalizes string or URL inputs and exposes utilities for parameters:

```swift
routes.register(path: "/products/:id") { route in
    ProductView(productID: route.param("id") ?? "unknown")
}
```

The `description` of a route includes its path and query items, which makes it handy for logging.

## Requirements

- iOS 17.0+ / macOS 15.0+
- Swift 6.0+

## Installation

### Swift Package Manager

Add the following dependency to your `Package.swift`:

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

## Example: Multiple Packages

Let packages A and B register their own routes without tight coupling:

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
            .routesDestination(routes: routes, path: $path)
            .navigationTitle("Example")
        }
    }
}
```

### Register inside a package

```swift
import SwiftUI
import SwiftUIRoutes

@MainActor
public func register(routes: Routes) {
    routes.register(type: Value.self) { value in
        MyView(value: value)
    }
    routes.register(path: "/package-b/value") { route in
        MyView(value: Value(systemImage: route.params["systemName"] ?? "heart.fill"))
    }
}

struct MyView: View {
    @Environment(\.routePath) var path

    let value: Value

    var body: some View {
        VStack {
            Button("Back") { path.pop() }
                .buttonStyle(.bordered)

            Button("Push") { path.push(path: "/package-a/value") }
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
