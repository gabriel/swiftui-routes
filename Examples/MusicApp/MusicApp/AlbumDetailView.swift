import SwiftUI
import SwiftUIRoutes

struct AlbumDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.routePath) private var routePath

    @State var sheet: Routable?

    let album: Album

    private var recommended: [Album] {
        AlbumStore.library.filter { $0 != album }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(album.title)
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .accessibilityAddTraits(.isHeader)

                    Text(album.artist)
                        .font(.title3)
                        .foregroundStyle(.secondary)

                    Text("Released \(album.year)")
                        .font(.subheadline)
                        .foregroundStyle(.tertiary)
                }

                Text(album.description)
                    .font(.body)
                    .fixedSize(horizontal: false, vertical: true)

                if !recommended.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("You might also like")
                            .font(.headline)

                        ForEach(recommended) { candidate in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(candidate.title)
                                        .font(.subheadline)
                                    Text(candidate.artist)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Button("View") {
                                    routePath.push(candidate)
                                }
                                .buttonStyle(.bordered)
                            }
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("\(candidate.title) by \(candidate.artist)")
                        }
                    }
                }

                Button("Close") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(24)
        }
        .navigationTitle(album.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Preview") {
                    sheet = album
                }
            }
        }
        .routeSheet(routes: routes, item: $sheet, stacked: true)
    }
}

#Preview {
    NavigationStack {
        AlbumDetailView(album: AlbumStore.library[0])
    }
}
