import SwiftUI

/// Also known as dropdown. Offers a simple form control to select from many options.
/// - Important: Component expands horizontally unless prevented by `fixedSize` or `idealSize` modifier.
public struct DropDown: View {

    @Binding private var messageHeight: CGFloat
    
    let label: String
    let labelAccentColor: UIColor?
    let prefix: Icon.Content
    let value: String?
    let placeholder: String
    let suffix: Icon.Content
    let state: InputState
    let message: Message?
    let action: () -> Void

    public var body: some View {
        FieldWrapper(
            label,
            labelAccentColor: labelAccentColor,
            message: message,
            messageHeight: $messageHeight
        ) {
            SwiftUI.Button(
                action: {
                    HapticsProvider.sendHapticFeedback(.light(0.5))
                    action()
                },
                label: {
                    Text(value ?? placeholder, color: .none)
                        .foregroundColor(textColor)
                        .accessibility(.inputValue)
                }
            )
            .buttonStyle(
                InputStyle(
                    prefix: prefix,
                    suffix: suffix,
                    state: state,
                    message: message
                )
            )
        }
        .accessibilityElement(children: .ignore)
        .accessibility(label: .init(label))
        .accessibility(value: .init(value ?? ""))
        .accessibility(hint: .init(messageDescription.isEmpty ? placeholder : messageDescription))
        .accessibility(addTraits: .isButton)
        .disabled(state == .disabled)
    }

    var textColor: Color {
        value == nil
            ? state.placeholderColor
            : state.textColor
    }

    var messageDescription: String {
        message?.description ?? ""
    }
}

// MARK: - Inits
public extension DropDown {
 
    /// Creates Zuper Select component.
    init(
        _ label: String = "",
        labelAccentColor: UIColor? = nil,
        prefix: Icon.Content = .none,
        value: String?,
        placeholder: String = "",
        suffix: Icon.Content = .chevronDown,
        state: InputState = .default,
        message: Message? = nil,
        messageHeight: Binding<CGFloat> = .constant(0),
        action: @escaping () -> Void = {}
    ) {
        self.label = label
        self.labelAccentColor = labelAccentColor
        self.prefix = prefix
        self.value = value
        self.placeholder = placeholder
        self.suffix = suffix
        self.state = state
        self.message = message
        self._messageHeight = messageHeight
        self.action = action
    }
}

// MARK: - Previews
struct DropDownPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            zuperDropDown
            standalone
            intrinsic
            storybook
            storybookMix
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }
    
    static var zuperDropDown: some View {
        VStack(spacing:20) {
            DropDown("Dropdown with label", value: InputFieldPreviews.value)
            DropDown("",prefix: gridIcon, value: nil, placeholder: "Placeholder")
            DropDown("Date picker dropdown", prefix: .none, value: nil, placeholder: "Placeholder", suffix: .datePicker)
        }
        .previewDisplayName("Zuper Dropdown")
    }

    static var standalone: some View {
        DropDown(InputFieldPreviews.label, prefix: gridIcon, value: InputFieldPreviews.value)
    }

    static var intrinsic: some View {
        DropDown("Intrinsic", prefix: gridIcon, value: InputFieldPreviews.value)
            .idealSize()
    }

    static var storybook: some View {
        VStack(spacing: .medium) {
            select(value: "")
            select(value: "", message: .help(InputFieldPreviews.helpMessage))
            select(value: "", message: .error(InputFieldPreviews.errorMessage))
            Separator()
            select(value: InputFieldPreviews.value)
            select(value: InputFieldPreviews.value, message: .help(InputFieldPreviews.helpMessage))
            select(value: InputFieldPreviews.value, message: .error(InputFieldPreviews.errorMessage))
        }
    }

    static func select(value: String, message: Message? = nil) -> some View {
        DropDown(InputFieldPreviews.label, prefix: gridIcon, value: value, placeholder: InputFieldPreviews.placeholder, message: message)
    }

    @ViewBuilder static var storybookMix: some View {
        VStack(spacing: .medium) {
            Group {
                DropDown("Label", value: "Value")
                DropDown("", prefix: gridIcon, value: "Value")
                DropDown("", prefix: .alertCircle, value: nil, placeholder: "Please select")
                DropDown("Label (Empty Value)", prefix: .alertCircle, value: "")
                DropDown("Label (No Value)", prefix: .alertCircle, value: nil, placeholder: "Please select")
                DropDown("Label", prefix: .email, value: "Value")
            }

            Group {
                DropDown("Label (Disabled)", prefix: .email, value: "Value", state: .disabled)
                DropDown(
                    "Label (Disabled)",
                    prefix: .email,
                    value: nil,
                    placeholder: "Please select",
                    state: .disabled
                )
                DropDown("Label (Modified)", prefix: .email, value: "Modified Value", state: .modified)
                DropDown(
                    "Label (Modified)",
                    prefix: .email,
                    value: nil,
                    placeholder: "Please select",
                    state: .modified
                )
                DropDown(
                    "Label (Info)",
                    prefix: .alertCircle,
                    value: "Value",
                    message: .help("Help message, also very long and multi-line to test that it works.")
                )

                DropDown(
                    FieldLabelPreviews.longLabel,
                    labelAccentColor: .orangeNormal,
                    prefix: .email,
                    value: "Bad Value with a very long text that should overflow",
                    message: .error("Error message, but also very long and multi-line to test that it works.")
                )
            }
        }
    }

    static var snapshot: some View {
        storybook
            .padding(.medium)
    }
}

struct SelectLivePreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            live
        }
    }

    static var live: some View {
        StateWrapper(initialState: false) { state in
            NavigationView {
                ScrollView {
                    VStack(alignment: .leading, spacing: .xxSmall) {
                        Heading("Some content", style: .title3)
                        Text("Very long and multi-line follow-up text to test that it still all works correctly.")

                        DropDown(
                            "Label (Error) with a long multiline label to test that it works",
                            prefix: .email,
                            value: "Bad Value with a very long text that should overflow",
                            message: state.wrappedValue
                                ? .error("Error message, but also very long and multi-line to test that it works.")
                                : .none
                        ) {
                            state.wrappedValue.toggle()
                        }
                        .padding(.vertical, .medium)

                        Heading("Some content", style: .title3)
                        Text("Very long and multi-line follow-up text to test that it still all works correctly.")
                    }
                }
                .overlay(
                    Button("Toggle error") {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            state.wrappedValue.toggle()
                        }
                    },
                    alignment: .bottom
                )
                .padding()
                .navigationBarTitle("Live Preview")
            }
            .previewDisplayName("Live Preview")
        }
    }
}

struct SelectDynamicTypePreviews: PreviewProvider {

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
        DropDownPreviews.standalone
    }
}
