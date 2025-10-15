import SwiftUI

public extension View {
    func route(path: String, params: [String: String] = [:], style: RouteStyle = .button(.plain).push(), completion: (() -> Void)? = nil) -> some View {
        modifier(RoutePushPathModifier(path: path, params: params, style: style, completion: completion))
    }

    func route(value: Routable, style: RouteStyle = .button(.plain).push(), completion: (() -> Void)? = nil) -> some View {
        modifier(RoutePushValueModifier(value: value, style: style, completion: completion))
    }
}

public struct RouteStyle {
    private let _button: RouteButtonType
    private let _action: RouteActionType

    public var buttonType: RouteButtonType { _button }
    public var actionType: RouteActionType { _action }

    public func push() -> RouteStyle {
        .init(_button: _button, _action: .push)
    }

    public func button(_ style: RouteButtonStyle = .plain) -> RouteStyle {
        .init(_button: .button(style), _action: _action)
    }

    public func tap() -> RouteStyle {
        .init(_button: .tap, _action: _action)
    }

    public static func button(_ style: RouteButtonStyle = .plain) -> RouteStyle {
        .init(_button: .button(style), _action: .push)
    }

    public static func tap() -> RouteStyle {
        .init(_button: .tap, _action: .push)
    }

    public static func push() -> RouteStyle {
        .init(_button: .button(.plain), _action: .push)
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

public enum RouteActionType {
    case push

}

private struct RoutePushPathModifier: ViewModifier {
    @Environment(\.routePath) var routePath

    let path: String
    let params: [String: String]
    let style: RouteStyle
    var completion: (() -> Void)? = nil

    func internalAction() {
        switch style.actionType {
        case .push:
            routePath.push(path: path, params: params)
        }
    }

    func body(content: Content) -> some View {
        // Copied
        switch style.buttonType {
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

private struct RoutePushValueModifier: ViewModifier {
    @Environment(\.routePath) var routePath

    let value: Routable
    let style: RouteStyle
    var completion: (() -> Void)? = nil

    func internalAction() {
        switch style.actionType {
        case .push:
            routePath.push(value: value)
        }
    }

    func body(content: Content) -> some View {
        // Copied
        switch style.buttonType {
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
