import Foundation

public struct AnyRoutable: Routable, Hashable, Identifiable {
    public let base: any Routable

    public init(_ routable: any Routable) {
        if let existing = routable as? AnyRoutable {
            self = existing
        } else {
            self.base = routable
        }
    }

    public var route: Route {
        base.route
    }

    public var id: Route {
        route
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(route)
    }

    public static func == (lhs: AnyRoutable, rhs: AnyRoutable) -> Bool {
        lhs.route == rhs.route
    }
}
