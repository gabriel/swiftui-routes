import Foundation

public protocol Routable: Sendable {
    var route: Route { get }
}

extension String: Routable {
    public var route: Route { .init(self) }
}

extension URL: Routable {
    public var route: Route { .init(url: self) }
}
