import SwiftUI

@MainActor
var previewRoutes: Routes {
    let routes = Routes()
    register(routes: routes)
    return routes
}

@MainActor
private func register(routes: Routes) {
    routes.register(path: "/example/:id") { route in
        Text("Example \(route)")
    }
}
