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
    case bordered
    case borderedProminent
    case glass // Fallback to bordered for older versions
    case glassProminent // Fallback to borderedProminent for older versions
}

private struct RouteButtonStyleModifier: ViewModifier {
    let style: RouteButtonStyle

    func body(content: Content) -> some View {
        switch style {
        case .plain:
            content
                .buttonStyle(.plain)
        case .default:
            content
        case .bordered:
            content
                .buttonStyle(.bordered)
        case .borderedProminent:
            content
                .buttonStyle(.borderedProminent)
        case .glass:
            if #available(iOS 26.0, *) {
                content
                    .buttonStyle(.glass)
            } else {
                content
                    .buttonStyle(.bordered)
            }
        case .glassProminent:
            if #available(iOS 26.0, *) {
                content
                    .buttonStyle(.glassProminent)
            } else {
                content
                    .buttonStyle(.borderedProminent)
            }
        }
    }
}

public extension View {
    func routeButtonStyle(_ style: RouteButtonStyle) -> some View {
        modifier(RouteButtonStyleModifier(style: style))
    }
}

private struct RouteModifier: ViewModifier {
    @Environment(\.routePath) var routePath

    let routable: Routable
    let style: RouteButtonType
    var completion: (() -> Void)? = nil

    func body(content: Content) -> some View {
        switch style {
        case let .button(style):
            Button {
                routePath.push(routable)
                completion?()
            } label: {
                content
                    .contentShape(Rectangle())
            }
            .routeButtonStyle(style)

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
