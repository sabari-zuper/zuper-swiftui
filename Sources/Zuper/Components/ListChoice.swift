import SwiftUI

public enum ListChoiceDisclosurePosition {
    case leading
    case trailing
}

public enum ListChoiceDisclosure: Equatable {
    
    public enum ButtonType {
        case add
        case remove
    }
    
    case none
    /// An iOS-style disclosure indicator.
    case disclosure(Color = .inkNormal)
    /// A non-interactive button.
    case button(type: ButtonType)
    /// A non-interactive ButtonLink.
    case buttonLink(String, style: ButtonLink.ColorStyle = .primary)
    /// A non-interactive checkbox.
    case checkbox(isChecked: Bool = true, state: Checkbox.State = .normal)
    /// A non-interactive radio.
    case radio(isChecked: Bool = true, state: Radio.State = .normal)
    /// A non-interactive radio.
    case `switch`(isEnabled: Bool = true, isOn: Bool = true)
    /// An icon content.
    case icon(Icon.Content)
}

/// Shows one of a selectable list of items with similar structures.
/// - Important: Component expands horizontally unless prevented by `fixedSize` or `idealSize` modifier.
public struct ListChoice<HeaderContent: View, Content: View>: View {

    public let verticalPadding: CGFloat = .small + 1/3   // Results in ±45 height at normal text size

    @Environment(\.idealSize) var idealSize

    let title: String
    let description: String
    let iconContent: Icon.Content
    let value: String
    let disclosure: ListChoiceDisclosure
    let showSeparator: Bool
    let content: Content
    let action: () -> Void
    let position: ListChoiceDisclosurePosition
    @ViewBuilder let headerContent: HeaderContent

    public var body: some View {
        if isEmpty == false {
            SwiftUI.Button(
                action: {
                    HapticsProvider.sendHapticFeedback(.light(0.5))
                    action()
                },
                label: {
                    buttonContent
                }
            )
            .buttonStyle(ListChoiceButtonStyle())
            .accessibilityElement(children: .ignore)
            .accessibility(label: .init(title))
            .accessibility(value: .init(value))
            .accessibility(hint: .init(description))
            .accessibility(addTraits: .isButton)
            .accessibility(addTraits: accessibilityTraitsToAdd)
        }
    }

    @ViewBuilder var buttonContent: some View {
        HStack(spacing: 0) {
            // If position is leading
            if position == .leading {
                disclosureView
                    .padding(.leading, .medium)
                    .padding(.vertical, .small)
                    .disabled(true)
            }
            VStack(alignment: .leading, spacing: 0) {
                header
                content
            }
            // If position is trailing
            if position == .trailing {
                disclosureView
                    .padding(.horizontal, .medium)
                    .padding(.vertical, .small)
                    .disabled(true)
            }
        }
        .frame(maxWidth: idealSize.horizontal == true ? nil : .infinity, alignment: .leading)
        .overlay(separator, alignment: .bottom)
    }
    
    @ViewBuilder var header: some View {
        if isHeaderEmpty == false || isCustomHeaderEmpty == false {
            HStack(spacing: 0) {
                headerTexts
                    .padding(.trailing, .xSmall)

                if isHeaderEmpty == false, idealSize.horizontal == nil {
                    Spacer(minLength: 0)
                }

                TextStrut(.callout)
                    .padding(.vertical, verticalPadding)

                headerContent
                    .padding(.leading, isHeaderEmpty ? .medium : 0)
                    .padding(.trailing, disclosure == .none ? .medium : 0)
                    .accessibility(.listChoiceValue)
            }
        }
    }
    
    @ViewBuilder var headerTexts: some View {
        if isHeaderEmpty == false {
            HStack(alignment: .center, spacing: .xSmall) {
                Icon(content: iconContent)
                    .foregroundColor(.inkDark)
                    .accessibility(.listChoiceIcon)
                
                if isHeaderTextEmpty == false {
                    VStack(alignment: .labelTextLeading, spacing: .xxxSmall) {
                        Text(title, weight: .medium)
                            .accessibility(.listChoiceTitle)
                        Text(description, size: .caption, color: .inkNormal)
                            .accessibility(.listChoiceDescription)
                    }
                }
            }
            .padding(.leading, .medium)
            .padding(.vertical, verticalPadding)
        }
    }

    @ViewBuilder var disclosureView: some View {
        switch disclosure {
            case .none:
                EmptyView()
            case .disclosure(let color):
                    icon("chevron.right", color: color)
                    .padding(.leading, -.xSmall)
            case .button(let type):
                disclosureButton(type: type)
            case .buttonLink(let label, let style):
                ButtonLink(label, colorStyle: style)
            case .checkbox(let isChecked, let state):
                Checkbox(state: state, isChecked: isChecked)
            case .radio(let isChecked, let state):
                Radio(state: state, isChecked: isChecked)
            case .icon(let content):
                Icon(content: content)
        case .switch(isEnabled: let isEnabled, isOn: let isOn):
            Switch(isOn: .constant(isOn), isEnabled: isEnabled)
        }
    }
    
    @ViewBuilder func disclosureButton(type: ListChoiceDisclosure.ButtonType) -> some View {
        switch type {
            case .add:      Button(icon("plus", color: nil).content, style: .secondary, size: .small).fixedSize()
        case .remove:   Button(icon("minus", color: nil).content, style: .secondary, size: .small).fixedSize()
        }
    }

    @ViewBuilder var separator: some View {
        if showSeparator {
            Separator()
                .padding(.leading, separatorPadding)
        }
    }

    var separatorPadding: CGFloat {
        if isHeaderEmpty {
            return 0
        }
        
        if iconContent.isEmpty {
            return .medium
        }
        
        return .xxLarge
    }

    var isEmpty: Bool {
        isHeaderEmpty && isCustomHeaderEmpty && isCustomContentEmpty && disclosure == .none
    }
    
    var isHeaderEmpty: Bool {
        iconContent.isEmpty && isHeaderTextEmpty
    }

    var isCustomHeaderEmpty: Bool {
        headerContent is EmptyView
    }

    var isCustomContentEmpty: Bool {
        content is EmptyView
    }

    var isHeaderTextEmpty: Bool {
        title.isEmpty && description.isEmpty
    }
    
    var accessibilityTraitsToAdd: AccessibilityTraits {
        switch disclosure {
        case .none, .disclosure, .button(.add), .buttonLink, .checkbox(false, _), .radio(false, _), .icon:
            return []
        case .button(.remove), .checkbox(true, _), .radio(true, _):
            return .isSelected
        case .switch(isEnabled: _, isOn: _):
            return []
        }
    }

    private init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Content = .none,
        value: String = "",
        disclosure: ListChoiceDisclosure = .disclosure(),
        showSeparator: Bool = true,
        disclosurePosition: ListChoiceDisclosurePosition = .trailing,
        action: @escaping () -> Void = {},
        @ViewBuilder content: () -> Content,
        @ViewBuilder headerContent: () -> HeaderContent
    ) {
        self.title = title
        self.description = description
        self.value = value
        self.iconContent = icon
        self.disclosure = disclosure
        self.showSeparator = showSeparator
        self.action = action
        self.content = content()
        self.headerContent = headerContent()
        self.position = disclosurePosition
    }
}

// MARK: - Inits
public extension ListChoice {
    
    /// Creates Zuper ListChoice component with optional content and vertically centered header content.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Content = .none,
        disclosure: ListChoiceDisclosure = .disclosure(),
        showSeparator: Bool = true,
        disclosurePosition: ListChoiceDisclosurePosition = .trailing,
        action: @escaping () -> Void = {},
        @ViewBuilder content: () -> Content,
        @ViewBuilder headerContent: () -> HeaderContent
    ) {
        self.init(
            title,
            description: description,
            icon: icon,
            value: "",
            disclosure: disclosure,
            showSeparator: showSeparator,
            disclosurePosition: disclosurePosition,
            action: action,
            content: content,
            headerContent: headerContent
        )
    }

    /// Creates Zuper ListChoice component with optional vertically centered header content.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Content = .none,
        disclosure: ListChoiceDisclosure = .disclosure(),
        showSeparator: Bool = true,
        disclosurePosition: ListChoiceDisclosurePosition = .trailing,
        action: @escaping () -> Void = {},
        @ViewBuilder headerContent: () -> HeaderContent
    ) where Content == EmptyView {
        self.init(
            title,
            description: description,
            icon: icon,
            disclosure: disclosure,
            showSeparator: showSeparator,
            disclosurePosition: disclosurePosition,
            action: action,
            content: { EmptyView() },
            headerContent: headerContent
        )
    }

    /// Creates Zuper ListChoice component with optional content.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Content = .none,
        disclosure: ListChoiceDisclosure = .disclosure(),
        showSeparator: Bool = true,
        disclosurePosition: ListChoiceDisclosurePosition = .trailing,
        action: @escaping () -> Void = {},
        @ViewBuilder content: () -> Content
    ) where HeaderContent == EmptyView {
        self.init(
            title,
            description: description,
            icon: icon,
            disclosure: disclosure,
            showSeparator: showSeparator,
            disclosurePosition: disclosurePosition,
            action: action,
            content: content,
            headerContent: { EmptyView() }
        )
    }

    /// Creates Zuper ListChoice component.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Content = .none,
        disclosure: ListChoiceDisclosure = .disclosure(),
        showSeparator: Bool = true,
        disclosurePosition: ListChoiceDisclosurePosition = .trailing,
        action: @escaping () -> Void = {}
    ) where HeaderContent == EmptyView, Content == EmptyView {
        self.init(
            title,
            description: description,
            icon: icon,
            disclosure: disclosure,
            showSeparator: showSeparator,
            disclosurePosition: disclosurePosition,
            action: action,
            content: { EmptyView() },
            headerContent: { EmptyView() }
        )
    }
}

public extension ListChoice where HeaderContent == Text {

    /// Creates Zuper ListChoice component with text based header value and optional custom content.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Content = .none,
        value: String,
        disclosure: ListChoiceDisclosure = .disclosure(),
        showSeparator: Bool = true,
        disclosurePosition: ListChoiceDisclosurePosition = .trailing,
        action: @escaping () -> Void = {},
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            title,
            description: description,
            icon: icon,
            value: value,
            disclosure: disclosure,
            showSeparator: showSeparator,
            disclosurePosition: disclosurePosition,
            action: action,
            content: content
        ) {
            Text(value, weight: .medium)
        }
    }

    /// Creates Zuper ListChoice component with text based header value.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Content = .none,
        value: String,
        disclosure: ListChoiceDisclosure = .disclosure(),
        showSeparator: Bool = true,
        disclosurePosition: ListChoiceDisclosurePosition = .trailing,
        action: @escaping () -> Void = {}
    ) where Content == EmptyView {
        self.init(
            title,
            description: description,
            icon: icon,
            value: value,
            disclosure: disclosure,
            showSeparator: showSeparator,
            disclosurePosition: disclosurePosition,
            action: action,
            content: { EmptyView() }
        )
    }
}

extension ListChoice {
    
    // Button style wrapper for ListChoice.
    // Solves the touch-down, touch-up animations that would otherwise need gesture avoidance logic.
    struct ListChoiceButtonStyle: SwiftUI.ButtonStyle {

        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .background(
                    backgroundColor(isPressed: configuration.isPressed)
                        .contentShape(Rectangle())
                )
        }

        func backgroundColor(isPressed: Bool) -> Color {
            isPressed ? .inkNormal.opacity(0.06) : .clear
        }
    }
}

// MARK: - Previews
struct ListChoicePreviews: PreviewProvider {

    static let title = "ListChoice tile"
    static let description = "Further description"
    static let value = "Value"
    static let badge = Badge("3", style: .status(.info, inverted: false))
    static let addButton = ListChoiceDisclosure.button(type: .add)
    static let removeButton = ListChoiceDisclosure.button(type: .remove)
    static let uncheckedCheckbox = ListChoiceDisclosure.checkbox(isChecked: false)
    static let checkedCheckbox = ListChoiceDisclosure.checkbox(isChecked: true)

    static var previews: some View {
        PreviewWrapper {
            zuper
            standalone
            intrinsic
            sizing
            plain
            radio
            storybook
            storybookButton
            storybookCheckbox
        }
        .previewLayout(.sizeThatFits)
    }

    static var zuper: some View {
        ListChoice("Zuper Switch", description: "Zuper switch description", icon: gridIcon, disclosure: .radio(), showSeparator: true)
    }
    
    
    static var standalone: some View {
        VStack(spacing: 0) {
            ListChoice(title, description: description, icon: gridIcon) {
                contentPlaceholder
            } headerContent: {
                headerContent
            }

            // Empty
            ListChoice(disclosure: .none)
        }
    }

    static var intrinsic: some View {
        ListChoice(title, description: description, icon: gridIcon) {
            intrinsicContentPlaceholder
        } headerContent: {
            intrinsicContentPlaceholder
        }
        .idealSize()
    }

    static var sizing: some View {
        VStack(spacing: .medium) {
            Group {
                StateWrapper(initialState: CGFloat(0)) { state in
                    ContentHeightReader(height: state) {
                        ListChoice("Height \(state.wrappedValue)", description: description, icon: gridIcon, value: value)
                    }
                }
                StateWrapper(initialState: CGFloat(0)) { state in
                    ContentHeightReader(height: state) {
                        ListChoice("Height \(state.wrappedValue)", icon: gridIcon, value: value)
                    }
                }
                StateWrapper(initialState: CGFloat(0)) { state in
                    ContentHeightReader(height: state) {
                        ListChoice(description: "Height \(state.wrappedValue)", icon: gridIcon)
                    }
                }
                StateWrapper(initialState: CGFloat(0)) { state in
                    ContentHeightReader(height: state) {
                        ListChoice("Height \(state.wrappedValue)")
                    }
                }
            }
            .border(Color.cloudLight)
        }
        .fixedSize(horizontal: false, vertical: true)
        .background(Color.whiteNormal)
        .previewDisplayName("Sizing")
    }
    
    static var storybook: some View {
        Card(contentLayout: .fill) {
            ListChoice(title)
            ListChoice(title, value: "10")
            ListChoice(title, description: description)
            ListChoice(title, description: "Multiline\ndescription", value: "USD")
            ListChoice(title, icon: .alertCircle)
            ListChoice(title, icon: .alertCircle, value: value)
            ListChoice(title, description: description, icon: .alertCircle)
            ListChoice(title, description: description, icon: .alertCircle, value: value)
            ListChoice(title, description: description, headerContent: {
                badge
            })
            ListChoice(title, description: description, icon: gridIcon, headerContent: {
                badge
            })
        }
    }
    
    static var storybookButton: some View {
        Card(contentLayout: .fill) {
            ListChoice(title, disclosure: addButton)
            ListChoice(title, disclosure: removeButton)
            ListChoice(title, description: description, disclosure: addButton)
            ListChoice(title, description: description, disclosure: removeButton)
            ListChoice(title, icon: .alertCircle, disclosure: addButton)
            ListChoice(title, icon: .alertCircle, disclosure: removeButton)
            ListChoice(title, description: description, icon: .alertCircle, disclosure: addButton)
            ListChoice(title, description: description, icon: .alertCircle, disclosure: removeButton)
            ListChoice(title, description: description, icon: .alertCircle, value: value, disclosure: addButton)
            ListChoice(title, description: description, icon: .alertCircle, disclosure: removeButton) {
                contentPlaceholder
            } headerContent: {
                headerContent
            }
        }
        .previewDisplayName("Button")
    }

    static var storybookCheckbox: some View {
        Card(contentLayout: .fill) {
            ListChoice(title, disclosure: uncheckedCheckbox)
            ListChoice(title, disclosure: checkedCheckbox)
            ListChoice(title, description: description, disclosure: .checkbox(state: .normal))
            ListChoice(title, description: description, disclosure: .checkbox(state: .disabled))
            ListChoice(title, icon: .alertCircle, disclosure: .checkbox(isChecked: false, state: .normal))
            ListChoice(title, icon: .alertCircle, disclosure: .checkbox(isChecked: false, state: .disabled))
            ListChoice(title, description: description, icon: .alertCircle, disclosure: uncheckedCheckbox)
            ListChoice(title, description: description, icon: .alertCircle, disclosure: checkedCheckbox)
            ListChoice(title, description: description, icon: .alertCircle, value: value, disclosure: uncheckedCheckbox)
            ListChoice(title, description: description, icon: .alertCircle, disclosure: checkedCheckbox) {
                contentPlaceholder
            } headerContent: {
                headerContent
            }
        }
        .previewDisplayName("Checkbox")
    }

    static var radio: some View {
        Card(contentLayout: .fill) {
            ListChoice(title, description: description, disclosure: .radio(isChecked: false))
            ListChoice(title, description: description, disclosure: .radio(isChecked: true))
            ListChoice(title, description: description, disclosure: .radio(state: .normal))
            ListChoice(title, description: description, disclosure: .radio(state: .disabled))
            ListChoice(title, icon: .alertCircle, disclosure: .radio(isChecked: false, state: .normal))
            ListChoice(title, icon: .alertCircle, disclosure: .radio(isChecked: false, state: .disabled))
            ListChoice(
                title,
                description: description,
                icon: .alertCircle,
                disclosure: .radio(isChecked: false),
                action: {}
            ) {
                contentPlaceholder
            } headerContent: {
                headerContent
            }
        }
        .previewDisplayName("Radio")
    }

    static var plain: some View {
        Card(contentLayout: .fill) {
            ListChoice(title, disclosure: .none)
            ListChoice(title, description: description, disclosure: .none)
            ListChoice(title, description: "No Separator", disclosure: .none, showSeparator: false)
            ListChoice(title, icon: .alertCircle, disclosure: .none)
            ListChoice(title, icon: icon("", color: .inkNormal).content, disclosure: .none)
            ListChoice(title, description: description, icon: gridIcon, value: value, disclosure: .none)
            ListChoice(title, description: description, disclosure: .none, headerContent: {
                badge
            })
            ListChoice(title, description: description, disclosure: .checkbox(isChecked: true, state: .normal), showSeparator: true, disclosurePosition: .leading)
            ListChoice(disclosure: .none) {
                contentPlaceholder
            } headerContent: {
                headerContent
            }
            ListChoice(
                title,
                disclosure: .radio(isChecked: true, state: .normal),
                showSeparator: false,
                disclosurePosition: .leading
            ) {
                
            }
        }
    }

    static var storybookMix: some View {
        VStack(alignment: .leading, spacing: .large) {
            plain
            radio
        }
    }

    static var headerContent: some View {
        Text("Custom\nheader content")
            .padding(.vertical, .medium)
            .frame(maxWidth: .infinity)
            .background(Color.blueLightActive)
    }

    static var snapshot: some View {
        standalone
    }
}

struct ListChoiceDynamicTypePreviews: PreviewProvider {

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
        ListChoicePreviews.standalone
        ListChoice(ListChoicePreviews.title, disclosure: ListChoicePreviews.addButton)
        ListChoice(ListChoicePreviews.title, disclosure: ListChoicePreviews.uncheckedCheckbox)
    }
}
