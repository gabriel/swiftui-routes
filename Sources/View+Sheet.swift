import SwiftUI

public extension View {
    func routesDestination(routes: Routes, path: Binding<RoutePath>) -> some View {
        navigationDestination(for: Routable.self) { route in
            routes.view(routable: route)
        }
        .environment(\.routePath, path)
    }

    func routesSheet(routes: Routes, item: Binding<Routable?>, path: Binding<RoutePath>? = nil, onDismiss: (() -> Void)? = nil) -> some View {
        modifier(RoutesSheetModifier(routes: routes, item: item, path: path, onDismiss: onDismiss))
    }
}

private struct RoutesSheetModifier: ViewModifier {
    @Environment(\.routePath) private var inheritedPath

    let routes: Routes
    let item: Binding<Routable?>
    let path: Binding<RoutePath>?
    let onDismiss: (() -> Void)?

    func body(content: Content) -> some View {
        let activePath = path ?? inheritedPath

        content
            .sheet(item: item, onDismiss: onDismiss) { route in
                routes.view(routable: route)
                    .environment(\.routePath, activePath)
                    .environment(\.routeSheet, item)
            }
            .environment(\.routeSheet, item)
    }
}
