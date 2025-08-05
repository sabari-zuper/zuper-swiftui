import SwiftUI

/// Conctatenates two terms that can be represented as `SwiftUI.Text`
///
/// - Parameters:
///   - left: A content representable as `SwiftUI.Text`
///   - right: A content representable as `SwiftUI.Text`
/// - Returns: A view that is the result of concatenation of text representation of the parameters.
///   if both paramters do not have a text representation, the returning view will produce `EmptyView`, preserving the standard Zuper behavior
@ViewBuilder public func +(
    left: TextRepresentable,
    right: TextRepresentable
) -> some View & TextRepresentable {
    ConcatenatedText(left) + ConcatenatedText(right)
}

struct TextConcatenationPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            formatting
            snapshot
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        Heading("Hanoi ", style: .h1)
            + Icon(sfSymbol: "airplane", size: .xLarge)
            + Heading(" San Pedro de Alcantara", style: .h1)
            + Icon(sfSymbol: "info.circle", size: .large)
            + Icon(sfSymbol: "xmark.circle.fill", size: .large, color: nil, baselineOffset: -1)
            + ZText(" (Delayed)", size: .xLarge, color: .inkNormal)
    }

    static var formatting: some View {
        (
            Icon(content: gridIcon, size: .text(.xLarge))
            + ZText(" Text", size: .xLarge, color: nil)
            + Icon(sfSymbol: "info.circle.fill", size: .large, color: nil, baselineOffset: -1)
            + Icon(sfSymbol: "info.circle.fill", size: .large, color: nil)
            + ZText(
                "<ref>Text</ref> with <strong>formatting</strong>",
                size: .small,
                color: nil,
                accentColor: .orangeNormal
            )
            + Icon(content: Icon.Content.check, size: .small)
        )
        .foregroundColor(.blueDark)
    }

    static var snapshot: some View {
        VStack(alignment: .leading, spacing: .xSmall) {
            concatenatedText("Display Title", style: .display)
            concatenatedText("Display Subtitle", style: .displaySubtitle)
            Separator()
                .padding(.vertical, .small)
            concatenatedText("Title 1", style: .h1)
            concatenatedText("Title 2", style: .h2)
            concatenatedText("Title 3", style: .h3)
            concatenatedText("Title 4", style: .h4)
            concatenatedText("Title 5", style: .h5)
            concatenatedText("Title 6", style: .h6)
        }
    }

    static func concatenatedText(_ label: String, style: Heading.Style) -> some View {
        HStack {
            Heading(label, style: style)
                + Icon(sfSymbol: "airplane", size: .custom(style.size), color: .inkNormal)
                + Heading(label, style: style)
                + ZText(" and Text", color: nil)
        }
        .foregroundColor(.blueDark)
    }
}

struct TextConcatenationPreviewsDynamicTypePreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standaloneLarge
        }
        .previewLayout(.sizeThatFits)
    }

    @ViewBuilder static var standaloneLarge: some View {
        TextConcatenationPreviews.standalone
            .environment(\.sizeCategory, .accessibilityExtraLarge)
            .previewDisplayName("Dynamic type — extra large")
            .previewLayout(.sizeThatFits)
    }
}
