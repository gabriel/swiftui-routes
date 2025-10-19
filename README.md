# SwiftUI Routes

SwiftUI Routes centralizes navigation destinations so you can describe navigation by path strings or strongly typed values.

## Example Project

Explore `Examples/MusicApp` for a complete sample integrating SwiftUI Routes; open `Examples/MusicApp/MusicApp.xcodeproj` in Xcode to run it.

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

## Register

Start by creating a `Routes.swift` file and registering destinations. Registrations accept either a resource path (string) or a `Routable` value. Paths can be parameterized to include params (like `id`).

```swift
import SwiftUIRoutes

@MainActor
var routes: Routes {
    let routes = Routes()
    register(routes: routes)
    return routes
}

@MainActor
private func register(routes: Routes) {
    routes.register(path: "/album/:id") { route in
        if let id = route.param("id") {
            AlbumView(id: id)
        }
    }

    routes.register(type: Album.self) { album in
        AlbumDetailView(album: album)
    }
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
    var body: some View {
        VStack(spacing: 16) {
            routes.view("/album/123")
            routes.view(Album(id: "featured"))
        }
    }
}
```

## NavigationStack

Attach your routes to a `NavigationStack` by keeping a `RoutePath` binding. The modifier installs every registered destination and exposes the binding through `EnvironmentValues.routePath`. Define `routesDestination` on the root view.

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
```

Views inside the stack can push routes directly or use the provided view modifiers.

```swift
struct HomeView: View {
    @Environment(\.routePath) private var path

    var body: some View {
        VStack {
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

Define a sheet binding and use `routeSheet`. If `stacked` is `true`, it will wrap the route view in another NavigationStack in case those views push.

```swift
struct HomeView: View {
    @State private var sheet: Routable?
    
    let album: Album

    var body: some View {
        VStack {
            Button("Open Album") {
                sheet = album
            }
        }
        // If stacked is true will wrap in a new NavigationStack configured with these routes
        .routeSheet(routes: routes, item: $sheet, stacked: true) 
    }
}
```

## Multiple packages

Share a single `Routes` instance across packages without creating cyclical dependencies by letting each package contribute its own registrations. The app owns the `Routes` instance and passes it to package-level helpers that fill in the routes it knows about.

```swift
import PackageA
import PackageB
import SwiftUI
import SwiftUIRoutes

@MainActor
var routes: Routes {
    let routes = Routes()
    PackageA.register(routes: routes)
    PackageB.register(routes: routes)
    return routes
}
```

In PackageC:

```swift
import SwiftUI
import SwiftUIRoutes

public struct ExampleView: View {
    let routes: Routes
    @State private var path = RoutePath()

    public var body: some View {
        NavigationStack(path: $path) {
            List {
                Button("A view in PackageA") {
                    path.push("/a/1", params: ["text": "Hello!"])
                }

                Button("A view in PackageB") {
                    path.push("/b/2", params: ["systemName": "heart"])
                }
            }
            .routesDestination(routes: routes, path: $path)
        }
    }
}
```

Each package exposes a simple `register(routes:)` entry point so it never needs to import another package’s views.

In PackageA:

```swift
import SwiftUI
import SwiftUIRoutes

public func register(routes: Routes) {
    routes.register(path: "/a/:id") { url in
        Text(url.params["text"])
    }
}
```

In PackageB:

```swift
import SwiftUI
import SwiftUIRoutes

public func register(routes: Routes) {
    routes.register(path: "/b/:id") { url in
        Image(systemName: url.params["systemName"] ?? "heart.fill")
    }
}
```

This keeps navigation declarative and avoids mutual dependencies between packages because the shared `Routes` instance lives in the root target while features register themselves.
