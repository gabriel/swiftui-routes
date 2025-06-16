import SwiftUI

@ViewBuilder
func textView(_ text: PackageAText) -> some View {
    VStack {
        Text(text.text)
    }
    .navigationTitle("PackageA Text")
}

@ViewBuilder
func imageView(_ image: PackageAImage) -> some View {
    VStack {
        image.image
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .navigationTitle("PackageA Image")
}
