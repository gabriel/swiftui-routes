import SwiftUI

public extension View {
    func routeSheet(routes: Routes, item: Binding<Routable?>, stacked: Bool = false, onDismiss: (() -> Void)? = nil) -> some View {
        modifier(RouteSheetModifier(routes: routes, item: item, stacked: stacked, onDismiss: onDismiss))
    }
}

private struct RouteSheetModifier: ViewModifier {
    let routes: Routes
    let item: Binding<Routable?>
    let stacked: Bool
    let onDismiss: (() -> Void)?

    func body(content: Content) -> some View {
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
                if stacked {
                    RouteStack(routes: routes) {
                        routes.view(route.base)
                    }
                } else {
                    routes.view(route.base)
                }
            }
    }
}
