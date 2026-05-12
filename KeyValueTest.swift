// Quick validation test for KeyValue syntax
import SwiftUI

// Mock the dependencies that KeyValue uses
enum TextSize {
    case small, normal, large
    var textStyle: Font.TextStyle { .body }
    var value: CGFloat { 14 }
}

enum TextColor {
    case inkNormal
}

struct ZText: View {
    let content: String
    init(_ content: String, size: TextSize = .normal, weight: Font.Weight = .regular, alignment: TextAlignment = .leading, isSelectable: Bool = false) {
        self.content = content
    }
    var body: some View { Text(content) }
}

struct Text: View {
    let content: String
    init(_ content: String, size: TextSize = .normal, color: TextColor? = nil, alignment: TextAlignment = .leading) {
        self.content = content
    }
    var body: some View { SwiftUI.Text(content) }
}

extension TextAlignment {
    init(_ alignment: HorizontalAlignment) {
        switch alignment {
        case .leading: self = .leading
        case .center: self = .center
        case .trailing: self = .trailing
        default: self = .leading
        }
    }
}

// Test our KeyValue implementation
@available(iOS 16.0, *)
public struct KeyValue: View {
    let key: String
    let value: String
    let size: Size
    let alignment: HorizontalAlignment

    public var body: some View {
        if isEmpty {
            EmptyView()
        } else {
            LabeledContent {
                valueText
            } label: {
                keyText
            }
            .labeledContentStyle(ZuperKeyValueStyle(size: size, alignment: alignment))
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
    
    public enum Size {
        case normal, large
        var keySize: TextSize {
            switch self {
            case .normal: return .small
            case .large: return .normal
            }
        }
        var valueSize: TextSize {
            switch self {
            case .normal: return .normal
            case .large: return .large
            }
        }
    }
    
    public init(_ key: String = "", value: String = "", size: Size = .normal, alignment: HorizontalAlignment = .leading) {
        self.key = key
        self.value = value
        self.size = size
        self.alignment = alignment
    }
}

@available(iOS 16.0, *)
struct ZuperKeyValueStyle: LabeledContentStyle {
    let size: KeyValue.Size
    let alignment: HorizontalAlignment
    
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: alignment, spacing: 0) {
            configuration.label
            configuration.content
        }
    }
}

// Test usage
@available(iOS 16.0, *)
struct KeyValueTestView: View {
    var body: some View {
        VStack {
            KeyValue("Key", value: "Value")
            KeyValue("Large", value: "Large value", size: .large)
            KeyValue("Center", value: "Centered", alignment: .center)
            KeyValue() // Empty
        }
    }
}

print("✅ KeyValue syntax validation passed!")