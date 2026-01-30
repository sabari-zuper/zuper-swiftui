import SwiftUI

/// A pair of label and value to display read-only information.
/// Now uses native iOS 16+ LabeledContent for better performance and integration.
@available(iOS 16.0, *)
public struct KeyValue: View {

    let key: String
    let value: String
    let size: Size
    let layout: Layout
    let alignment: HorizontalAlignment

    public var body: some View {
        if isEmpty {
            EmptyView()
        } else {
            LabeledContent {
                valueText
                    .accessibility(.keyValueValue)
            } label: {
                keyText
                    .accessibility(.keyValueKey)
            }
            .labeledContentStyle(ZuperKeyValueStyle(size: size, layout: layout, alignment: alignment))
            .accessibilityElement(children: .ignore)
            .accessibility(label: .init(key))
            .accessibility(value: .init(value))
            .accessibility(addTraits: .isStaticText)
        }
    }
    
    @ViewBuilder private var keyText: some View {
        Text(key, size: size.keySize, color: .inkNormal, alignment: .init(alignment))
    }
    
    @ViewBuilder private var valueText: some View {
        ZText(value, size: size.valueSize, weight: .medium, alignment: .init(alignment), isSelectable: true)
    }
    
    private var isEmpty: Bool {
        key.isEmpty && value.isEmpty
    }
}

// MARK: - LabeledContent Style
@available(iOS 16.0, *)
struct ZuperKeyValueStyle: LabeledContentStyle {
    let size: KeyValue.Size
    let layout: KeyValue.Layout
    let alignment: HorizontalAlignment

    func makeBody(configuration: Configuration) -> some View {
        switch layout {
        case .vertical:
            VStack(alignment: alignment, spacing: 0) {
                configuration.label
                configuration.content
            }
        case .horizontal:
            HStack {
                configuration.label
                Spacer()
                configuration.content
                    .foregroundStyle(.secondary)
            }
        }
    }
}

// MARK: - Inits
extension KeyValue {

    /// Creates Zuper KeyValue component.
    public init(
        _ key: String = "",
        value: String = "",
        size: Size = .normal,
        layout: Layout = .vertical,
        alignment: HorizontalAlignment = .leading
    ) {
        self.key = key
        self.value = value
        self.size = size
        self.layout = layout
        self.alignment = alignment
    }
}

// MARK: - Types
extension KeyValue {

    /// Layout direction for key-value pair.
    public enum Layout {
        /// Key on top, value below (default).
        case vertical
        /// Key on leading side, value on trailing side (native LabeledContent style).
        case horizontal
    }

    public enum Size {
        case normal
        case large

        var keySize: TextSize {
            switch self {
                case .normal:   return .caption
                case .large:    return .subheadline
            }
        }

        var valueSize: TextSize {
            switch self {
                case .normal:   return .callout  // 16pt - Apple HIG secondary content
                case .large:    return .body     // 17pt - Apple HIG primary content
            }
        }
    }
}

// MARK: - Previews
struct KeyValuePreviews: PreviewProvider {

    static let key = "Key"
    static let value = "Value"
    static let longValue = "Some very very very very very long value"

    static var previews: some View {
        PreviewWrapper {
            standalone
            storybook
        }
        .padding(.medium)
        .previewLayout(PreviewLayout.sizeThatFits)
    }

    static var standalone: some View {
        VStack {
            KeyValue(key, value: value)
            KeyValue()          // EmptyView
            KeyValue("")        // EmptyView
            KeyValue(value: "") // EmptyView
        }
    }

    static var storybook: some View {
        VStack(alignment: .leading, spacing: .large) {
            KeyValue("Key", value: value)
            KeyValue("Key", value: value, size: .large)
            Separator()
            KeyValue("Key", value: value, layout: .horizontal)
            KeyValue("Key", value: value, size: .large, layout: .horizontal)
            Separator()
            HStack(alignment: .firstTextBaseline, spacing: .large) {
                KeyValue("Key with no value")
                Spacer()
                KeyValue(value: "Value with no key")
            }
            Separator()
            HStack(alignment: .firstTextBaseline, spacing: .large) {
                KeyValue("Trailing very long key", value: longValue, alignment: .trailing)
                Spacer()
                KeyValue("Centered very long key", value: longValue, alignment: .center)
                Spacer()
                KeyValue("Leading very long key", value: longValue, alignment: .leading)
            }
        }
    }

    static var snapshot: some View {
        storybook
            .padding(.medium)
    }
}

struct KeyValueDynamicTypePreviews: PreviewProvider {

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
        KeyValuePreviews.storybook
    }
}
