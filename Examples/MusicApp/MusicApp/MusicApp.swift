import SwiftUI
import SwiftUIRoutes

@main
struct MusicApp: App {
    private let routes: Routes
    @State private var path = RoutePath()
    @State private var sheet: Routable?

    init() {
        let routes = Routes()
        Self.register(routes)
        self.routes = routes
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $path) {
                AlbumListView()
                    .routesDestination(routes: routes, path: $path)
                    .routesSheet(routes: routes, item: $sheet, path: $path)
            }
            .onOpenURL(perform: handleDeepLink(_:))
        }
    }

    private func handleDeepLink(_ url: URL) {
        let route = Route(url: url)

        if route.param("presentation") == "sheet" {
            sheet = route
            return
        }

        sheet = nil
        path = RoutePath()
        path.push(route)
    }

    private static func register(_ routes: Routes) {
        routes.register(path: "/album/:id") { route in
            if let id = route.param("id"), let album = AlbumStore.album(withID: id) {
                AlbumDetailView(album: album)
            } else {
                AlbumUnavailableView(missingID: route.param("id") ?? route.path)
            }
        }

        routes.register(type: Album.self) { album in
            AlbumDetailView(album: album)
        }
    }
}

private struct AlbumUnavailableView: View {
    let missingID: String

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundStyle(.orange)
            Text("Album not found")
                .font(.headline)
            Text("We couldn't find an album with id \(missingID).")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
        }
        .padding(32)
    }
}
