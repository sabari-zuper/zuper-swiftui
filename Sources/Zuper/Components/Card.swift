import SwiftUI

public enum CardAction {
    case none
    case buttonLink(_ label: String, action: () -> Void = {})
}

/// Specifies the padding and spacing behavior of Card content.
public enum CardContentLayout {
    /// Content fills all available space with no padding or spacing.
    case fill
    /// Content with `.medium` padding and overridable spacing.
    case `default`(spacing: CGFloat = .medium)
    /// Content with custom padding and spacing.
    case custom(padding: CGFloat, spacing: CGFloat)
}

/// Visual style for the Card appearance.
///
/// iOS 26 introduced cleaner card styles using system fill colors
/// with no borders or shadows - just subtle filled backgrounds.
///
/// ## Migration Guide
///
/// Migrate from `.bordered` to iOS 26 styles:
///
/// | Old Pattern | New Pattern |
/// |-------------|-------------|
/// | `Card(contentLayout: .fill)` | `Card(contentLayout: .fill, style: .grouped)` |
/// | `Card { }` | `Card(style: .filled) { }` |
/// | `Card(showBorder: false)` | `Card(style: .plain)` or `Card(style: .filled)` |
/// | Cards with Tiles/ListChoice | `Card(contentLayout: .fill, style: .grouped)` |
///
/// - Note: Cards with custom `backgroundColor` for selection states can remain as-is.
///
public enum CardStyle {
    /// Legacy style with border.
    ///
    /// - Important: Migrate to `.filled` or `.grouped` for iOS 26 style.
    ///
    /// **Migration examples:**
    /// ```swift
    /// // Before
    /// Card(contentLayout: .fill) { content }
    ///
    /// // After - for cards containing lists/tiles
    /// Card(contentLayout: .fill, style: .grouped) { content }
    ///
    /// // After - for standard cards with padding
    /// Card(contentLayout: .default(), style: .filled) { content }
    /// ```
    @available(*, deprecated, message: "Migrate to .filled or .grouped for iOS 26 style")
    case bordered

    /// iOS 26+ style using `tertiarySystemFill` - subtle filled background, no border.
    /// Best for: Standard cards on plain backgrounds.
    case filled

    /// iOS 26+ style using `secondarySystemGroupedBackground` for grouped list contexts.
    /// Best for: Cards containing Tiles, ListChoice, or in scrollable list views.
    case grouped

    /// Plain style with no background decoration.
    /// Best for: Cards that need complete transparency or custom styling.
    case plain
}

/// Separates content into sections.
///
/// Card is a wrapping component around a custom content.
///
/// ## iOS 26 Style
/// Use `.filled` or `.grouped` style for modern iOS appearance:
/// ```swift
/// Card(style: .filled) {
///     Text("Content")
/// }
/// ```
///
/// - Important: Component expands horizontally unless prevented by `fixedSize` or `idealSize` modifier.
public struct Card<Content: View>: View {

    @Environment(\.idealSize) var idealSize

    let content: Content
    let contentLayout: CardContentLayout
    let contentAlignment: HorizontalAlignment
    let style: CardStyle
    let showBorder: Bool
    let backgroundColor: Color?

    public var body: some View {
        VStack(alignment: contentAlignment, spacing: contentSpacing) {
            content
        }
        .padding(contentPadding)
        .frame(maxWidth: idealSize.horizontal == true ? nil : .infinity, alignment: .leading)
        .background(resolvedBackgroundColor)
        .modifier(CardStyleModifier(style: style, showBorder: showBorder))
        .ignoreScreenLayoutHorizontalPadding()
        // .padding(.horizontal, horizontalInset)
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
        .accessibilityElement(children: .contain)
    }

    /// Horizontal inset based on card style.
    /// iOS 26 styles get 16pt inset, legacy styles stay edge-to-edge.
    private var horizontalInset: CGFloat {
        switch style {
        case .bordered, .plain:
            return 0
        case .filled, .grouped:
            return 20
        }
    }

    // MARK: - Private

    private var resolvedBackgroundColor: Color {
        if let backgroundColor {
            return backgroundColor
        }

        switch style {
        case .bordered:
            return .whiteDarker
        case .filled:
            return .tertiarySystemFill
        case .grouped:
            return .secondarySystemGroupedBackground
        case .plain:
            return .clear
        }
    }

    private var contentPadding: CGFloat {
        switch contentLayout {
        case .fill:
            return 0
        case .default:
            return .medium
        case .custom(let padding, _):
            return padding
        }
    }

    private var contentSpacing: CGFloat {
        switch contentLayout {
        case .fill:
            return 0
        case .default(let spacing):
            return spacing
        case .custom(_, let spacing):
            return spacing
        }
    }
}

// MARK: - Card Style Modifier

private struct CardStyleModifier: ViewModifier {
    let style: CardStyle
    let showBorder: Bool

    /// iOS standard card corner radius
    private let iosCornerRadius: CGFloat = 20

    func body(content: Content) -> some View {
        switch style {
        case .bordered:
            content
                .tileBorder(showBorder ? .iOS : .none)
        case .filled, .grouped:
            content
                .clipShape(RoundedRectangle(cornerRadius: iosCornerRadius, style: .continuous))
        case .plain:
            content
        }
    }
}

// MARK: - Inits (Backward Compatible)
public extension Card {

    // PATTERN 1: Custom padding/spacing (most common)
    init(
        contentLayout: CardContentLayout,
        contentAlignment: HorizontalAlignment = .leading,
        showBorder: Bool = true,
        backgroundColor: Color? = nil,
        style: CardStyle = .bordered,
        @ViewBuilder content: () -> Content
    ) {
        self.contentLayout = contentLayout
        self.contentAlignment = contentAlignment
        self.showBorder = showBorder
        self.backgroundColor = backgroundColor
        self.style = style
        self.content = content()
    }

    // PATTERN 2: Simple default
    init(
        style: CardStyle = .bordered,
        @ViewBuilder content: () -> Content
    ) {
        self.contentLayout = .custom(padding: .small, spacing: .small)
        self.contentAlignment = .leading
        self.showBorder = true
        self.backgroundColor = nil
        self.style = style
        self.content = content()
    }

    // PATTERN 3: Fill layout / Border focus
    init(
        showBorder: Bool,
        contentLayout: CardContentLayout = .fill,
        backgroundColor: Color? = nil,
        style: CardStyle = .bordered,
        @ViewBuilder content: () -> Content
    ) {
        self.contentLayout = contentLayout
        self.contentAlignment = .leading
        self.showBorder = showBorder
        self.backgroundColor = backgroundColor
        self.style = style
        self.content = content()
    }

    // PATTERN 4: Background color focus
    init(
        backgroundColor: Color?,
        showBorder: Bool = true,
        contentLayout: CardContentLayout = .default(),
        style: CardStyle = .bordered,
        @ViewBuilder content: () -> Content
    ) {
        self.backgroundColor = backgroundColor
        self.showBorder = showBorder
        self.contentLayout = contentLayout
        self.contentAlignment = .leading
        self.style = style
        self.content = content()
    }

    // PATTERN 5: Content alignment focus
    init(
        contentAlignment: HorizontalAlignment,
        showBorder: Bool = true,
        backgroundColor: Color? = nil,
        contentLayout: CardContentLayout = .default(),
        style: CardStyle = .bordered,
        @ViewBuilder content: () -> Content
    ) {
        self.contentAlignment = contentAlignment
        self.showBorder = showBorder
        self.backgroundColor = backgroundColor
        self.contentLayout = contentLayout
        self.style = style
        self.content = content()
    }
}

// MARK: - Previews
struct CardPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {

            standalone
                .screenLayout()

            content
                .screenLayout()
            
            ios26Styles
                .screenLayout()

            standaloneIntrinsic
                .padding(.medium)
        }
        .background(Color.screen)
        .previewLayout(.sizeThatFits)
    }

    @ViewBuilder static var content: some View {
        cardWithFillLayoutContent
        cardWithFillLayoutContentNoHeader
        cardWithOnlyCustomContent
        cardWithTiles
        cardMultilineCritical
        clear
    }

    static var storybook: some View {
        LazyVStack(spacing: .large) {
            standalone
            content
            ios26Styles
        }
    }

    static var standalone: some View {
        Card() {
            contentPlaceholder
            contentPlaceholder
        }
        .previewDisplayName("Standalone (Bordered)")
    }

    // MARK: - iOS 26 Style Previews

    static var ios26Styles: some View {
        VStack(spacing: .medium) {
            Text("iOS 26 Card Styles")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, .medium)

            Card(contentLayout: .default(), style: .filled) {
                SwiftUI.Label("Filled Style", systemImage: "rectangle.fill")
                Text("Uses tertiarySystemFill background")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Card(contentLayout: .default(), style: .grouped) {
                SwiftUI.Label("Grouped Style", systemImage: "rectangle.inset.filled")
                Text("Uses secondarySystemGroupedBackground")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Card(contentLayout: .default(), style: .plain) {
                SwiftUI.Label("Plain Style", systemImage: "rectangle.dashed")
                Text("No background decoration")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Card(contentLayout: .default(), style: .bordered) {
                SwiftUI.Label("Bordered Style (Default)", systemImage: "rectangle")
                Text("Legacy style with border")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .previewDisplayName("iOS 26 Styles")
    }

    static var standaloneIntrinsic: some View {
        HStack(spacing: .medium) {
            Card() {
                intrinsicContentPlaceholder
            }
            .idealSize(horizontal: true, vertical: false)
            
            Card() {
                intrinsicContentPlaceholder
            }
            .idealSize(horizontal: true, vertical: false)
            
            Spacer()
        }
        .previewDisplayName("Standalone Intrinsic width")
    }
    
    static var cardWithFillLayoutContent: some View {
        Card(contentLayout: .fill) {
            contentPlaceholder
            Separator()
            contentPlaceholder
        }
    }
    
    static var cardWithFillLayoutContentNoHeader: some View {
        Card(contentLayout: .fill) {
            contentPlaceholder
            Separator()
            contentPlaceholder
        }
    }

    static var cardWithOnlyCustomContent: some View {
        Card {
            contentPlaceholder
            contentPlaceholder
        }
    }

    static var cardWithTiles: some View {
        Card {
            contentPlaceholder
                .frame(height: 30).clipped()
            Tile("Tile")

            TileGroup {
                Tile("Tile in TileGroup 1")
                Tile("Tile in TileGroup 2")
            }

            TileGroup {
                Tile("Tile in TileGroup 1 (fixed)")
                Tile("Tile in TileGroup 2 (fixed)")
            }
            .fixedSize(horizontal: true, vertical: false)

            ListChoice("ListChoice 1")
                .padding(.trailing, -.medium)
            ListChoice("ListChoice 2")
                .padding(.trailing, -.medium)
            contentPlaceholder
                .frame(height: 30).clipped()
        }
    }

    static var cardMultilineCritical: some View {
        Card(showBorder: true) {
            VStack {
                Text("Title 1")
                Text("Title 2")
            }
        }
        .padding(.horizontal, 10)
    }

    static var clear: some View {
        Card(
            showBorder: true,
            contentLayout: .fill,
            backgroundColor: .clear
        ) {
            VStack(spacing: 0) {
                ListChoice("ListChoice")
                ListChoice("ListChoice", description: "ListChoice description", icon: .alertCircle, showSeparator: false)
            }
            .padding(.top, .xSmall)
        }
    }

    static var snapshot: some View {
        standalone
            .screenLayout()
            .background(Color.screen)
    }
}

struct CardDynamicTypePreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            content
                .environment(\.sizeCategory, .extraSmall)
                .previewDisplayName("Dynamic Type - XS")

            content
                .environment(\.sizeCategory, .accessibilityExtraLarge)
                .previewDisplayName("Dynamic Type - XL")
        }
        .previewLayout(.sizeThatFits)
    }

    @ViewBuilder static var content: some View {
        CardPreviews.snapshot
    }
}
