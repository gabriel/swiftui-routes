import Foundation
import SwiftUI
import SwiftUIRoutes
import SwiftUISnapshotTesting
import Testing

@Suite
struct RouteTest {
    @Test
    func testRoute() {
      let route = Route("/test")
      #expect(route.path == "/test")
      #expect(route.params == [:])
    }
    @Test
    func testRouteWithParams() {
        let route = Route(url: URL(string: "/test?param1=value1")!)
        #expect(route.path == "/test")    
        #expect(route.params == ["param1": "value1"])
    }
    
    @Test
    func testRouteWithScheme() {
        let route = Route(url: URL(string: "https://test.com/test?param1=value1")!)
        #expect(route.path == "/test")
        #expect(route.params == ["param1": "value1"])
    }

    @Test
    func testRouteWithNoHost() {
        let route = Route(url: URL(string: "pgm://a/123")!)
        #expect(route.path == "/a/123")
        #expect(route.params == [:])

        let route2 = Route(url: URL(string: "pgm:///a/123")!)
        #expect(route2.path == "/a/123")
        #expect(route2.params == [:])
    }
}