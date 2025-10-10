import Foundation

extension URL {
    private static let routesQueryAllowed: CharacterSet = {
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "&=?")
        return allowed
    }()

    static func routes(path: String, params: [String: String]) -> URL? {
        guard !params.isEmpty else {
            return URL(string: path)
        }

        var urlString = path
        let additionalCapacity = params.reduce(0) { result, element in
            result + element.key.utf8.count + element.value.utf8.count + 2
        }
        urlString.reserveCapacity(urlString.utf8.count + additionalCapacity)

        var separator: Character = "?"
        for (key, value) in params {
            let encodedKey = key.addingPercentEncoding(withAllowedCharacters: routesQueryAllowed) ?? key
            let encodedValue = value.addingPercentEncoding(withAllowedCharacters: routesQueryAllowed) ?? value

            urlString.append(separator)
            urlString.append(encodedKey)
            urlString.append("=")
            urlString.append(encodedValue)

            separator = "&"
        }

        return URL(string: urlString)
    }

    var normalizedPath: String {
        // TODO: Handle if host is the path
        path.isEmpty ? "/" : path
    }

    var params: [String: String] {
        guard let query = query, !query.isEmpty else { return [:] }

        var result: [String: String] = [:]
        var pairCount = 1
        for character in query where character == "&" {
            pairCount += 1
        }
        result.reserveCapacity(pairCount)

        var currentIndex = query.startIndex
        while currentIndex < query.endIndex {
            let nextSeparator = query[currentIndex...].firstIndex(of: "&") ?? query.endIndex
            let pair = query[currentIndex..<nextSeparator]

            let equalIndex = pair.firstIndex(of: "=")
            let key: String
            let value: String

            if let equalIndex {
                let keySubstring = pair[..<equalIndex]
                let valueSubstring = pair[pair.index(after: equalIndex)...]
                key = String(keySubstring).removingPercentEncoding ?? String(keySubstring)
                value = String(valueSubstring).removingPercentEncoding ?? String(valueSubstring)
            } else {
                key = String(pair).removingPercentEncoding ?? String(pair)
                value = ""
            }

            result[key] = value

            if nextSeparator == query.endIndex {
                break
            }

            currentIndex = query.index(after: nextSeparator)
        }

        return result
    }
}
