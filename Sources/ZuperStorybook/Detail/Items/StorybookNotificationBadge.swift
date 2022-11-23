import SwiftUI
import Zuper

struct StorybookNotificationBadge {

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
        }
    }
    
    static var mix: some View {
        VStack(alignment: .leading, spacing: .xLarge) {
            HStack(spacing: .small) {
                NotificationBadge(icon("checkmark"),
                    style: .custom(
                        labelColor: .blueDark,
                        outlineColor: .blueDark,
                        backgroundColor: .whiteNormal
                    )
                )
            }

            HStack(spacing: .small) {
                NotificationBadge(icon("checkmark"))
                NotificationBadge(.sfSymbol("ant.fill"))
            }
        }
        .previewDisplayName("Mix")
    }

    static func badges(_ style: Badge.Style) -> some View {
        HStack(spacing: .medium) {
            NotificationBadge(.grid, style: style)
            NotificationBadge("1", style: style)
        }
    }

    static func statusBadges(_ status: Status) -> some View {
        VStack(alignment: .leading, spacing: .medium) {
            badges(.status(status))
            badges(.status(status, inverted: true))
        }
        .previewDisplayName("\(String(describing: status).titleCased)")
    }
}

struct StorybookNotificationBadgePreviews: PreviewProvider {

    static var previews: some View {
        ZuperPreviewWrapper {
            StorybookNotificationBadge.basic
            StorybookNotificationBadge.mix
        }
    }
}
