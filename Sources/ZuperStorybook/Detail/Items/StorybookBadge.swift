import SwiftUI
import Zuper

struct StorybookBadge {

    static var basic: some View {
        VStack(alignment: .leading, spacing: .xLarge) {
            VStack(alignment: .leading, spacing: .medium) {
                badges(.light)
                badges(.lightInverted)
            }

            badges(.neutral)

            statusBadges(.info)
            statusBadges(.success)
            statusBadges(.warning)
            statusBadges(.critical)

            HStack(alignment: .top, spacing: .medium) {
                Badge("Very very very very very long badge")
                Badge("Very very very very very long badge")
            }
        }
    }


    static var mix: some View {
        VStack(alignment: .leading, spacing: .xLarge) {
            HStack(spacing: .small) {
                Badge(
                    "Custom",
                    icon: .grid,
                    style: .custom(
                        labelColor: .blueDark,
                        outlineColor: .blueDark,
                        backgroundColor: .whiteNormal
                    )
                )
            }
            
            HStack(spacing: .small) {
                Badge("SF Symbol", icon: .sfSymbol("info.circle.fill"))
                Badge("SF Symbol", icon: .sfSymbol("info.circle.fill"), style: .status(.warning, inverted: true))
            }
        }
    }

    static func badges(_ style: Badge.Style) -> some View {
        HStack(spacing: .small) {
            Badge("label", style: style)
            Badge("label", icon: .grid, style: style)
            Badge(icon: .grid, style: style)
            Badge("1", style: style)
        }
    }

    static func statusBadges(_ status: Status) -> some View {
        VStack(alignment: .leading, spacing: .medium) {
            badges(.status(status))
            badges(.status(status, inverted: true))
        }
    }
}

struct StorybookBadgePreviews: PreviewProvider {

    static var previews: some View {
        ZuperPreviewWrapper {
            StorybookBadge.basic
            StorybookBadge.mix
        }
    }
}
