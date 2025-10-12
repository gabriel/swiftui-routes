import SwiftUI

public extension View {
    func route(path: String, params: [String: String] = [:], style: RouteStyle = .button().push(), completion: (() -> Void)? = nil) -> some View {
        modifier(RoutePushPathModifier(path: path, params: params, style: style, completion: completion))
    }

    func route(value: Routable, style: RouteStyle = .button().push(), completion: (() -> Void)? = nil) -> some View {
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

    public func button() -> RouteStyle {
        .init(_button: .button, _action: _action)
    }

    public func tap() -> RouteStyle {
        .init(_button: .tap, _action: _action)
    }

    public static func button() -> RouteStyle {
        .init(_button: .button, _action: .push)
    }

    public static func tap() -> RouteStyle {
        .init(_button: .tap, _action: .push)
    }

    public static func push() -> RouteStyle {
        .init(_button: .button, _action: .push)
    }
}

public enum RouteButtonType {
    case tap
    case button
}

public enum RouteActionType {
    case push

}

private struct RoutePushPathModifier: ViewModifier {
    @Environment(Routes.self) var routes

    let path: String
    let params: [String: String]
    let style: RouteStyle
    var completion: (() -> Void)? = nil

    func internalAction() {
        switch style.actionType {
        case .push:
            routes.push(path: path, params: params)
        }
    }

    func body(content: Content) -> some View {
        // Copied below
        switch style.buttonType {
        case .button:
            Button {
                internalAction()
                completion?()
            } label: {
                content
                    .contentShape(Rectangle())
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
    @Environment(Routes.self) var routes

    let value: Routable
    let style: RouteStyle
    var completion: (() -> Void)? = nil

    func internalAction() {
        switch style.actionType {
        case .push:
            routes.push(value: value)
        }
    }

    func body(content: Content) -> some View {
        // Copied above
        switch style.buttonType {
        case .button:
            Button {
                internalAction()
                completion?()
            } label: {
                content
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
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
