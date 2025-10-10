import Foundation

public struct RouteURL: Sendable, Hashable {
    public let path: String
    public let params: [String: String]

    public init(path: String, params: [String: String] = [:]) {
        self.path = path
        self.params = params
    }

    public init(url: URL) {
        self.init(path: url.normalizedPath, params: url.params)
    }

    public init?(string: String) {
        guard let url = URL(string: string) else { return nil }
        self.init(url: url)
    }

    public func param(_ key: String) -> String? {
        if let value = params[key] {
            return value
        }

        let normalizedKey = key.hasPrefix(":") ? String(key.dropFirst()) : key
        if normalizedKey.isEmpty {
            return nil
        }

        if let value = params[":\(normalizedKey)"] {
            return value
        }

        for segment in path.split(separator: "/", omittingEmptySubsequences: true) {
            guard let colonIndex = segment.firstIndex(of: ":") else { continue }
            var remainder = segment[colonIndex...].dropFirst()
            if remainder.hasSuffix("?") {
                remainder = remainder.dropLast()
            }

            let parts = remainder.split(separator: "=", maxSplits: 1, omittingEmptySubsequences: false)
            guard let candidate = parts.first, candidate == normalizedKey else { continue }

            if parts.count == 2 {
                return String(parts[1])
            } else {
                return String(candidate)
            }
        }

        return nil
    }
}
