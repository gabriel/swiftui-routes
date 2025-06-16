import SwiftUI

func textView(text: String) -> some View {
    VStack {
        Text(text)
    }
    .navigationTitle("PackageC")
}

@ViewBuilder
func imageView(systemName: String) -> some View {
    VStack {
        Image(systemName: systemName)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .navigationTitle("PackageC")
}
