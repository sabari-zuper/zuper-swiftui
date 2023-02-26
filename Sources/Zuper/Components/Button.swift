import SwiftUI

/// Displays a single important action a user can take.
/// - Important: Component expands horizontally unless prevented by `fixedSize` or `idealSize` modifier.
public struct Button: View {

    @Environment(\.idealSize) var idealSize

    let label: String
    let iconContent: Icon.Content
    let disclosureIconContent: Icon.Content
    let style: Style
    let size: Size
    let action: () -> Void

    public var body: some View {
        SwiftUI.Button(
            action: {
                presentHapticFeedback()
                action()
            },
            label: {
                HStack(spacing: 0) {
                    if disclosureIconContent.isEmpty, idealSize.horizontal == nil {
                        Spacer(minLength: 0)
                    }

                    HStack(alignment: .firstTextBaseline, spacing: .xSmall) {
                        Icon(content: iconContent, size: iconSize)
                            .foregroundColor(style.foregroundColor)
                        text
                            .padding(.vertical, size.verticalPadding)
                    }

                    if idealSize.horizontal == nil {
                        Spacer(minLength: 0)
                    }

                    TextStrut(size.textSize)
                        .padding(.vertical, size.verticalPadding)

                    Icon(content: disclosureIconContent, size: iconSize)
                        .foregroundColor(style.foregroundColor)
                }
                .padding(.leading, leadingPadding)
                .padding(.trailing, trailingPadding)
            }
        )
        .buttonStyle(ButtonStyle(style: style, size: size))
        .frame(maxWidth: idealSize.horizontal == true ? nil : .infinity)
    }

    @ViewBuilder var text: some View {
        if #available(iOS 14.0, *) {
            Text(
                label,
                size: size.textSize,
                color: .custom(style.foregroundUIColor),
                weight: .semibold
            )
        } else {
            Text(
                label,
                size: size.textSize,
                color: .custom(style.foregroundUIColor),
                weight: .semibold
            )
            // Prevents text value animation issue due to different iOS13 behavior
            .animation(nil)
        }
    }

    var isIconOnly: Bool {
        iconContent.isEmpty == false && label.isEmpty
    }
    
    var iconSize: Icon.Size {
        size == .small ? .small : .normal
    }

    var leadingPadding: CGFloat {
        label.isEmpty == false && iconContent.isEmpty ? size.horizontalPadding : size.horizontalIconPadding
    }

    var trailingPadding: CGFloat {
        label.isEmpty == false && disclosureIconContent.isEmpty ? size.horizontalPadding : size.horizontalIconPadding
    }

    func presentHapticFeedback() {
        switch style {
            case .primary:
                HapticsProvider.sendHapticFeedback(.light(1))
            case .secondary, .neutral, .status(.info, _):
                HapticsProvider.sendHapticFeedback(.light(0.5))
            case .destructive, .status(.critical, _):
                HapticsProvider.sendHapticFeedback(.notification(.error))
            case .status(.warning, _):
                HapticsProvider.sendHapticFeedback(.notification(.warning))
            case .status(.success, _):
                HapticsProvider.sendHapticFeedback(.light(0.5))
        }
    }
}

// MARK: - Inits
public extension Button {

    /// Creates Zuper Button component.
    init(
        _ label: String,
        icon: Icon.Content = .none,
        style: Style = .primary,
        size: Size = .default,
        action: @escaping () -> Void = {}
    ) {
        self.label = label
        self.iconContent = icon
        self.disclosureIconContent = .none
        self.style = style
        self.size = size
        self.action = action
    }

    /// Creates Zuper Button component with icon only.
    init(
        _ icon: Icon.Content = .none,
        style: Style = .primary,
        size: Size = .default,
        action: @escaping () -> Void = {}
    ) {
        self.init(
            "",
            icon: icon,
            style: style,
            size: size,
            action: action
        )
    }
}

// MARK: - Types
extension Button {

    public enum Style {
        case primary
        case secondary
        case neutral
        case destructive
        case status(_ status: Status, subtle: Bool = false)

        public var foregroundColor: Color {
            Color(foregroundUIColor)
        }

        public var foregroundUIColor: UIColor {
            switch self {
                case .primary:                  return .whiteNormal
                case .secondary:            return .productDark
                case .neutral:                return .inkDark
                case .destructive:                 return .whiteNormal
                case .status(.critical, false): return .whiteNormal
                case .status(.critical, true):  return .redDarkHover
                case .status(.info, false):     return .whiteNormal
                case .status(.info, true):      return .blueDarkHover
                case .status(.success, false):  return .whiteNormal
                case .status(.success, true):   return .greenDarkHover
                case .status(.warning, false):  return .whiteNormal
                case .status(.warning, true):   return .orangeDarkHover
            }
        }

        @ViewBuilder public var background: some View {
            switch self {
                case .primary:                  Color.productNormal
                case .secondary:            Color.productLight
                case .neutral:                Color.cloudNormal
                case .destructive:                 Color.redNormal
                case .status(.critical, false): Color.redNormal
                case .status(.critical, true):  Color.redLightHover
                case .status(.info, false):     Color.blueNormal
                case .status(.info, true):      Color.blueLightHover
                case .status(.success, false):  Color.greenNormal
                case .status(.success, true):   Color.greenLightHover
                case .status(.warning, false):  Color.orangeNormal
                case .status(.warning, true):   Color.orangeLightHover
            }
        }
        
        @ViewBuilder public var backgroundActive: some View {
            switch self {
                case .primary:                  Color.productNormalActive
                case .secondary:            Color.productLightActive
                case .neutral:                Color.cloudNormalActive
                case .destructive:                 Color.redNormalActive
                case .status(.critical, false): Color.redNormalActive
                case .status(.critical, true):  Color.redLightActive
                case .status(.info, false):     Color.blueNormalActive
                case .status(.info, true):      Color.blueLightActive
                case .status(.success, false):  Color.greenNormalActive
                case .status(.success, true):   Color.greenLightActive
                case .status(.warning, false):  Color.orangeNormalActive
                case .status(.warning, true):   Color.orangeLightActive
            }
        }
    }
    
    public enum Size {

        case `default`
        case small

        public var textSize: Text.Size {
            switch self {
                case .default:      return .normal
                case .small:        return .small
            }
        }
        
        public var horizontalPadding: CGFloat {
            switch self {
                case .default:      return .medium
                case .small:        return .small
            }
        }

        public var horizontalIconPadding: CGFloat {
            switch self {
                case .default:      return .small
                case .small:        return verticalPadding
            }
        }

        public var verticalPadding: CGFloat {
            switch self {
                case .default:      return .small + 1          // Results in ±44 height at normal text size
                case .small:        return .xSmall + 1/3       // Results in ±32 height at normal text size
            }
        }
    }

    public struct ButtonStyle: SwiftUI.ButtonStyle {

        var style: Style
        var size: Size

        public func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .contentShape(Rectangle())
                .background(background(for: configuration))
                .cornerRadius(BorderRadius.default)
        }
        
        @ViewBuilder func background(for configuration: Configuration) -> some View {
            if configuration.isPressed {
                style.backgroundActive
            } else {
                style.background
            }
        }
    }

    public struct Content: ExpressibleByStringLiteral {
        public let label: String
        public let action: () -> Void

        public init(_ label: String, action: @escaping () -> Void = {}) {
            self.label = label
            self.action = action
        }

        public init(stringLiteral value: String) {
            self.init(value)
        }
    }
}

let gridIcon: Icon.Content = .sfSymbol("square.grid.2x2", color: nil)

// MARK: - Previews
struct ButtonPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            zuper
            standalone
            standaloneCombinations
            sizing

            storybook
            storybookStatus
            storybookMix
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }
    
    static var zuper: some View {
        VStack(alignment: .leading, spacing: .medium) {
            Heading("Zuper Buttons", style: .h2)
            Button("Primary Button", style: .primary)
            Button("Secondary Button", style: .secondary)
            Button("Neutral Button", style: .neutral)
            Button("Destructive Button", style: .destructive)
            
            Heading("Status Buttons", style: .h2)
            Button("Status Info", style: .status(.info))
            Button("Status Success", style: .status(.success))
            Button("Status Warning", style: .status(.warning))
            Button("Status Error", style: .status(.critical))
        }.previewDisplayName("Zuper Buttons")
    }
    

    static var standalone: some View {
        Button("Button", icon: gridIcon)
    }

    static var standaloneCombinations: some View {
        VStack(spacing: .medium) {
            Button("Button", icon: gridIcon)
            Button("Button")
            Button(gridIcon)
            Button(gridIcon)
                .idealSize()
            Button(.sfSymbol("arrow.up", color: .inkDark))
                .idealSize()
        }
    }

    static var sizing: some View {
        VStack(spacing: .medium) {
            StateWrapper(initialState: CGFloat(0)) { state in
                ContentHeightReader(height: state) {
                    Button("Button height \(state.wrappedValue)")
                }
            }
            StateWrapper(initialState: CGFloat(0)) { state in
                ContentHeightReader(height: state) {
                    Button("Button height \(state.wrappedValue)", icon: gridIcon)
                }
            }
            StateWrapper(initialState: CGFloat(0)) { state in
                ContentHeightReader(height: state) {
                    Button("Button small height \(state.wrappedValue)", size: .small)
                }
            }
            StateWrapper(initialState: CGFloat(0)) { state in
                ContentHeightReader(height: state) {
                    Button("Button small height \(state.wrappedValue)", icon: gridIcon, size: .small)
                        .idealSize()
                }
            }
        }
        .previewDisplayName("Sizing")
    }

    @ViewBuilder static var storybook: some View {
        LazyVStack(alignment: .leading, spacing: .xLarge) {
            buttons(.primary)
            buttons(.secondary)
            buttons(.neutral)
            buttons(.destructive)
        }
    }

    @ViewBuilder static var storybookStatus: some View {
        LazyVStack(alignment: .leading, spacing: .xLarge) {
            statusButtonStack(.info)
            statusButtonStack(.success)
            statusButtonStack(.warning)
            statusButtonStack(.critical)
        }.preferredColorScheme(.dark)
    }

    @ViewBuilder static var storybookMix: some View {
        VStack(alignment: .leading, spacing: .xLarge) {
            Button("Button with SF Symbol", icon: .sfSymbol("info.circle.fill"))
        }
    }

    static var snapshot: some View {
        VStack(alignment: .leading, spacing: .xLarge) {
            buttons(.primary)
            buttons(.secondary)
            buttons(.neutral)
            buttons(.destructive)
        }
        .padding(.medium)
    }

    @ViewBuilder static func buttons(_ style: Button.Style) -> some View {
        VStack(spacing: .small) {
            HStack(spacing: .small) {
                Button("Label", style: style)
                Button("Label", icon: gridIcon, style: style)
            }
            HStack(spacing: .small) {
                Button("Label", style: style)
                Button("Label", icon: gridIcon, style: style)
            }
            HStack(spacing: .small) {
                Button("Label", style: style)
                    .idealSize()
                Button(gridIcon, style: style)
                Spacer()
            }
            HStack(spacing: .small) {
                Button("Label", style: style, size: .small)
                    .idealSize()
                Button(gridIcon, style: style, size: .small)
                Spacer()
            }
        }
    }

    @ViewBuilder static func statusButtonStack(_ status: Status) -> some View {
        VStack(spacing: .xSmall) {
            statusButtons(.status(status))
            statusButtons(.status(status, subtle: true))
        }
    }

    @ViewBuilder static func statusButtons(_ style: Button.Style) -> some View {
        HStack(spacing: .xSmall) {
            Group {
                Button("Label", style: style, size: .small)
                Button("Label", icon: gridIcon, style: style, size: .small)
                Button("Label", style: style, size: .small)
                Button(gridIcon, style: style, size: .small)
            }
            .idealSize()

            Spacer(minLength: 0)
        }
    }
}

struct ButtonDynamicTypePreviews: PreviewProvider {

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
        ButtonPreviews.standaloneCombinations
        ButtonPreviews.sizing
        ButtonPreviews.buttons(.primary)
    }
}
