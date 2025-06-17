import Foundation

public struct RouteURL: Sendable, Hashable {
    public let path: String
    public let params: [String: String]

    public init(path: String, params: [String: String] = [:]) {
        self.path = path
        self.params = params
    }
}
