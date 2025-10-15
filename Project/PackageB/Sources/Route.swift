import SwiftUI
import SwiftUIRoutes

@MainActor
public func register(routes: Routes) {
    routes.register(type: Value.self) { value in
        MyView(value: value)
    }
    routes.register(path: "/package-b/value") { url in
        MyView(value: Value(systemImage: url.params["systemName"] ?? "heart.fill"))
    }
}

struct MyView: View {
    @Environment(\.routePath) var path

    let value: Value

    var body: some View {
        VStack {
            Button("Back") {
                path.pop()
            }
            .buttonStyle(.bordered)

            value.image
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationTitle("Package B")
    }
}

public struct Value: Routable, Sendable {
    let image: Image

    public var route: Route { "/package-b/value" }

    public init(image: Image) {
        self.image = image
    }

    public init(systemImage: String) {
        image = Image(systemName: systemImage)
    }
    
}
