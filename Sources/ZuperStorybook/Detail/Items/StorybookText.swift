import SwiftUI
import Zuper

struct StorybookText {

    static let multilineText = "Text with multiline content \n with no formatting or text links"
    static let multilineFormattedText = "Text with <ref>formatting</ref>,<br> <u>multiline</u> content <br> and <a href=\"...\">text link</a>"

    @ViewBuilder static var basic: some View {
        VStack(alignment: .leading, spacing: .medium) {
            Group {
                Text("Plain text with no formatting")
                ZText("Selectable text (on long tap)", isSelectable: true)
                ZText("Text <u>formatted</u> <strong>and</strong> <ref>accented</ref>", accentColor: .orangeNormal)
                ZText("Text with strikethrough and kerning", strikethrough: true, kerning: 6)
            }
            .border(Color.cloudDark, width: .hairline)

            ZText(multilineText, color: .custom(.greenDark), alignment: .trailing)
                .background(Color.greenLight)
            ZText(multilineText, color: nil, alignment: .trailing)
                .foregroundColor(.blueDark)
                .background(Color.blueLight)
            ZText(multilineFormattedText, color: .custom(.greenDark), alignment: .trailing, accentColor: .orangeDark)
                .background(Color.greenLight)
            ZText(multilineFormattedText, color: nil, alignment: .trailing, accentColor: .orangeDark)
                .foregroundColor(.blueDark)
                .background(Color.blueLight)
        }
    }
}

struct StorybookTextPreviews: PreviewProvider {

    static var previews: some View {
        ZuperPreviewWrapper {
            StorybookText.basic
        }
    }
}
