import Foundation

// Instead of forcing route values to be Hashable, make them conform to a Routable route.
public protocol Routable {
    var route: RouteResource { get }
}
