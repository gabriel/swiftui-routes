import SwiftUI
import SwiftUIRoutes

struct AlbumListView: View {
    @Environment(\.routePath) private var routePath

    private let albums = AlbumStore.library

    @State var sheet: Routable?

    var body: some View {
        List {
            Section("Library") {
                ForEach(albums) { album in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(album.title)
                            .font(.headline)
                        Text(album.artist)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .push(album, style: .tap)
                }
            }

            Section("Quick Actions") {
                Button {
                    if let first = albums.first {
                        routePath.push(first)
                    }
                } label: {
                    Label("Push first album", systemImage: "music.note.list")
                }

                Button {
                    if let second = albums.dropFirst().first {
                        sheet = second
                    }
                } label: {
                    Label("Preview second album", systemImage: "rectangle.portrait.and.arrow.right")
                }

                Button {
                    routePath.pop()
                } label: {
                    Label("Pop last route", systemImage: "arrow.uturn.left")
                }
                .disabled(routePath.wrappedValue.isEmpty)

                if let featured = albums.last {
                    Text("Deep link to \(featured.title)")
                        .font(.subheadline)
                        .foregroundStyle(.blue)
                        .push(Route("/album/\(featured.id)"), style: .tap)
                }
            }
        }
        .navigationTitle("Albums")
        .routeSheet(routes: routes, item: $sheet, stacked: true)
    }
}

#Preview {
    RouteStack(routes: routes) {
        AlbumListView()
    }
}
