import SwiftUI

public struct LazyVStack<Content: View>: View {

    var alignment: HorizontalAlignment = .center
    var spacing: CGFloat? = nil
    @ViewBuilder let content: Content

    public var body: some View {
        SwiftUI.LazyVStack(alignment: alignment, spacing: spacing) {
            content
        }
    }
}

// MARK: - Previews
struct LazyVStackIfAvailablePreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
        }
        .padding()
        .previewLayout(PreviewLayout.sizeThatFits)
    }

    static var standalone: some View {
        LazyVStack {
            Text("Text 1")
            Text("Text 2")
        }
    }
}
