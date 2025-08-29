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

/// Separates content into sections.
///
/// Card is a wrapping component around a custom content.
/// - Important: Component expands horizontally unless prevented by `fixedSize` or `idealSize` modifier.
public struct Card<Content: View>: View {
    
    @Environment(\.idealSize) var idealSize
    
    let content: Content
    let contentLayout: CardContentLayout
    let contentAlignment: HorizontalAlignment
    let showBorder: Bool
    let backgroundColor: Color?
    
    public var body: some View {
        VStack(alignment: contentAlignment, spacing: contentSpacing) {
            content
        }
        .padding(contentPadding)
        .frame(maxWidth: idealSize.horizontal == true ? nil : .infinity, alignment: .leading)
        .background(backgroundColor ?? .whiteDarker)
        .tileBorder(showBorder ? .iOS : .none)
        .ignoreScreenLayoutHorizontalPadding()
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
        .accessibilityElement(children: .contain)
    }
    
    // SIMPLIFIED COMPUTED PROPERTIES (only what you use)
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

// MARK: - Inits matching your usage patterns
public extension Card {
    
    // PATTERN 1: Custom padding/spacing
    init(
        contentLayout: CardContentLayout,
        contentAlignment: HorizontalAlignment = .leading,
        showBorder: Bool = true,
        backgroundColor: Color? = .whiteDarker,
        @ViewBuilder content: () -> Content
    ) {
        self.contentLayout = contentLayout
        self.contentAlignment = contentAlignment
        self.showBorder = showBorder
        self.backgroundColor = backgroundColor
        self.content = content()
    }
    
    init(
        @ViewBuilder content: () -> Content
    ) {
        self.contentLayout = .custom(padding: .small, spacing: .small)
        self.contentAlignment = .leading
        self.showBorder = true
        self.backgroundColor = .whiteDarker
        self.content = content()
    }
    
    // PATTERN 2: Fill layout
    init(
        showBorder: Bool = true,
        contentLayout: CardContentLayout = .fill,
        backgroundColor: Color? = .whiteDarker,
        @ViewBuilder content: () -> Content
    ) {
        self.contentLayout = contentLayout
        self.contentAlignment = .leading
        self.showBorder = showBorder
        self.backgroundColor = backgroundColor
        self.content = content()
    }
    
    // PATTERN 3: Background color focus
    init(
        backgroundColor: Color?,
        showBorder: Bool = true,
        contentLayout: CardContentLayout = .default(),
        @ViewBuilder content: () -> Content
    ) {
        self.backgroundColor = backgroundColor
        self.showBorder = showBorder
        self.contentLayout = contentLayout
        self.contentAlignment = .leading
        self.content = content()
    }
    
    // PATTERN 4: Content alignment
    init(
        contentAlignment: HorizontalAlignment,
        showBorder: Bool = true,
        backgroundColor: Color? = .whiteDarker,
        contentLayout: CardContentLayout = .default(),
        @ViewBuilder content: () -> Content
    ) {
        self.contentAlignment = contentAlignment
        self.showBorder = showBorder
        self.backgroundColor = backgroundColor
        self.contentLayout = contentLayout
        self.content = content()
    }
}

/// Separates content into sections.
///
/// Card is a wrapping component around a custom content.
/// - Important: Component expands horizontally unless prevented by `fixedSize` or `idealSize` modifier.
// public struct Card<Content: View>: View {
//
//    @Environment(\.idealSize) var idealSize
//    
//    let title: String
//    let description: String
//    let iconContent: Icon.Content
//    let action: CardAction
//    let headerSpacing: CGFloat
//    let contentLayout: CardContentLayout
//    let contentAlignment: HorizontalAlignment
//    let showBorder: Bool
//    let titleStyle: Heading.Style
//    let status: Status?
//    let backgroundColor: Color?
//    @ViewBuilder let content: Content
//    
//    public var body: some View {
//        VStack(alignment: .leading, spacing: headerSpacing) {
//            header
//            
//            if isContentEmpty == false {
//                VStack(alignment: contentAlignment, spacing: contentSpacing) {
//                    content
//                }
//                .padding(.top, isHeaderEmpty ? contentPadding : 0)
//                .padding([.horizontal, .bottom], contentPadding)
//            }
//        }
//        .frame(maxWidth: idealSize.horizontal == true ? nil : .infinity, alignment: .leading)
//        .background(backgroundColor)
//        .tileBorder(
//            showBorder ? .iOS : .none,
//            status: status
//        )
//        .ignoreScreenLayoutHorizontalPadding()
//        .accessibilityElement(children: .contain)
//    }
//    
//    @ViewBuilder var header: some View {
//        if isHeaderEmpty == false {
//            HStack(alignment: .firstTextBaseline, spacing: 0) {
//                Icon(content: iconContent, size: .heading(titleStyle))
//                    .padding(.trailing, .xSmall)
//                    .accessibility(.cardIcon)
//                
//                VStack(alignment: .leading, spacing: .xxSmall) {
//                    Heading(title, style: titleStyle)
//                        .accessibility(.cardTitle)
//                    Text(description, color: .inkNormal)
//                        .accessibility(.cardDescription)
//                }
//                
//                if idealSize.horizontal == nil {
//                    Spacer(minLength: 0)
//                }
//                
//                switch action {
//                case .buttonLink(let label, let action):
//                    if label.isEmpty == false {
//                        ButtonLink(label, action: action)
//                            .padding(.leading, .xxxSmall)
//                            .accessibility(.cardActionButtonLink)
//                    }
//                case .none:
//                    EmptyView()
//                }
//            }
//            .padding([.horizontal, .top], .medium)
//            .padding(.bottom, isContentEmpty ? .medium : 0)
//        }
//    }
//    
//    var isHeaderEmpty: Bool {
//        if case .none = action, iconContent.isEmpty, title.isEmpty, description.isEmpty {
//            return true
//        } else {
//            return false
//        }
//    }
//    
//    var isContentEmpty: Bool {
//        content is EmptyView
//    }
//    
//    var contentPadding: CGFloat {
//        switch contentLayout {
//        case .fill:                         return 0
//        case .default:                      return .medium
//        case .custom(let padding, _):       return padding
//        }
//    }
//    
//    var contentSpacing: CGFloat {
//        switch contentLayout {
//        case .fill:                         return 0
//        case .default(let spacing):         return spacing
//        case .custom(_, let spacing):       return spacing
//        }
//    }
//}
//
//// MARK: - Inits
//public extension Card {
//    
//    /// Creates Zuper Card wrapper component over a custom content.
//    init(
//        _ title: String = "",
//        description: String = "",
//        icon: Icon.Content = .none,
//        action: CardAction = .none,
//        headerSpacing: CGFloat = .medium,
//        showBorder: Bool = true,
//        titleStyle: Heading.Style = .h6,
//        status: Status? = nil,
//        backgroundColor: Color? = .whiteDarker,
//        contentLayout: CardContentLayout = .default(),
//        contentAlignment: HorizontalAlignment = .leading,
//        @ViewBuilder content: () -> Content
//    ) {
//        self.title = title
//        self.description = description
//        self.iconContent = icon
//        self.action = action
//        self.headerSpacing = headerSpacing
//        self.showBorder = showBorder
//        self.titleStyle = titleStyle
//        self.status = status
//        self.backgroundColor = backgroundColor
//        self.contentLayout = contentLayout
//        self.contentAlignment = contentAlignment
//        self.content = content()
//    }
//    
//    /// Creates Zuper Card wrapper component with empty content.
//    init(
//        _ title: String = "",
//        description: String = "",
//        icon: Icon.Content = .none,
//        action: CardAction = .none,
//        headerSpacing: CGFloat = .medium,
//        showBorder: Bool = true,
//        titleStyle: Heading.Style = .h6,
//        status: Status? = nil,
//        backgroundColor: Color? = .whiteDarker
//    ) where Content == EmptyView {
//        self.init(
//            title,
//            description: description,
//            icon: icon,
//            action: action,
//            headerSpacing: headerSpacing,
//            showBorder: showBorder,
//            titleStyle: titleStyle,
//            status: status,
//            backgroundColor: backgroundColor,
//            content: { EmptyView() }
//        )
//    }
// }

// MARK: - Previews
struct CardPreviews: PreviewProvider {
    
    static var previews: some View {
        PreviewWrapper {
            standalone
                .screenLayout()
            
            content
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
        }
    }
    
    static var standalone: some View {
        Card {
            contentPlaceholder
            contentPlaceholder
        }
        .previewDisplayName("Standalone")
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
        Card() {
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
        Card(showBorder: true,
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
