import SwiftUI
import SwiftUIRoutes

public func register(registry: RouteRegistry) {
    registry.register(path: "/package-c/text", textView)
    registry.register(path: "/package-c/image", imageView)
}

@ViewBuilder
func textView(params: RouteParams) -> some View {
    textView(text: params["text"] ?? "")
}

func imageView(params: RouteParams) -> some View {
    imageView(systemName: params["systemName"] ?? "")
}
