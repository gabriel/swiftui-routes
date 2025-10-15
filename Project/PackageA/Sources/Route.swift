import SwiftUI
import SwiftUIRoutes

@MainActor
public func register(routes: Routes) {
    routes.register(type: Value.self) { value in
        Text(String(describing: value))
            .navigationTitle("PackageA")
    }
    routes.register(path: "/package-a/value") { url in
        Text(String(describing: url))
            .navigationTitle("PackageA")
    }
}

public struct Value: Routable, Sendable {
    let text: String

    public var route: Route { "/package-a/value" }

    public init(text: String) {
        self.text = text
    }
}
