import SwiftUI
import Zuper

@ViewBuilder var headerPlaceholder: some View {
    Text("Custom\nheader content")
        .padding(.vertical, .medium)
        .frame(maxWidth: .infinity)
        .background(Color.blueLightActive)
}

@ViewBuilder var contentPlaceholder: some View {
    Color.productLightActive.opacity(0.3)
        .frame(height: 80)
        .overlay(Text("Custom content", color: .inkNormal))
}

@ViewBuilder var intrinsicContentPlaceholder: some View {
    Text("Intrinsic content", color: .inkNormal)
        .padding(.medium)
        .background(Color.productLightActive.opacity(0.3))
}
