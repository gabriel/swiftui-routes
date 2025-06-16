import SwiftUI
import SwiftUIRoutes

@MainActor
public func register(routes: Routes) {
    routes.register(type: Value.self, view)
    routes.register(path: "/package-b/value", view)
}

@ViewBuilder
func view(_ value: Value) -> some View {
    VStack {
        value.image
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .navigationTitle("PackageB")
}

@ViewBuilder
func view(_ url: RouteURL) -> some View {
    view(Value(image: Image(systemName: url.params["systemName"] ?? "")))
}

public struct Value: Hashable {
    public init(image: Image) {
        id = UUID()
        self.image = image
    }

    public init(systemImage: String) {
        id = UUID()
        image = Image(systemName: systemImage)
    }

    let id: UUID
    let image: Image

    public static func == (lhs: Value, rhs: Value) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
