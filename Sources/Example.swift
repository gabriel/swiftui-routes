import SwiftUI

struct Album: Routable {
    let id: String
    let title: String
    let artistID: String
    let releaseYear: Int?

    var route: Route {
        Route("/album/\(id)")
    }
}

struct Artist: Routable {
    let id: String
    let name: String
    let genre: String
    let albumIDs: [String]

    var route: Route {
        Route("/artist/\(id)")
    }
}

private enum SampleData {
    static let albums: [String: Album] = [
        "blue-train": Album(id: "blue-train", title: "Blue Train", artistID: "john-coltrane", releaseYear: 1957),
        "giant-steps": Album(id: "giant-steps", title: "Giant Steps", artistID: "john-coltrane", releaseYear: 1960),
        "a-love-supreme": Album(id: "a-love-supreme", title: "A Love Supreme", artistID: "john-coltrane", releaseYear: 1965),
        "kind-of-blue": Album(id: "kind-of-blue", title: "Kind of Blue", artistID: "miles-davis", releaseYear: 1959),
        "sketches-of-spain": Album(id: "sketches-of-spain", title: "Sketches of Spain", artistID: "miles-davis", releaseYear: 1960)
    ]

    static let artists: [String: Artist] = [
        "john-coltrane": Artist(id: "john-coltrane", name: "John Coltrane", genre: "Jazz", albumIDs: ["blue-train", "giant-steps", "a-love-supreme"]),
        "miles-davis": Artist(id: "miles-davis", name: "Miles Davis", genre: "Jazz", albumIDs: ["kind-of-blue", "sketches-of-spain"])
    ]

    static func album(id: String) -> Album {
        guard !id.isEmpty else {
            return Album(id: "unknown-album", title: "Unknown Album", artistID: "unknown-artist", releaseYear: nil)
        }

        return albums[id] ?? Album(
            id: id,
            title: prettyTitle(from: id),
            artistID: "unknown-artist",
            releaseYear: nil
        )
    }

    static func artist(id: String) -> Artist {
        guard !id.isEmpty else {
            return Artist(id: "unknown-artist", name: "Unknown Artist", genre: "Unknown", albumIDs: [])
        }

        return artists[id] ?? Artist(
            id: id,
            name: prettyTitle(from: id),
            genre: "Unknown",
            albumIDs: []
        )
    }

    static func albums(for artist: Artist) -> [Album] {
        if artist.albumIDs.isEmpty {
            return albums
                .values
                .filter { $0.artistID == artist.id }
                .sorted { $0.title < $1.title }
        }

        return artist.albumIDs.map { album(id: $0) }
    }

    static func relatedAlbums(for album: Album) -> [Album] {
        albums
            .values
            .filter { $0.artistID == album.artistID && $0.id != album.id }
            .sorted { $0.title < $1.title }
    }

    private static func prettyTitle(from id: String) -> String {
        let result = id
            .replacingOccurrences(of: "-", with: " ")
            .replacingOccurrences(of: "_", with: " ")
            .split(separator: " ")
            .map { $0.capitalized }
            .joined(separator: " ")

        return result.isEmpty ? "Untitled" : result
    }
}

struct NavigationStackExample: View {
    let routes: Routes = Routes()
    @State var path = RoutePath()
    @State var sheet: Routable?

    init() {
        routes.register(path: "/album/:id") { route in
            AlbumView(album: SampleData.album(id: route.param("id") ?? "unknown-album"))
        }
        routes.register(path: "/artist/:id") { route in
            ArtistView(artist: SampleData.artist(id: route.param("id") ?? "unknown-artist"))
        }

        routes.register(type: Album.self) { album in
            AlbumView(album: album)
        }
        routes.register(type: Artist.self) { artist in
            ArtistView(artist: artist)
        }
    }

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Push (Button)")
                        .font(.title)

                    Button("Push /album/blue-train") {
                        path.push("/album/blue-train")
                    }
                    .buttonStyle(.borderedProminent)

                    Button("Push Album (value)") {
                        path.push(SampleData.album(id: "kind-of-blue"))
                    }
                    .buttonStyle(.bordered)

                    Button("Push /artist/john-coltrane") {
                        path.push("/artist/john-coltrane")
                    }
                    .buttonStyle(.borderedProminent)

                    Button("Push Artist (value)") {
                        path.push(SampleData.artist(id: "miles-davis"))
                    }
                    .buttonStyle(.bordered)

                    Divider()

                    Text("Push (Modifier)")
                        .font(.title)

                    Text("Push /album/giant-steps (plain)")
                        .push("/album/giant-steps")

                    Text("Push /artist/miles-davis (button)")
                        .push("/artist/miles-davis", style: .button(.default))

                    Text("Push Album (bordered)")
                        .push(SampleData.album(id: "a-love-supreme"), style: .button(.default))
                        .buttonStyle(.bordered)

                    Text("Push Artist (tap)")
                        .push(SampleData.artist(id: "john-coltrane"), style: .tap)

                    Divider()

                    Text("Sheet")
                        .font(.title)

                    Button("Present /artist/john-coltrane") {
                        sheet = "/artist/john-coltrane"
                    }
                    .buttonStyle(.bordered)

                    Text("Present Album (value)")
                        .sheet(SampleData.album(id: "kind-of-blue"), style: .button(.default))
                }
                .padding()
            }
            .routesDestination(routes: routes, path: $path)
            .routesSheet(routes: routes, item: $sheet, path: $path)
        }
    }
}

struct AlbumView: View {
    @Environment(\.routePath) private var path

    let album: Album

    private var artist: Artist {
        SampleData.artist(id: album.artistID)
    }

    private var moreFromArtist: [Album] {
        SampleData.relatedAlbums(for: album)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(album.title)
                .font(.largeTitle)
                .fontWeight(.semibold)

            if let year = album.releaseYear {
                Text("Released \(year)")
                    .foregroundStyle(.secondary)
            }

            Button("View \(artist.name)") {
                path.push(artist)
            }
            .buttonStyle(.borderedProminent)

            if !moreFromArtist.isEmpty {
                Divider()

                Text("More from \(artist.name)")
                    .font(.headline)

                ForEach(moreFromArtist, id: \.id) { related in
                    Button(related.title) {
                        path.push(related)
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
        .padding()
        .navigationTitle(album.title)
    }
}

struct ArtistView: View {
    @Environment(\.routePath) private var path

    let artist: Artist

    private var albums: [Album] {
        SampleData.albums(for: artist)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(artist.name)
                    .font(.largeTitle)
                    .fontWeight(.semibold)

                Text(artist.genre)
                    .foregroundStyle(.secondary)

                Divider()

                Text("Albums")
                    .font(.headline)

                if albums.isEmpty {
                    Text("No albums registered.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(albums, id: \.id) { album in
                        Button(album.title) {
                            path.push(album)
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
            .padding()
        }
        .navigationTitle(artist.name)
    }
}

#Preview {
    NavigationStackExample()
}
