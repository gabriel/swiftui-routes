import SwiftUI

@ViewBuilder
func textView(_ text: PackageBText) -> some View {
    VStack {
        Text(text.text)
    }
    .navigationTitle("PackageB")
}

@ViewBuilder
func imageView(_ image: PackageBImage) -> some View {
    VStack {
        image.image
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .navigationTitle("PackageB")
}
