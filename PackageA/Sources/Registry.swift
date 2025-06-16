import SwiftUIRoutes

public func register(registry: RouteRegistry) {
    registry.register(type: PackageAText.self, textView)
    registry.register(type: PackageAImage.self, imageView)
}
