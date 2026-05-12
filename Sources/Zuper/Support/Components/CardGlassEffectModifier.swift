import SwiftUI

/// Glass style options for the card glass effect.
/// This enum provides a stable API that works across all iOS versions.
public enum CardGlassStyle {
    /// Standard glass appearance.
    case regular
    /// More transparent glass appearance.
    case clear
}

/// Applies the iOS 26 Liquid Glass effect to Card-style views.
/// On iOS versions below 26, the view is returned unchanged.
public struct CardGlassEffectModifier: ViewModifier {

    let style: CardGlassStyle
    let cornerRadius: CGFloat
    let tint: Color?

    public init(
        style: CardGlassStyle = .regular,
        cornerRadius: CGFloat = BorderRadius.iOS26,
        tint: Color? = nil
    ) {
        self.style = style
        self.cornerRadius = cornerRadius
        self.tint = tint
    }

    public func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
                .background(.clear)
                .glassEffect(glassValue, in: RoundedRectangle(cornerRadius: cornerRadius))
        } else {
            content
        }
    }

    @available(iOS 26.0, *)
    private var glassValue: Glass {
        let base: Glass
        switch style {
        case .regular:
            base = .regular
        case .clear:
            base = .clear
        }
        return tint.map { base.tint($0) } ?? base
    }
}

public extension View {

    /// Applies the iOS 26 Liquid Glass effect to the view with Card-style appearance.
    ///
    /// On iOS 26+, this modifier renders a Liquid Glass material behind the view
    /// using a rounded rectangle shape. On earlier iOS versions, the view is unchanged.
    ///
    /// - Parameters:
    ///   - style: The glass style to apply. Defaults to `.regular`.
    ///   - cornerRadius: The corner radius for the glass shape. Defaults to `BorderRadius.iOS26`.
    ///   - tint: Optional tint color applied to the glass material. Useful to keep content
    ///     legible on light backdrops (e.g. `Color.black.opacity(0.4)`).
    /// - Returns: A view with the Liquid Glass effect applied on iOS 26+, or unchanged on earlier versions.
    ///
    /// Example usage:
    /// ```swift
    /// Card {
    ///     Text("Glass Card Content")
    /// }
    /// .cardGlassEffect()
    /// ```
    func cardGlassEffect(
        _ style: CardGlassStyle = .regular,
        cornerRadius: CGFloat = BorderRadius.iOS26,
        tint: Color? = nil
    ) -> some View {
        modifier(
            CardGlassEffectModifier(
                style: style,
                cornerRadius: cornerRadius,
                tint: tint
            )
        )
    }
}

// MARK: - Previews
struct CardGlassEffectModifierPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            regularGlass
            clearGlass
            customCornerRadius
        }
        .padding(.medium)
        .background(Color.screen)
        .previewLayout(.sizeThatFits)
    }

    static var regularGlass: some View {
        VStack {
            Text("Regular Glass Card")
                .font(.headline)
            Text("With default settings")
        }
        .padding(.medium)
        .cardGlassEffect()
        .previewDisplayName("Regular Glass")
    }

    static var clearGlass: some View {
        VStack {
            Text("Clear Glass Card")
                .font(.headline)
            Text("More transparent")
        }
        .padding(.medium)
        .cardGlassEffect(.clear)
        .previewDisplayName("Clear Glass")
    }

    static var customCornerRadius: some View {
        VStack {
            Text("Custom Radius Glass")
                .font(.headline)
            Text("With BorderRadius.large")
        }
        .padding(.medium)
        .cardGlassEffect(cornerRadius: BorderRadius.large)
        .previewDisplayName("Custom Corner Radius")
    }
}
