import SwiftUI

/// Zuper label above form fields.
public struct FieldLabel: View {

    let label: String
    let accentColor: UIColor?

    public var body: some View {
        Text(label, size: .normal, weight: .medium, accentColor: accentColor)
            .padding(.bottom, 1)
            .accessibility(.fieldLabel)
    }

    /// Create Zuper form field label.
    public init(
        _ label: String,
        accentColor: UIColor? = nil
    ) {
        self.label = label
        self.accentColor = accentColor
    }
}

// MARK: - Previews
struct FieldLabelPreviews: PreviewProvider {

    static let longLabel = """
        <strong>Label</strong> with a \(String(repeating: "very ", count: 20))long \
        <ref>multiline</ref> label and <applink1>TextLink</applink1>
        """

    static var previews: some View {
        PreviewWrapper {
            FieldLabel("Form Field Label")
            FieldLabel(longLabel, accentColor: .orangeNormal)
        }
        .previewLayout(.sizeThatFits)
    }
}
