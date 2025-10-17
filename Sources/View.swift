import SwiftUI

public extension View {
    func push(_ routable: Routable, style: RouteButtonType = .button(.plain), completion: (() -> Void)? = nil) -> some View {
        modifier(RouteModifier(routable: routable, style: style, completion: completion))
    }
}

public enum RouteButtonType {
    case tap
    case button(RouteButtonStyle)
}

public enum RouteButtonStyle {
    case plain
    case `default`
}

private struct RouteModifier: ViewModifier {
    @Environment(\.routePath) var routePath

    let routable: Routable
    let style: RouteButtonType
    var completion: (() -> Void)? = nil

    func body(content: Content) -> some View {
        // Copied
        switch style {
        case let .button(style):
            switch style {
            case .plain:
                Button {
                    routePath.push(routable)
                    completion?()
                } label: {
                    content
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            case .default:
                Button {
                    routePath.push(routable)
                    completion?()
                } label: {
                    content
                        .contentShape(Rectangle())
                }
            }
        case .tap:
            content
                .contentShape(Rectangle())
                .onTapGesture {
                    routePath.push(routable)
                    completion?()
                }
                .accessibilityAddTraits(.isButton)
        }
    }
}
