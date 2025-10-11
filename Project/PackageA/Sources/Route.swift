import SwiftUI
import SwiftUIRoutes

@MainActor
public func register(routes: Routes) {
    routes.register(type: Value.self, view)
    routes.register(path: "/package-a/value", view)
}

public struct Value: Hashable, Sendable {
    let id: UUID
    let text: String

    public init(text: String) {
        id = UUID()
        self.text = text
    }
}

@ViewBuilder
func view(_ value: Value) -> some View {
    VStack {
        Text(value.text)
    }
    .navigationTitle("PackageA")
}

@ViewBuilder
func view(_ resource: RouteResource) -> some View {
    view(Value(text: resource.params["text"] ?? ""))
}
