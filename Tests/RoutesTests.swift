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

            var resource: RouteResource {
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

        let stack = NavigationStack(path: routes.path) {
            VStack { Text("Content") }.routesDestination(routes)
        }

        routes.push(value: value)

        assertSnapshot(view: stack, device: .any)
    }

    @Test
    func testRouteValueClass() throws {
        class SomeClass: Routable {
            var text: String

            init(text: String) {
                self.text = text
            }

            var resource: RouteResource {
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

        let stack = NavigationStack(path: routes.path) {
            VStack { Text("Content") }.routesDestination(routes)
        }

        routes.push(value: value)

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

        let view = NavigationStack(path: routes.path) {
            VStack {
                Text("Testing")
                    .foregroundColor(.blue)
                    .background(.red)
                Button("Go to /route-a") {
                    routes.push(path: "/route-a")
                }
                .buttonStyle(.borderedProminent)
            }
        }

        assertSnapshot(view: view, device: .size(300, 300))
    }
}
