import SwiftUI

/// One item of a list.
///
/// - Related components
///   - ``List``
public struct ListItem: View {

    let text: String
    let iconContent: Icon.Content
    let iconSize: Icon.Size?
    let size: TextSize
    let spacing: CGFloat
    let style: ListItem.Style
    let linkAction: TextLink.Action

    public var body: some View {
        Label(
            text,
            icon: iconContent,
            iconSize: iconSize,
            style: .text(
                size,
                weight: style.weight,
                color: nil
            ),
            spacing: spacing
        )
        .foregroundColor(style.textColor.value)
    }
}

// MARK: - Inits
public extension ListItem {

    /// Creates Zuper ListItem component using the provided icon.
    init(
        _ text: String = "",
        icon: Icon.Content,
        size: TextSize = .subheadline,
        iconSize: Icon.Size? = nil,
        spacing: CGFloat = .xxSmall,
        style: ListItem.Style = .primary,
        linkAction: @escaping TextLink.Action = { _, _ in }
    ) {
        self.text = text
        self.iconContent = icon
        self.size = size
        self.iconSize = iconSize
        self.spacing = spacing
        self.style = style
        self.linkAction = linkAction
    }

    /// Creates Zuper ListItem component with default appearance, using the `circleSmall` icon.
    init(
        _ text: String = "",
        size: TextSize = .subheadline,
        spacing: CGFloat = .xSmall,
        style: ListItem.Style = .primary,
        linkAction: @escaping TextLink.Action = { _, _ in }
    ) {
        self.init(
            text,
            icon: .circleSmall,
            size: size,
            iconSize: .small,
            spacing: spacing,
            style: style,
            linkAction: linkAction
        )
    }
}

// MARK: - Types
public extension ListItem {

    enum Style {
        case primary
        case secondary
        case custom(color: UIColor = .inkDark, weight: Font.Weight = .regular)

        public var textColor: TextColor {
            switch self {
                case .primary:                      return .inkDark
                case .secondary:                    return .inkNormal
                case .custom(let color, _):         return .custom(color)
            }
        }
    
        public var weight: Font.Weight {
            switch self {
                case .primary:                      return .regular
                case .secondary:                    return .regular
                case .custom(_, let weight):        return weight
            }
        }
    }
}

// MARK: - Previews
struct ListItemPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            snapshots
            snapshotsLinks
            snapshotsCustom
            zuper

            List {
                ListItem(
                    "ListItem",
                    icon: .alertCircle,
                    size: .small,
                    style: .secondary
                )
                Text("Aligned multiline content")
                Text("Aligned multiline content", size: .large)
            }
            .frame(width: 130)
            .padding()
            .previewDisplayName("Text Baseline alignment")
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        ListItem("ListItem")
    }

    static var snapshots: some View {
        VStack(alignment: .leading, spacing: .medium) {
            ListItem("ListItem - normal")
            ListItem("ListItem - normal, secondary", size: .normal, style: .secondary)
            ListItem("ListItem - large", size: .large, style: .primary)
            ListItem("ListItem - large, secondary", size: .large, style: .secondary)
            ListItem("ListItem - small", size: .small, style: .primary)
            ListItem("ListItem - small, secondary", size: .small, style: .secondary)
        }
        .padding()
        .previewDisplayName("Snapshots")
    }
    
    static var snapshotsLinks: some View {
        VStack(alignment: .leading, spacing: .medium) {
            ListItem(#"ListItem containing <a href="link">TextLink</a> or <a href="link">Two</a>"#)
            ListItem(#"ListItem containing <a href="link">TextLink</a> or <a href="link">Two</a>"#, size: .small, style: .secondary)
            ListItem(#"ListItem containing <a href="link">TextLink</a> or <a href="link">Two</a>"#, icon: gridIcon, style: .custom(color: .greenNormal))
        }
        .padding()
        .previewDisplayName("Snapshots - Links")
    }
    
    static var snapshotsCustom: some View {
        VStack(alignment: .leading, spacing: .medium) {
            ListItem("ListItem with custom icon", icon: .alertCircle)
            ListItem("ListItem with custom icon", icon: .check)
            ListItem("ListItem with custom icon", icon: .check)
            ListItem("ListItem with SF Symbol", icon: .sfSymbol("info.circle.fill"))
            ListItem("ListItem with SF Symbol", icon: .sfSymbol("info.circle.fill", color: .blueDark))
            ListItem("ListItem with custom icon", icon: .check, style: .custom(color: .blueDark))
            ListItem("ListItem with no icon", icon: .none)
        }
        .padding()
        .previewDisplayName("Snapshots - Custom")
    }

    static var zuper: some View {
        HStack(alignment: .top, spacing: .medium) {
            VStack(spacing: .medium) {
                ListItem("ListItem - normal", size: .normal, style: .primary)
                ListItem("ListItem - large", size: .large, style: .primary)
            }

            VStack(spacing: .medium) {
                ListItem("ListItem - normal, secondary", size: .normal, style: .secondary)
                ListItem("ListItem - large, secondary", size: .large, style: .secondary)
            }
        }
        .padding()
        .previewDisplayName("zuper")
    }
}
