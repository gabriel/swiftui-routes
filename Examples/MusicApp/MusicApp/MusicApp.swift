import SwiftUI
import SwiftUIRoutes

@main
struct MusicApp: App {    
    @State private var path = RoutePath()
    @State private var sheet: Routable?

    init() {}

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $path) {
                AlbumListView()
                    .routesDestination(routes: routes, path: $path)
            }
            .routeSheet(routes: routes, item: $sheet)
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
}

struct AlbumUnavailableView: View {
    let id: String

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundStyle(.orange)
            Text("Album not found")
                .font(.headline)
            Text("We couldn't find an album with id \(id).")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
        }
        .padding(32)
    }
}
