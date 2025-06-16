import SwiftUIRoutes

public func register(registry: RouteRegistry) {
    registry.register(type: PackageBText.self, textView)
    registry.register(type: PackageBImage.self, imageView)
}
