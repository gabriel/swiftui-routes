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
  registry.register(TestRoute.self) { route in
    Text(route.value)
  }

  let route = TestRoute(value: "Test")
  let view = registry.view(for: Route(route))

  assertRender(view: view, device: .any)
}
