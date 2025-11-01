import SwiftUI

/// Presents users with short, relevant information.
///
/// Badges are indicators of static information.
/// They can be updated when a status changes, but they should not be actionable.
public struct Badge: View {

    public static let verticalPadding: CGFloat = 4 + 1/3 // Results in ±24 height at normal text size
    public static let textSize: TextSize = .small

    let label: String
    let iconContent: Icon.Content
    var style: Style
    var textSize:TextSize
    var iconSize:Icon.Size
    var isStatus: Bool
    var iconPlacement: Icon.Placement

    public var body: some View {
        if isEmpty == false {
            let labelColor = style.labelColor
            let outlineColor = style.outlineColor
            let background = style.background
            
            HStack(spacing: 0) {
                HStack(spacing: .xxSmall) {
                    if isStatus {
                        Circle()
                            .foregroundColor(Color(uiColor: labelColor))
                            .frame(width: 8, height: 8, alignment: .center)
                    }
                    if iconPlacement == .leading && !isStatus &&  !iconContent.isEmpty {
                        Icon(content: iconContent, size: iconSize)
                    }

                    Text(
                        label,
                        size: textSize,
                        color: .custom(labelColor),
                        weight: .medium
                    )
                    .padding(.vertical, Self.verticalPadding)
                    if iconPlacement == .trailing && !isStatus && !iconContent.isEmpty{
                        Icon(content: iconContent, size: iconSize)
                    }
                }
                .foregroundColor(Color(uiColor: labelColor))

                TextStrut(textSize)
                    .padding(.vertical, Self.verticalPadding)
            }
            .padding(.horizontal, .xSmall)
            .background(
                background
                    .clipShape(shape)
            )
            .overlay(
                shape
                    .strokeBorder(outlineColor, lineWidth: BorderWidth.thin)
            )
        }
    }

    var shape: some InsettableShape {
        Capsule()
    }

    var isEmpty: Bool {
        iconContent.isEmpty && label.isEmpty
    }
}

// MARK: - Inits
public extension Badge {
    
    /// Creates Zuper Badge component.
    init(
        _ label: String = "",
        icon: Icon.Content = .none,
        style: Style = .neutral,
        textSize:TextSize = .small,
        iconSize:Icon.Size = .small,
        isStatus: Bool = false,
        iconPlacement: Icon.Placement = .leading
    ) {
        self.label = label
        self.iconContent = icon
        self.style = style
        self.textSize = textSize
        self.iconSize = iconSize
        self.isStatus = isStatus
        self.iconPlacement = iconPlacement
    }
}

// MARK: - Types
public extension Badge {

    enum Style {

        case light
        case lightInverted
        case neutral
        case status(_ status: Status, inverted: Bool = false)
        case custom(labelColor: UIColor, outlineColor: SwiftUI.Color, backgroundColor: SwiftUI.Color)

        public var outlineColor: Color {
            switch self {
                case .light:                                return .cloudNormal
                case .lightInverted:                        return .clear
                case .neutral:                              return .cloudNormal
                case .status(.info, false):                 return .blueLightHover
                case .status(.info, true):                  return .clear
                case .status(.success, false):              return .greenLightHover
                case .status(.success, true):               return .clear
                case .status(.warning, false):              return .orangeLightHover
                case .status(.warning, true):               return .clear
                case .status(.critical, false):             return .redLightHover
                case .status(.critical, true):              return .clear
                case .custom(_, let outlineColor, _):       return outlineColor
            }
        }

        @ViewBuilder public var background: some View {
            switch self {
                case .light:                                Color.whiteDarker
                case .lightInverted:                        Color.inkDark
                case .neutral:                              Color.cloudLight
                case .status(.info, false):                 Color.blueLight
                case .status(.info, true):                  Color.blueNormal
                case .status(.success, false):              Color.greenLight
                case .status(.success, true):               Color.greenNormal
                case .status(.warning, false):              Color.orangeLight
                case .status(.warning, true):               Color.orangeNormal
                case .status(.critical, false):             Color.redLight
                case .status(.critical, true):              Color.redNormal
                case .custom(_, _, let backgroundColor):    backgroundColor
           }
        }

        public var labelColor: UIColor {
            switch self {
                case .light:                                return .inkDark
                case .lightInverted:                        return .whiteNormal
                case .neutral:                              return .inkDark
                case .status(.info, false):                 return .blueDark
                case .status(.info, true):                  return .whiteNormal
                case .status(.success, false):              return .greenDark
                case .status(.success, true):               return .whiteNormal
                case .status(.warning, false):              return .orangeDark
                case .status(.warning, true):               return .whiteNormal
                case .status(.critical, false):             return .redDark
                case .status(.critical, true):              return .whiteNormal
                case .custom(let labelColor, _, _):         return labelColor
            }
        }
    }
}

// MARK: - Previews
struct BadgePreviews: PreviewProvider {

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
        VStack(spacing: 8) {
            Badge("Zuper", icon: .sfSymbol("mail", color: .inkDark), style: .light, textSize: .large, iconSize: .large)
            Badge("label", icon: gridIcon)
            Badge("Zuper", style: .custom(labelColor: .blueDark, outlineColor: .blueDark, backgroundColor: .blueLight), textSize: .normal, iconSize: .large, isStatus: true)
        }
    }

    static var sizing: some View {
        VStack(spacing: .xSmall) {
            StateWrapper(initialState: CGFloat(0)) { state in
                ContentHeightReader(height: state) {
                    Badge("Height \(state.wrappedValue.rounded())")
                }
            }
            StateWrapper(initialState: CGFloat(0)) { state in
                ContentHeightReader(height: state) {
                    Badge("Height \(state.wrappedValue.rounded())", icon: gridIcon)
                }
            }
            StateWrapper(initialState: CGFloat(0)) { state in
                ContentHeightReader(height: state) {
                    Badge("Multiline text\nheight \(state.wrappedValue.rounded())", icon: gridIcon)
                }
            }
        }
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

            HStack(alignment: .top, spacing: .medium) {
                Badge("Very very very very very long badge")
                Badge("Very very very very very long badge")
            }
        }
    }

    static var storybookMix: some View {
        VStack(alignment: .leading, spacing: .xLarge) {
            HStack(spacing: .small) {
                Badge(
                    "Custom",
                    icon: .sfSymbol("airplane", color: .inkDark),
                    style: .custom(
                        labelColor: .blueDark,
                        outlineColor: .blueDark,
                        backgroundColor: .whiteNormal
                    )
                )
            }

            HStack(spacing: .small) {
                Badge("Image", icon: .sfSymbol("f.circle", color: .inkDark))
                Badge("Image", icon: .sfSymbol("f.circle", color: .inkDark), style: .status(.success, inverted: true))
            }

            HStack(spacing: .small) {
                Badge("SF Symbol", icon: .sfSymbol("info.circle.fill"))
                Badge("SF Symbol", icon: .sfSymbol("info.circle.fill"), style: .status(.warning, inverted: true))
            }
        }
        .previewDisplayName("Mix")
    }

    static var snapshot: some View {
        storybook
            .padding(.medium)
    }

    static func badges(_ style: Badge.Style) -> some View {
        HStack(spacing: .small) {
            Badge("label", style: style)
            Badge("label", icon: gridIcon, style: style)
            Badge(icon: gridIcon, style: style)
            Badge("1", style: style)
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

struct BadgeDynamicTypePreviews: PreviewProvider {

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
        BadgePreviews.standalone
        BadgePreviews.sizing
        Badge("1")
    }
}
