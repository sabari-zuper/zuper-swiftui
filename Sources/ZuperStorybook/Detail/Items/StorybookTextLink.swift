import SwiftUI
import Zuper

struct StorybookTextLink {

    static var basic: some View {
        VStack(alignment: .leading, spacing: .large) {
            ZText(link("Primary link"), linkColor: .primary)
            ZText(link("Secondary link"), linkColor: .secondary)
            ZText(link("Info link"), linkColor: .status(.info))
            ZText(link("Success link"), linkColor: .status(.success))
            ZText(link("Warning link"), linkColor: .status(.warning))
            ZText(link("Critical link"), linkColor: .status(.critical))
        }
    }

    static func link(_ content: String) -> String {
        "<a href=\"...\">\(content)</a>"
    }

    static var live: some View {
        StateWrapper(initialState: (0, "")) { state in
            VStack(spacing: .xLarge) {
                ZText("Text containing <a href=\"...\">Some TextLink</a> and <a href=\"...\">Another TextLink</a>") { link, text in
                    state.wrappedValue.0 += 1
                    state.wrappedValue.1 = text
                }

                ButtonLink("ButtonLink") {
                    state.wrappedValue.0 += 1
                    state.wrappedValue.1 = "ButtonLink"
                }

                Button("Button") {
                    state.wrappedValue.0 += 1
                    state.wrappedValue.1 = "Button"
                }

                Text("Tapped \(state.wrappedValue.0)x", color: .inkNormal)
                Text("Tapped \(state.wrappedValue.1)", color: .inkNormal)
            }
        }
    }
}

struct StorybookTextLinkPreviews: PreviewProvider {

    static var previews: some View {
        ZuperPreviewWrapper {
            StorybookTextLink.basic
            StorybookTextLink.live
        }
    }
}
