import Foundation

public struct Route: Sendable, Hashable, ExpressibleByStringLiteral {
    public let path: String
    public let params: [String: String]

    public init(path: String, params: [String: String] = [:]) {
        self.path = path
        self.params = params
    }

    public init(stringLiteral value: StringLiteralType) {
        self.init(string: value)
    }

    public init(url: URL) {
        self.init(path: url.normalizedPath, params: url.params)
    }

    public init(string: String) {
        if let url = URL(string: string) {
            self.init(url: url)
        } else {
            self.init(path: string)
        }
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

extension Route: CustomStringConvertible {
    public var description: String {
        guard !params.isEmpty else {
            return path
        }

        var additionalCapacity = 0
        for (key, value) in params {
            guard let first = key.first, first != ":" else { continue }
            additionalCapacity += key.utf8.count + value.utf8.count + 2
        }

        guard additionalCapacity > 0 else {
            return path
        }

        var result = path
        result.reserveCapacity(result.utf8.count + additionalCapacity)

        var separator: Character = "?"
        for (key, value) in params {
            guard let first = key.first, first != ":" else { continue }
            result.append(separator)
            result.append(key)
            result.append("=")
            result.append(value)
            separator = "&"
        }

        return result
    }
}
