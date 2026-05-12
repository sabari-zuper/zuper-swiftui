import SwiftUI
import Zuper

@available(iOS 16.0, *)
struct StorybookKeyValue {

    static let key = "Key"
    static let value = "Value"
    static let longValue = "Some very very very very very long value"

    static var basic: some View {
        VStack(alignment: .leading, spacing: .large) {
            KeyValue("Key", value: value)
            KeyValue("Key", value: value, size: .large)
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
}

@available(iOS 16.0, *)
struct StorybookKeyValuePreviews: PreviewProvider {

    static var previews: some View {
        ZuperPreviewWrapper {
            StorybookKeyValue.basic
        }
    }
}
