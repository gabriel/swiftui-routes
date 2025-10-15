import Foundation
import SwiftUI
@testable import SwiftUIRoutes
import SwiftUISnapshotTesting
import Testing

@MainActor
@Suite(.snapshots(record: .failed))
struct SwiftUIRoutesTests {
    @Test
    func testRouteValue() throws {
        struct SomeValue: Routable {
            let text: String

            var route: Route {
                "/some/value"
            }
        }

        let routes = Routes()
        routes.register(type: SomeValue.self) { value in
            Text(value.text)
                .font(.largeTitle)
                .foregroundColor(.blue)
                .background(.red)
        }

        let value = SomeValue(text: "Test Route Value")
        let view = routes.view(value)

        assertRender(view: view, device: .any)

        var path = RoutePath()
        let pathBinding = Binding(get: { path }, set: { path = $0 })

        let stack = NavigationStack(path: pathBinding) {
            VStack { Text("Content") }.routesDestination(routes: routes, path: pathBinding)
        }

        path.push(value: value)

        assertSnapshot(view: stack, device: .any)
    }

    @Test
    func testRouteValueClass() throws {
        final class SomeClass: Routable, Sendable {
            let text: String

            init(text: String) {
                self.text = text
            }

            var route: Route {
                "/some/class"
            }
        }

        let routes = Routes()
        routes.register(type: AttributedString.self) { value in
            Text(value)
        }
        routes.register(type: SomeClass.self) { value in
            Text(value.text)
                .font(.largeTitle)
                .foregroundColor(.blue)
                .background(.red)
        }

        let value = SomeClass(text: "Test Route Class")
        let view = routes.view(value)

        assertRender(view: view, device: .any)

        let markdownText = """
        **Bold text**, *italic text*, and [a link](https://apple.com).
        """
        let attributedString = try! AttributedString(markdown: markdownText)
        let attributedStringView = routes.view(attributedString)

        assertRender(view: attributedStringView, device: .any)

        var path = RoutePath()
        let pathBinding = Binding(get: { path }, set: { path = $0 })

        let stack = NavigationStack(path: pathBinding) {
            VStack { Text("Content") }.routesDestination(routes: routes, path: pathBinding)
        }

        pathBinding.push(value: value)

        assertSnapshot(view: stack, device: .any)
    }

    @Test
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

    @Test
    func testRouteStack() throws {
        let routes = Routes()
        routes.register(path: "/route-a") { _ in
            Text("Route A")
                .font(.largeTitle)
                .foregroundColor(.blue)
                .background(.red)
        }

        var path = RoutePath()
        let pathBinding = Binding(get: { path }, set: { path = $0 })

        let view = NavigationStack(path: pathBinding) {
            VStack {
                Text("Testing")
                    .foregroundColor(.blue)
                    .background(.red)
                Button("Go to /route-a") {
                    path.push(path: "/route-a")
                }
                .buttonStyle(.borderedProminent)
            }
        }

        assertSnapshot(view: view, device: .size(300, 300))
    }
}

extension AttributedString: Routable {
    public var route: Route { "/attributed-string" }
}
