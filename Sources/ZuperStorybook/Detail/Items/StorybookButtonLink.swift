import SwiftUI
import Zuper

struct StorybookButtonLink {

    static var basic: some View {
        HStack(spacing: .xxLarge) {
            VStack(alignment: .leading, spacing: .large) {
                ButtonLink("ButtonLink Primary", colorStyle: .primary)
                ButtonLink("ButtonLink Secondary", colorStyle: .neutral)
                ButtonLink("ButtonLink Critical", colorStyle: .destructive)
            }
            VStack(alignment: .leading, spacing: .large) {
                ButtonLink("ButtonLink Primary", colorStyle: .primary, icon: .alert)
                ButtonLink("ButtonLink Secondary", colorStyle: .neutral, icon: .alertCircle)
                ButtonLink("ButtonLink Critical", colorStyle: .destructive, icon: .alertCircle)
            }
        }
    }

    static var status: some View {
        VStack(alignment: .leading, spacing: .large) {
            ButtonLink("ButtonLink Info", colorStyle: .status(.info), icon: .infoCircle)
            ButtonLink("ButtonLink Success", colorStyle: .status(.success), icon: .checkCircle)
            ButtonLink("ButtonLink Warning", colorStyle: .status(.warning), icon: .alert)
            ButtonLink("ButtonLink Critical", colorStyle: .status(.critical), icon: .alertCircle)
        }
    }

    static var sizes: some View {
        VStack(alignment: .leading, spacing: .small) {
            ButtonLink("ButtonLink intrinsic size", icon: .grid)
                .border(Color.cloudNormal)
            ButtonLink("ButtonLink small button size", icon: .grid, size: .buttonSmall)
                .border(Color.cloudNormal)
            ButtonLink("ButtonLink button size", icon: .grid, size: .button)
                .border(Color.cloudNormal)
        }
    }
}

struct StorybookButtonLinkPreviews: PreviewProvider {

    static var previews: some View {
        ZuperPreviewWrapper {
            StorybookButtonLink.basic
            StorybookButtonLink.status
            StorybookButtonLink.sizes
        }
    }
}
