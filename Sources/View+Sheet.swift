import SwiftUI

public extension View {
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
        let sheetItem = Binding<AnyRoutable?>(
            get: {
                item.wrappedValue.map(AnyRoutable.init)
            },
            set: { newValue in
                item.wrappedValue = newValue?.base
            }
        )

        content
            .sheet(item: sheetItem, onDismiss: onDismiss) { route in
                routes.view(route.base)
                    .environment(\.routePath, activePath)
                    .environment(\.routeSheet, item)
            }
            .environment(\.routeSheet, item)
    }
}
