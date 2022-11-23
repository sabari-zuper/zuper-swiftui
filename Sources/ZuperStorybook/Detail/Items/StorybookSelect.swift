import SwiftUI
import Zuper

struct StorybookSelect {

    static let label = "Field label"
    static let longLabel = "Very \(String(repeating: "very ", count: 8))long multiline label"
    static let fieldLongLabel = """
        <strong>Label</strong> with a \(String(repeating: "very ", count: 20))long \
        <ref>multiline</ref> label and <applink1>TextLink</applink1>
        """
    static let placeholder = "Placeholder"
    static let value = "Value"
    static let helpMessage = "Help message"
    static let errorMessage = "Error message"

    static var basic: some View {
        VStack(spacing: .medium) {
            select(value: "")
            select(value: "", message: .help(helpMessage))
            select(value: "", message: .error(errorMessage))
            Separator()
            select(value: value)
            select(value: value, message: .help(helpMessage))
            select(value: value, message: .error(errorMessage))
        }
    }

    @ViewBuilder static var mix: some View {
        VStack(spacing: .medium) {
            Group {
                DropDown("Label", value: "Value")
                DropDown("", prefix: .grid, value: "Value")
                DropDown("", prefix: .infoCircle, value: nil, placeholder: "Please select")
                DropDown("Label (Empty Value)", prefix: .infoCircle, value: "")
                DropDown("Label (No Value)", prefix: .infoCircle, value: nil, placeholder: "Please select")
                DropDown("Label", prefix: .email, value: "Value")
            }

            Group {
                DropDown("Label (Disabled)", prefix: .infoCircle, value: "Value", state: .disabled)
                DropDown(
                    "Label (Disabled)",
                    prefix: .infoCircle,
                    value: nil,
                    placeholder: "Please select",
                    state: .disabled
                )
                DropDown("Label (Modified)", prefix: .infoCircle, value: "Modified Value", state: .modified)
                DropDown(
                    "Label (Modified)",
                    prefix: .infoCircle,
                    value: nil,
                    placeholder: "Please select",
                    state: .modified
                )
                DropDown(
                    "Label (Info)",
                    prefix: .infoCircle,
                    value: "Value",
                    message: .help("Help message, also very long and multi-line to test that it works.")
                )

                DropDown(
                    fieldLongLabel,
                    labelAccentColor: .orangeNormal,
                    prefix: .infoCircle,
                    value: "Bad Value with a very long text that should overflow",
                    message: .error("Error message, but also very long and multi-line to test that it works.")
                )
            }
        }
    }

    static func select(value: String, message: Message? = nil) -> some View {
        DropDown(label, prefix: .grid, value: value, placeholder: placeholder, message: message)
    }
}

struct StorybookSelectPreviews: PreviewProvider {

    static var previews: some View {
        ZuperPreviewWrapper {
            StorybookSelect.basic
            StorybookSelect.mix
        }
    }
}
