import SwiftUI

/// Shows the content hierarchy and improves the reading experience. Also known as Title.
///
/// - Important: Component has fixed vertical size.
public struct Heading: View {

    @Environment(\.sizeCategory) var sizeCategory

    let content: String
    let style: Style
    let color: Color?
    let lineSpacing: CGFloat?
    let alignment: TextAlignment
    let accentColor: UIColor

    public var body: some View {
        if content.isEmpty == false {
            text(sizeCategory: sizeCategory)
                .multilineTextAlignment(alignment)
                .fixedSize(horizontal: false, vertical: true)
                .accessibility(addTraits: .isHeader)
        }
    }

    func text(sizeCategory: ContentSizeCategory) -> SwiftUI.Text {
        ZText(
            content,
            size: style.textSize,  // Use proper TextSize for correct Dynamic Type scaling
            color: color?.textColor,
            weight: style.weight,
            lineSpacing: lineSpacing,
            alignment: alignment,
            accentColor: accentColor,
            isSelectable: false
        )
        .text(sizeCategory: sizeCategory)
    }
}

// MARK: - Inits
public extension Heading {

    /// Creates Zuper Heading component.
    ///
    /// - Parameters:
    ///   - content: String to display. Supports html formatting tags `<strong>`, `<u>`, `<ref>`.
    ///   - style: Heading style.
    ///   - color: Font color. Can be set to `nil` and specified later using `.foregroundColor()` modifier.
    ///   - lineSpacing: Distance in points between the bottom of one line fragment and the top of the next.
    ///   - alignment: Horizontal multi-line alignment.
    ///   - accentColor: Color for `<ref>` formatting tag.
    ///   - linkColor: Color for `<a href>` and `<applink>` formatting tag.
    init(
        _ content: String,
        style: Style,
        color: Color? = .inkDark,
        lineSpacing: CGFloat? = nil,
        alignment: TextAlignment = .leading,
        accentColor: UIColor? = nil
    ) {
        self.content = content
        self.style = style
        self.color = color
        self.lineSpacing = lineSpacing
        self.alignment = alignment
        self.accentColor = accentColor ?? color?.uiValue ?? .inkDark
    }
}

// MARK: - Types
public extension Heading {

    /// Zuper Heading color.
    enum Color: Equatable {
        /// The default Heading color.
        case inkDark
        /// Custom Heading color.
        case custom(UIColor)

        public var value: SwiftUI.Color {
            SwiftUI.Color(uiValue)
        }

        public var uiValue: UIColor {
            switch self {
                case .inkDark:              return .inkDark
                case .custom(let color):    return color
            }
        }

        public var textColor: TextColor? {
            switch self {
                case .inkDark:              return .inkDark
                case .custom(let color):    return .custom(color)
            }
        }
    }

    /// Apple HIG-aligned heading style enum for consistent typography across iOS.
    /// See: https://developer.apple.com/design/human-interface-guidelines/typography
    enum Style {
        // MARK: - Apple HIG Title Styles

        /// 34pt - Navigation bars, main screen titles (bold)
        case largeTitle
        /// 28pt - Section headers (bold)
        case title
        /// 22pt - Subheadings (semibold)
        case title2
        /// 20pt - Tertiary headers (semibold)
        case title3
        /// 17pt - Emphasized text (semibold)
        case headline

        // MARK: - Deprecated Legacy Aliases (backward compatibility)

        @available(*, deprecated, renamed: "largeTitle", message: "Use .largeTitle (34pt) for Apple HIG compliance")
        public static let display = Style.largeTitle

        @available(*, deprecated, renamed: "title2", message: "Use .title2 (22pt) for Apple HIG compliance")
        public static let displaySubtitle = Style.title2

        @available(*, deprecated, renamed: "largeTitle", message: "Use .largeTitle (34pt) for Apple HIG compliance")
        public static let h1 = Style.largeTitle

        @available(*, deprecated, renamed: "title", message: "Use .title (28pt) for Apple HIG compliance")
        public static let h2 = Style.title

        @available(*, deprecated, renamed: "title2", message: "Use .title2 (22pt) for Apple HIG compliance")
        public static let h3 = Style.title2

        @available(*, deprecated, renamed: "title3", message: "Use .title3 (20pt) for Apple HIG compliance")
        public static let h4 = Style.title3

        @available(*, deprecated, renamed: "headline", message: "Use .headline (17pt) for Apple HIG compliance")
        public static let h5 = Style.headline

        @available(*, deprecated, renamed: "headline", message: "Use .headline (17pt) for Apple HIG compliance")
        public static let h6 = Style.headline

        @available(*, deprecated, renamed: "headline", message: "Use .headline (17pt) for Apple HIG compliance")
        public static let title5 = Style.headline

        @available(*, deprecated, renamed: "headline", message: "Use .headline (17pt) for Apple HIG compliance")
        public static let title6 = Style.headline

        // MARK: - Computed Properties

        /// Point size value for the heading style
        public var size: CGFloat {
            switch self {
            case .largeTitle:       return 34
            case .title:            return 28
            case .title2:           return 22
            case .title3:           return 20
            case .headline:         return 17
            }
        }

        /// Returns the corresponding TextSize for proper Dynamic Type scaling
        public var textSize: TextSize {
            switch self {
            case .largeTitle:       return .largeTitle
            case .title:            return .title
            case .title2:           return .title2
            case .title3:           return .title3
            case .headline:         return .headline
            }
        }

        /// Apple text style for Dynamic Type scaling
        public var textStyle: Font.TextStyle {
            switch self {
            case .largeTitle:       return .largeTitle
            case .title:            return .title
            case .title2:
                if #available(iOS 14.0, *) {
                    return .title2
                } else {
                    return .title
                }
            case .title3:
                if #available(iOS 14.0, *) {
                    return .title3
                } else {
                    return .headline
                }
            case .headline:         return .headline
            }
        }

        /// Line height based on Apple HIG recommendations (approximately 1.2x font size)
        public var lineHeight: CGFloat {
            switch self {
            case .largeTitle:       return 41
            case .title:            return 34
            case .title2:           return 28
            case .title3:           return 25
            case .headline:         return 22
            }
        }

        /// Icon size to align with heading
        public var iconSize: CGFloat {
            switch self {
            case .largeTitle:       return 40
            case .title:            return 34
            case .title2:           return 28
            case .title3:           return 25
            case .headline:         return 22
            }
        }

        /// Default weight per Apple HIG
        public var weight: Font.Weight {
            switch self {
            case .largeTitle:       return .bold
            case .title:            return .bold
            case .title2:           return .semibold
            case .title3:           return .semibold
            case .headline:         return .semibold
            }
        }
    }
    }

// MARK: - TextRepresentable
extension Heading: TextRepresentable {

    public func swiftUIText(sizeCategory: ContentSizeCategory) -> SwiftUI.Text? {
        if content.isEmpty { return nil }

        return text(sizeCategory: sizeCategory)
    }
}

// MARK: - Previews
struct HeadingPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            zuper
            standalone
            sizes
            multiline
            concatenated
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        VStack {
            Heading("Heading", style: .largeTitle)
            Heading("", style: .title) // EmptyView
        }
        .previewDisplayName("Heading")
    }

    static var zuper: some View {
        VStack(alignment: .leading, spacing: 20) {
            Heading("Zuper, Field service", style: .largeTitle)
            Heading("Zuper, Field service", style: .title)
            Heading("Zuper, Field service", style: .title2)
            Heading("Zuper, Field service", style: .title3)
            Heading("Zuper, Field service", style: .headline)
        }
        .previewDisplayName("Zuper Heading")
    }

    static var sizes: some View {
        VStack(alignment: .leading, spacing: .xSmall) {
            heading("Large Title", style: .largeTitle)
            heading("Title", style: .title)
            heading("Title 2", style: .title2)
            heading("Title 3", style: .title3)
            heading("Headline", style: .headline)
        }
        .previewDisplayName("Styles")
    }

    static var multiline: some View {
        VStack(alignment: .leading, spacing: .xSmall) {
            heading("<ref><u>Large Title</u></ref> with a very large and <strong>multiline</strong> content", style: .largeTitle)
            heading("<ref><u>Title</u></ref> with a very large and <strong>multiline</strong> content", style: .title)
            heading("<ref><u>Title 2</u></ref> with a very very large and <strong>multiline</strong> content", style: .title2)
            heading("<ref><u>Title 3</u></ref> with a very very very very large and <strong>multiline</strong> content", style: .title3)
            heading("<ref><u>Headline</u></ref> with a very very very very large and <strong>multiline</strong> content", style: .headline, color: .custom(.blueDark))
        }
        .foregroundColor(.inkNormal)
        .previewDisplayName("Multiline")
    }

    static var concatenated: some View {
        Group {
            Heading("<ref><u>Title 3</u></ref> with <strong>multiline</strong>", style: .title3)
            +
            Heading(" <ref><u>Headline</u></ref> with <strong>multiline</strong>", style: .headline, color: .custom(.greenDark), accentColor: .blueDark)
        }
        .foregroundColor(.inkNormal)
        .previewDisplayName("Concatenated")
    }

    static var snapshot: some View {
        sizes
            .padding(.medium)
    }

    @ViewBuilder static func heading(_ content: String, style: Heading.Style, color: Heading.Color? = .inkDark) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: .small) {
            Heading(content, style: style, color: color, accentColor: .blueNormal)
            Spacer()
            Text("\(Int(style.size))/\(Int(style.lineHeight))", color: .inkNormal, weight: .medium)
        }
    }
}
