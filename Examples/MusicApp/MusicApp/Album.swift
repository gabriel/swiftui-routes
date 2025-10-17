import Foundation
import SwiftUIRoutes

struct Album: Identifiable, Hashable, Routable, Sendable {
    let id: String
    let title: String
    let artist: String
    let year: Int
    let description: String

    var route: Route { Route("/album/\(id)", ["id": id]) }
}

enum AlbumStore {
    static let library: [Album] = [
        Album(
            id: "midnight-blue",
            title: "Midnight Blue",
            artist: "The Skylines",
            year: 2023,
            description: "An atmospheric mix of downtempo beats and analog synths perfect for late night drives."
        ),
        Album(
            id: "sunrise-drive",
            title: "Sunrise Drive",
            artist: "Aurora Fields",
            year: 2021,
            description: "Gorgeous indie pop arrangements with shimmering guitars and layered harmonies."
        ),
        Album(
            id: "golden-hour",
            title: "Golden Hour",
            artist: "Lumen",
            year: 2022,
            description: "A collection of upbeat electronic tracks blending retro drum machines with modern production."
        ),
        Album(
            id: "echoes",
            title: "Echoes",
            artist: "Signal & Noise",
            year: 2020,
            description: "Cinematic post-rock built around sweeping crescendos and intricate guitar textures."
        )
    ]

    static func album(id: String) -> Album? {
        library.first { $0.id == id }
    }
}
