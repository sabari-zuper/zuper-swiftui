import SwiftUI

/// Shows simple, non-interactive information in a circular badge.
public struct NotificationBadge: View {

    public static let verticalPadding: CGFloat = 5
    public static let textSize: TextSize = .small

    let content: Content
    let style: Badge.Style

    public var body: some View {
        if isEmpty == false {
            HStack(spacing: 0) {
                contentView
                    .foregroundColor(Color(style.labelColor))

                TextStrut(Self.textSize)
                    .padding(.vertical, Self.verticalPadding)
            }
            .frameWidthAtLeastHeight()
            .background(
                style.background
                    .clipShape(shape)
            )
            .overlay(
                shape
                    .strokeBorder(style.outlineColor, lineWidth: BorderWidth.thin)
            )
            .fixedSize()
        }
    }

    @ViewBuilder var contentView: some View {
        switch content {
            case .text(let text):
                Text(
                    text,
                    size: Self.textSize,
                    color: .custom(style.labelColor),
                    weight: .medium
                )
                .padding(.vertical, Self.verticalPadding)
            case .icon(let icon):
                Icon(content: icon, size: .text(Self.textSize))
        }
    }

    var shape: some InsettableShape {
        Circle()
    }

    var isEmpty: Bool {
        switch content {
            case .text(let text):   return text.isEmpty
            case .icon(let icon):   return icon.isEmpty
        }
    }
}

// MARK: - Inits
public extension NotificationBadge {
    
    /// Creates Zuper NotificationBadge component containing text.
    init(_ label: String, style: Badge.Style = .neutral) {
        self.init(content: .text(label), style: style)
    }

    /// Creates Zuper NotificationBadge component containing an icon.
    init(_ icon: Icon.Content, style: Badge.Style = .neutral) {
        self.init(content: .icon(icon), style: style)
    }
}

// MARK: - Types
public extension NotificationBadge {

    enum Content {
        case icon(Icon.Content)
        case text(String)
    }
}

// MARK: - Previews
struct NotificationBadgePreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            sizing
            storybook
            storybookMix
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        VStack(spacing: 0) {
            NotificationBadge("9")
            NotificationBadge("")  // EmptyView
        }
    }

    static var sizing: some View {
        StateWrapper(initialState: CGFloat(0)) { state in
            ContentHeightReader(height: state) {
                NotificationBadge("\(Int(state.wrappedValue))")
            }
        }
        .previewDisplayName("Bage displays height")
    }

    static var storybook: some View {
        VStack(alignment: .leading, spacing: .xLarge) {
            VStack(alignment: .leading, spacing: .medium) {
                badges(.light)
                badges(.lightInverted)
            }

            badges(.neutral)

            statusBadges(.info)
            statusBadges(.success)
            statusBadges(.warning)
            statusBadges(.critical)
        }
    }

    static var storybookMix: some View {
        VStack(alignment: .leading, spacing: .xLarge) {
            HStack(spacing: .small) {
                NotificationBadge(icon("checkmark"),
                    style: .custom(
                        labelColor: .blueDark,
                        outlineColor: .blueDark,
                        backgroundColor: .whiteNormal
                    )
                )
            }

            HStack(spacing: .small) {
                NotificationBadge(icon("checkmark"))
                NotificationBadge(.sfSymbol("ant.fill"))
            }
        }
        .previewDisplayName("Mix")
    }

    static var snapshot: some View {
        storybook
            .padding(.medium)
    }

    static func badges(_ style: Badge.Style) -> some View {
        HStack(spacing: .medium) {
            NotificationBadge(.grid, style: style)
            NotificationBadge("1", style: style)
        }
    }

    static func statusBadges(_ status: Status) -> some View {
        VStack(alignment: .leading, spacing: .medium) {
            badges(.status(status))
            badges(.status(status, inverted: true))
        }
        .previewDisplayName("\(String(describing: status).titleCased)")
    }
}

struct NotificationBadgeDynamicTypePreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            content
                .environment(\.sizeCategory, .extraSmall)
                .previewDisplayName("Dynamic Type - XS")

            content
                .environment(\.sizeCategory, .accessibilityExtraLarge)
                .previewDisplayName("Dynamic Type - XL")
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    @ViewBuilder static var content: some View {
        NotificationBadgePreviews.standalone
        NotificationBadge("1")
    }
}
