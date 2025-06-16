import SwiftUIRoutes

public func register(registry: RouteRegistry) {
  registry.register(PackageAText.self, textView)
  registry.register(PackageAImage.self, imageView)
}
