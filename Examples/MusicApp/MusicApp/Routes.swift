import SwiftUIRoutes

@MainActor
var routes: Routes {
    let routes = Routes()
    
    routes.register(path: "/album/:id") { route in
        if let id = route.param("id"), let album = AlbumStore.album(id: id) {
            AlbumDetailView(album: album)
        } else {
            AlbumUnavailableView(id: route.param("id") ?? route.path)
        }
    }

    routes.register(type: Album.self) { album in
        AlbumDetailView(album: album)
    }

    return routes
}
