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
    @Environment(Routes.self) var routes

    let value: Value

    var body: some View {
        VStack {
            Button("Back") {
                routes.pop()
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
