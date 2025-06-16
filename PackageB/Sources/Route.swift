import SwiftUI

public struct PackageBText: Hashable {
    let text: String

    public init(text: String) {
        self.text = text
    }
}

public struct PackageBImage: Hashable {
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

    public static func == (lhs: PackageBImage, rhs: PackageBImage) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
