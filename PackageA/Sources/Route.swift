import SwiftUI

public struct PackageAText: Hashable, Sendable {
    let id: UUID
    let text: String

    public init(text: String) {
        id = UUID()
        self.text = text
    }
}

public struct PackageAImage: Hashable, Sendable {
    public init(image: Image) {
        id = UUID()
        self.image = image
    }

    public init(systemImage: String) {
        id = UUID()
        image = Image(systemName: systemImage)
    }

    let id: UUID
    let image: Image

    public static func == (lhs: PackageAImage, rhs: PackageAImage) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
