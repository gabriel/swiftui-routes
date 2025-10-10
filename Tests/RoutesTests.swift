import Foundation
import SwiftUI
@testable import SwiftUIRoutes
import SwiftUISnapshotTesting
import Testing

struct SomeValue: Hashable {
    let text: String
}

@Test @MainActor
func testRouteValue() throws {
    let routes = Routes()
    routes.register(type: SomeValue.self) { value in
        Text(value.text)
            .font(.largeTitle)
            .foregroundColor(.blue)
            .background(.red)
    }

    let value = SomeValue(text: "Test Routes")
    let view = routes.view(value)

    assertRender(view: view, device: .any)
}

@Test @MainActor
func testRouteURL() throws {
    let routes = Routes()
    routes.register(path: "/route-a") { _ in
        Text("Route A")
            .font(.largeTitle)
            .foregroundColor(.blue)
            .background(.red)
    }

    let view = routes.view(path: "/route-a")

    assertRender(view: view, device: .any)
}

@Test @MainActor
func testRouteStack() throws {
    let routes = Routes()
    routes.register(path: "/route-a") { _ in
        Text("Route A")
            .font(.largeTitle)
            .foregroundColor(.blue)
            .background(.red)
    }

    let view = NavigationStack(path: routes.pathBinding) {
        VStack {
            Text("Testing")
                .foregroundColor(.blue)
                .background(.red)
            Button("Go to /route-a") {
                routes.push("/route-a")
            }
            .buttonStyle(.borderedProminent)
        }
    }

    assertSnapshot(view: view, device: .size(300, 300))
}
