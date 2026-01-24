import SwiftUI

/// One item of a Timeline.
///
/// - Related components
///   - ``Timeline``
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/progress-indicators/timeline/)
public struct TimelineItem<Footer: View>: View {

    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @Environment(\.horizontalSizeClass) var horisontalSizeClass

    let label: String
    let sublabel: String
    let description: String
    let type: TimelineItemType
    let badge: Badge
    @ViewBuilder let footer: Footer

    public var body: some View {
        HStack(alignment: (hasHeaderContent || hasDescription) ? .firstTextBaseline : .top, spacing: .small) {

            TimelineIndicator(type: type)

            VStack(alignment: .leading, spacing: .xSmall) {

                headerWithAccessibilitySizeSupport
                descriptionText
                footer
            }
        }
        .anchorPreference(key: TimelineItemPreferenceKey.self, value: .bounds) {
            [TimelineItemPreference(bounds: $0, type: type)]
        }
    }

    @ViewBuilder var headerWithAccessibilitySizeSupport: some View {
        if horisontalSizeClass == .compact && dynamicTypeSize.isAccessibilitySize {
            VStack(alignment: .leading, spacing: .xSmall) {
                header
            }
        } else {
            HStack(spacing: .xSmall) {
                header
            }
        }
    }

    @ViewBuilder var header: some View {
        if label == "" {
            badge
        } else {
            Heading(label, style: .title5, color: .custom(type.textColor))
        }

        Text(sublabel, size: .small, color: .custom(type.textColor))
            .padding(.leading, dynamicTypeSize.isAccessibilitySize ? .xSmall : 0)
    }

    @ViewBuilder var descriptionText: some View {
        Text(description, size: .normal, color: .custom(type.textColor))
    }

    var hasHeaderContent: Bool {
        label.isEmpty == false || sublabel.isEmpty == false
    }

    var hasDescription: Bool {
        description.isEmpty == false
    }
}

// MARK: - Inits

public extension TimelineItem {

    /// Creates Orbit TimelineItem component with text details and custom content at the bottom.
    init(
        _ label: String = "",
        sublabel: String = "",
        type: TimelineItemType = .future,
        description: String = "",
        badge: Badge = Badge(""),
        @ViewBuilder footer: () -> Footer
    ) {

        self.label = label
        self.sublabel = sublabel
        self.type = type
        self.description = description
        self.badge = badge
        self.footer = footer()
    }
}

public extension TimelineItem where Footer == EmptyView {

    /// Creates Orbit TimelineItem component with text details.
    init(
        _ label: String = "",
        sublabel: String = "",
        type: TimelineItemType = .future,
        description: String = "",
        badge: Badge = Badge("")
    ) {
        self.init(label, sublabel: sublabel, type: type, description: description,badge: badge, footer: { EmptyView() })
    }
}

// MARK: - Types

public enum TimelineItemType: Equatable {

    public enum Status {
        case success
        case neutral
        case warning
        case critical
    }

    case past
    case present(Status? = nil)
    case future

    public var iconSymbol: Icon {
        switch self {
        case .past:                  return Icon(sfSymbol:"checkmark.circle.fill", color: Zuper.Status.success.color)
        case .present(.critical):    return Icon(sfSymbol:"xmark.circle.fill", color: Zuper.Status.critical.color)
        case .present(.warning):     return Icon(sfSymbol:"exclamationmark.circle.fill", color: Zuper.Status.warning.color)
            //.alertCircle
        case .present(.success):     return Icon(sfSymbol:"checkmark.circle.fill", color: Zuper.Status.success.color)
        case .present(.neutral):     return Icon(sfSymbol:"checkmark.circle.fill", color: Zuper.Status.warning.color)
            //.checkCircle
        case .present:               return Icon(content: .none)
            //.none
        case .future:                return Icon(content: .none)
            //.none
        }
    }

    public var color: Color {
        switch self {
            case .past:                  return Zuper.Status.success.color
            case .present(.critical):    return Zuper.Status.critical.color
        case .present(.warning), .present(.neutral):     return Zuper.Status.warning.color
            case .present(.success):     return Zuper.Status.success.color
            case .present:               return Zuper.Status.success.color
            case .future:                return .cloudNormalHover
        }
    }

    public var isCurrentStep: Bool {
        switch self {
            case .present:
                return true
            case .past, .future:
                return false
        }
    }

    public var textColor: UIColor {
        isCurrentStep ? .inkDark : .inkLight
    }

    public var isLineDashed: Bool {
        switch self {
            case .future:
                return true
            case .past, .present:
                return false
        }
    }
}

struct TimelineItemPreferenceKey: SwiftUI.PreferenceKey {

    typealias Value = [TimelineItemPreference]

    static var defaultValue: Value = []

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.append(contentsOf: nextValue())
    }
}

struct TimelineItemPreference {

    let bounds: Anchor<CGRect>
    let type: TimelineItemType
}

// MARK: - Previews
struct TimelineItemPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            snapshots
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        TimelineItem(
            sublabel: "3rd May 14:04",
            type: .past,
            description: "We’ve assigned your request to one of our agents.",
            badge: Badge("Status")
        )
        .padding()
        .previewDisplayName("Timeline")
    }

    static var snapshots: some View {
        VStack(alignment: .leading, spacing: .xLarge) {
            TimelineItem(
                "Requested",
                sublabel: "3rd May 14:04",
                type: .future,
                description: "We’ve assigned your request to one of our agents."
            )
            TimelineItem(
                "Requested",
                sublabel: "3rd May 14:04",
                type: .present(),
                description: "We’ve assigned your request to one of our agents."
            )
            TimelineItem(
                "Requested",
                sublabel: "3rd May 14:04",
                type: .present(.warning),
                description: "We’ve assigned your request to one of our agents."
            )
            TimelineItem(
                "Requested",
                sublabel: "3rd May 14:04",
                type: .present(.critical),
                description: "We’ve assigned your request to one of our agents."
            )
            TimelineItem(
                "Requested",
                sublabel: "3rd May 14:04",
                type: .past,
                description: "We’ve assigned your request to one of our agents."
            )
            TimelineItem(
                type: .present(.warning)
            ) {
                contentPlaceholder
            }
        }
        .padding()
        .previewDisplayName("Timeline")
    }
}

struct TimelineItemCustomContentPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            customContent
        }
        .previewLayout(.sizeThatFits)
    }

    @ViewBuilder static var customContent: some View {
        VStack(alignment: .leading) {
            TimelineItem(
                "Requested",
                sublabel: "3rd May 14:04",
                type: .future,
                description: "We’ve assigned your request to one of our agents."
            ) {
                Button("Add info")
            }

            TimelineItem(
                type: .present(.warning),
                description: "We’ve assigned your request to one of our agents."
            ) {

                VStack {
                    Text(
                        "1 Passenger must check in with the airline for a possible fee",
                        size: .custom(50),
                        color: .custom(TimelineItemType.present(.warning).textColor),
                        weight: .bold
                    )
                    .padding(.leading, .xSmall)
                }
            }
            TimelineItem(
                type: .present(.neutral),
                description: "**We’ve assigned your request to one of our agents**"
            ) {
                Circle()
                    .fill(.red)
                    .frame(width: 50, height: 50)
            }

            TimelineItem(
                type: .present(.warning)
            ) {
                Circle()
                    .fill(.red)
                    .frame(width: 50, height: 50)
            }
        }
        .padding()
        .previewDisplayName("Timeline")
    }
}
