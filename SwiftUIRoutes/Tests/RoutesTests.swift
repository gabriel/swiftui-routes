import Foundation
import SwiftUI
@testable import SwiftUIRoutes
import SwiftUISnapshotTesting
import Testing

struct TestRoute: Hashable {
    let value: String
}

@Test @MainActor
func testRegistry() throws {
    let registry = RouteRegistry()
    registry.register(type: TestRoute.self) { route in
        Text(route.value)
            .font(.largeTitle)
            .foregroundColor(.blue)
            .background(.red)
    }

    let route = TestRoute(value: "Test Registry")
    let view = registry.view(route: Route.byType(route))

    assertRender(view: view, device: .any)
}
