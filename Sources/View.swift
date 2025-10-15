import SwiftUI

public extension View {
    func stack(_ routable: Routable, style: RouteButtonType = .button(.plain), completion: (() -> Void)? = nil) -> some View {
        modifier(RouteModifier(routable: routable, action: .stack, style: style, completion: completion))
    }

    func sheet(_ routable: Routable, style: RouteButtonType = .button(.plain), completion: (() -> Void)? = nil) -> some View {
        modifier(RouteModifier(routable: routable, action: .sheet, style: style, completion: completion))
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

enum RouteAction {
    case stack
    case sheet
}

private struct RouteModifier: ViewModifier {
    @Environment(\.routePath) var routePath
    @Environment(\.routeSheet) var routeSheet

    let routable: Routable
    let action: RouteAction
    let style: RouteButtonType
    var completion: (() -> Void)? = nil

    func internalAction() {
        switch action {
        case .stack:
            routePath.push(routable)
        case .sheet:
            routeSheet.wrappedValue = routable
        }
    }

    func body(content: Content) -> some View {
        // Copied
        switch style {
        case let .button(style):
            switch style {
            case .plain:
                Button {
                    internalAction()
                    completion?()
                } label: {
                    content
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            case .default:
                Button {
                    internalAction()
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
                    internalAction()
                    completion?()
                }
                .accessibilityAddTraits(.isButton)
        }
    }
}
