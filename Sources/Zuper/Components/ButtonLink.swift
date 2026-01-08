import SwiftUI

/// Displays a single, less important action a user can take.
public struct ButtonLink: View {

    let label: String
    let colorStyle: ColorStyle
    let iconContent: Icon.Content
    let style: TypeStyle
    let size: Size
    let action: () -> Void

    public var body: some View {
        SwiftUI.Button(
            action: {
                HapticsProvider.sendHapticFeedback(.light(0.5))
                action()
            },
            label: {
                HStack(spacing: 0) {
                    HStack(alignment: .firstTextBaseline, spacing: .xSmall) {
                        if style != .text {
                            Icon(content: iconContent, size: iconSize)
                        }
                        if style != .icon {
                            Text(
                                label,
                                size: .subheadline,
                                color: TextColor.custom(colorStyle.color.normal),
                                weight: .semibold)
                            .padding(.vertical, verticalPadding)
                        }
                    }

                    TextStrut(.subheadline)
                        .padding(.vertical, verticalPadding)
                }
            }
        )
        .buttonStyle(ZuperStyle(style: colorStyle, size: size, typeStyle: style))
    }
    
    var iconSize: Icon.Size {
        switch size {
            case .default:          return .default
            case .button:           return .comfortable
            case .buttonSmall:      return .compact
        }
    }

    var verticalPadding: CGFloat {
        switch size {
            case .default:              return 0
            case .button:               return Button.Size.default.verticalPadding
            case .buttonSmall:          return .xSmall - 1
        }
    }
}

// MARK: - Inits
public extension ButtonLink {

    /// Creates Zuper ButtonLink component.
    init(
        _ label: String = "",
        style :TypeStyle = .default,
        colorStyle: ColorStyle = .primary,
        icon: Icon.Content = .none,
        size: Size = .default,
        action: @escaping () -> Void = {}
    ) {
        self.label = label
        self.style = style
        self.colorStyle = colorStyle
        self.iconContent = icon
        self.size = size
        self.action = action
    }
}

// MARK: - Types
public extension ButtonLink {

    enum ColorStyle: Equatable {
        case primary
        case neutral
        case destructive
        case status(_ status: Status)
        case custom(colors: (normal: UIColor, active: UIColor))

        public var color: (normal: UIColor, active: UIColor) {
            switch self {
                case .primary:              return (.productNormal, .productLightActive)
                case .neutral:            return (.inkDark, .cloudDark)
                case .destructive:             return (.redNormal, .redLightActive)
                case .status(.info):        return (.blueNormal, .blueLightActive)
                case .status(.success):     return (.greenNormal, .greenLightActive)
                case .status(.warning):     return (.orangeNormal, .orangeLightActive)
                case .status(.critical):    return (.redNormal, .redLightActive)
                case .custom(let colors):   return colors
            }
        }

        public static func ==(lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
                case
                    (.primary, .primary),
                    (.neutral, .neutral),
                    (.destructive, .destructive),
                    (.custom, .custom):
                    return true
                case (.status(let lstatus), .status(let rstatus)) where lstatus == rstatus:
                    return true
                default:
                    return false
            }
        }
    }

    enum Size {
        case `default`
        case button
        case buttonSmall
        
        public var maxWidth: CGFloat? {
            switch self {
                case .default:                  return nil
                case .button, .buttonSmall:     return .infinity
            }
        }
    }
    
    struct ZuperStyle: ButtonStyle {

        let style: ColorStyle
        let size: ButtonLink.Size
        let typeStyle: TypeStyle

        public func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .foregroundColor(Color(configuration.isPressed ? style.color.active : style.color.normal))
                .frame(
                    minWidth: typeStyle == .icon ? .touchTarget : nil,
                    maxWidth: size.maxWidth,
                    minHeight: typeStyle == .icon ? .touchTarget : nil
                )
                .contentShape(Rectangle())
        }
    }
    
    enum TypeStyle: Equatable {
        case `default` // Both Text and Image. here Image is optional
        case text // only Text
        case icon // only Image
    }
}

// MARK: - Previews
struct ButtonLinkPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            zuper
            standalone
            styles
                .previewDisplayName("Styles")
            sizing
            storybook
            storybookStatus
                .previewDisplayName("Status")
            storybookSizes
                .previewDisplayName("Sizes")

            snapshotsCustom
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }
    
    static var zuper: some View {
        VStack(alignment:.center, spacing:20) {
            ButtonLink("Text Button", style: .text, colorStyle: .primary)
            HStack {
                Spacer()
                ButtonLink("", style: .icon, colorStyle: .primary, icon: gridIcon)
                Spacer()
            }
        }.previewDisplayName("Zuper Buttons")
    }

    static var standalone: some View {
        VStack(spacing: 0) {
            ButtonLink("ButtonLink")
            ButtonLink("") // EmptyView
            ButtonLink()   // EmptyView
        }
    }
    
    static var styles: some View {
        HStack(spacing: .xxLarge) {
            VStack(alignment: .leading, spacing: .large) {
                ButtonLink("ButtonLink Primary", style: .default, colorStyle: .primary)
                ButtonLink("ButtonLink Secondary",style: .text, colorStyle: .neutral)
                ButtonLink(style: .icon, colorStyle: .destructive, icon: .alertCircle)
            }
            VStack(alignment: .leading, spacing: .large) {
                ButtonLink("ButtonLink Primary", colorStyle: .primary, icon: .person)
                ButtonLink("ButtonLink Secondary",style: .text, colorStyle: .neutral, icon: .infoCircle)
                ButtonLink("ButtonLink Critical",style: .icon, colorStyle: .destructive, icon: .alertCircle)
            }
        }
    }

    static var sizing: some View {
        VStack(alignment: .leading, spacing: .xSmall) {
            Group {
                StateWrapper(initialState: CGFloat(0)) { state in
                    ContentHeightReader(height: state) {
                        ButtonLink("ButtonLink height \(state.wrappedValue)")
                    }
                }
                StateWrapper(initialState: CGFloat(0)) { state in
                    ContentHeightReader(height: state) {
                        ButtonLink("ButtonLink height \(state.wrappedValue)", icon: gridIcon)
                    }
                }
                StateWrapper(initialState: CGFloat(0)) { state in
                    ContentHeightReader(height: state) {
                        ButtonLink("ButtonLink button height \(state.wrappedValue)", size: .button)
                    }
                }
                StateWrapper(initialState: CGFloat(0)) { state in
                    ContentHeightReader(height: state) {
                        ButtonLink("ButtonLink button height \(state.wrappedValue)", icon: gridIcon, size: .button)
                    }
                }
                StateWrapper(initialState: CGFloat(0)) { state in
                    ContentHeightReader(height: state) {
                        ButtonLink("ButtonLink small height \(state.wrappedValue)", size: .buttonSmall)
                    }
                }
                StateWrapper(initialState: CGFloat(0)) { state in
                    ContentHeightReader(height: state) {
                        ButtonLink("ButtonLink small height \(state.wrappedValue)", icon: gridIcon, size: .buttonSmall)
                    }
                }
            }
            .border(Color.cloudNormal)
        }
    }

    static var storybook: some View {
        HStack(spacing: .xxLarge) {
            VStack(alignment: .leading, spacing: .large) {
                ButtonLink("ButtonLink Primary", colorStyle: .primary)
                ButtonLink("ButtonLink Secondary", colorStyle: .neutral)
                ButtonLink("ButtonLink Critical", colorStyle: .destructive)
            }
            VStack(alignment: .leading, spacing: .large) {
                ButtonLink("ButtonLink Primary", colorStyle: .primary, icon: .person)
                ButtonLink("ButtonLink Secondary", colorStyle: .neutral, icon: .infoCircle)
                ButtonLink("ButtonLink Critical", colorStyle: .destructive, icon: .alertCircle)
            }
        }
    }
    
    static var storybookStatus: some View {
        VStack(alignment: .leading, spacing: .large) {
            ButtonLink("ButtonLink Info", colorStyle: .status(.info), icon: .alertCircle)
            ButtonLink("ButtonLink Success", colorStyle: .status(.success), icon: .checkCircle)
            ButtonLink("ButtonLink Warning", colorStyle: .status(.warning), icon: .alert)
            ButtonLink("ButtonLink Critical", colorStyle: .status(.critical), icon: .alertCircle)
        }
    }
    
    static var storybookSizes: some View {
        VStack(alignment: .leading, spacing: .small) {
            ButtonLink("ButtonLink intrinsic size", icon: .infoCircle)
                .border(Color.cloudNormal)
            ButtonLink("ButtonLink small button size", icon: .infoCircle, size: .buttonSmall)
                .border(Color.cloudNormal)
            ButtonLink("ButtonLink button size", icon: .infoCircle, size: .button)
                .border(Color.cloudNormal)
        }
    }

    @ViewBuilder static var snapshotsCustom: some View {
        ButtonLink(
            "Custom <u>formatted</u> <ref>ref</ref> <applink1>https://localhost</applink1>",
            colorStyle: .custom(colors: (normal: .blueDark, active: .blueNormal)),
            icon: .infoCircle
        )
        .previewDisplayName("Custom")

        ButtonLink(style: .icon, icon: .infoCircle)
            .background(Color.blueLight)
            .padding(.vertical)
            .previewDisplayName("Icon only")
    }

    static var snapshot: some View {
        storybook
            .padding(.medium)
    }
}

struct ButtonLinkDynamicTypePreviews: PreviewProvider {

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
        ButtonLinkPreviews.standalone
        ButtonLinkPreviews.storybookSizes
    }
}
