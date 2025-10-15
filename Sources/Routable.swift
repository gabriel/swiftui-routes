import Foundation

// Instead of forcing route values to be Hashable, make them conform to a Routable route.
public protocol Routable: Sendable {
    var route: Route { get }
}
