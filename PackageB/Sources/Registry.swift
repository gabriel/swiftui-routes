import SwiftUIRoutes

public func register(registry: RouteRegistry) {
  registry.register(PackageBText.self, textView)
  registry.register(PackageBImage.self, imageView)
}
