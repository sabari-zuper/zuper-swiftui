import SwiftUI
import Zuper

struct StorybookButton {

    @ViewBuilder static var basic: some View {
        LazyVStack(alignment: .leading, spacing: .xLarge) {
            buttons(.primary)
            buttons(.secondary)
            buttons(.neutral)
            buttons(.destructive)
        }
    }

    @ViewBuilder static var status: some View {
        LazyVStack(alignment: .leading, spacing: .xLarge) {
            statusButtonStack(.info)
            statusButtonStack(.success)
            statusButtonStack(.warning)
            statusButtonStack(.critical)
        }
    }

    @ViewBuilder static var mix: some View {
        VStack(alignment: .leading, spacing: .xLarge) {
            Button("Button with SF Symbol", icon: .sfSymbol("info.circle.fill"))
        }
    }

    @ViewBuilder static func buttons(_ style: Zuper.Button.Style) -> some View {
        VStack(spacing: .small) {
            HStack(spacing: .small) {
                Button("Label", style: style)
                Button("Label", icon: .grid, style: style)
            }
            HStack(spacing: .small) {
                Button("Label", style: style)
                Button("Label", icon: .grid, style: style)
            }
            HStack(spacing: .small) {
                Button("Label", style: style)
                    .idealSize()
                Button(.grid, style: style)
                Spacer()
            }
            HStack(spacing: .small) {
                Button("Label", style: style, size: .small)
                    .idealSize()
                Button(.grid, style: style, size: .small)
                Spacer()
            }
        }
    }

    @ViewBuilder static func statusButtonStack(_ status: Status) -> some View {
        VStack(spacing: .xSmall) {
            statusButtons(.status(status))
            statusButtons(.status(status, subtle: true))
        }
    }

    @ViewBuilder static func statusButtons(_ style: Zuper.Button.Style) -> some View {
        HStack(spacing: .xSmall) {
            Group {
                Button("Label", style: style, size: .small)
                Button("Label", icon: .grid, style: style, size: .small)
                Button("Label", style: style, size: .small)
                Button(.grid, style: style, size: .small)
            }
            .idealSize()

            Spacer(minLength: 0)
        }
    }
}

struct StorybookButtonPreviews: PreviewProvider {

    static var previews: some View {
        ZuperPreviewWrapper {
            StorybookButton.basic
            StorybookButton.status
            StorybookButton.mix
        }
    }
}
