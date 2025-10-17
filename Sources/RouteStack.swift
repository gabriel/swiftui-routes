import SwiftUI
import SwiftUIRoutes

public struct RouteStack<Content: View>: View {
    @State private var path = RoutePath()
    @State private var sheet: Routable? = nil

    let routes: Routes
    let content: Content

    public init(routes: Routes, content: () -> Content) {
        self.routes = routes
        self.content = content()
    }

    public var body: some View {
        NavigationStack(path: $path) {
            content
                .routesDestination(routes: routes, path: $path)
        }
        .routeSheet(routes: routes, item: $sheet)
    }
}


#Preview {
    RouteStack(routes: previewRoutes) {
        Text("Root View")
    }
}
