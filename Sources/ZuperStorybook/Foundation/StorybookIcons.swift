import SwiftUI
import Zuper

struct StorybookIcons {

    static var icons: [Icon.Content] = []

    @ViewBuilder static func storybook(filter: String = "") -> some View {
        LazyVStack(alignment: .leading, spacing: .xSmall) {
            stackContent(filter: filter)
        }
    }

    @ViewBuilder static func stackContent(filter: String) -> some View {
        ForEach(0 ... icons(filter: filter).count / 3, id: \.self) { rowIndex in
            HStack(alignment: .top, spacing: .xSmall) {
                icon(index: rowIndex * 3, filter: filter)
                icon(index: rowIndex * 3 + 1, filter: filter)
                icon(index: rowIndex * 3 + 2, filter: filter)
            }
        }
    }

    @ViewBuilder static func icon(index: Int, filter: String) -> some View {
        if let icon = iconSymbol(index: index, filter: filter) {
            VStack(spacing: .xxSmall) {
                Icon(content: icon)
                Text(String(describing: icon).titleCased, size: .custom(10), color: .inkNormal, isSelectable: true)
            }
            .padding(.horizontal, .xxSmall)
            .padding(.vertical, .xSmall)
            .frame(maxWidth: .infinity)
            .background(Color.whiteDarker)
            .tileBorder(.plain)
        } else {
            Color.whiteLighter
                .frame(height: 1)
                .padding(.horizontal, .xxSmall)
                .padding(.vertical, .xSmall)
                .frame(maxWidth: .infinity)
        }
    }

    static func icons(filter: String) -> [Icon.Content] {
        icons.filter { filter.isEmpty || "\($0)".localizedCaseInsensitiveContains(filter) }
    }

    static func iconSymbol(index: Int, filter: String) -> Icon.Content? {
        let filteredIcons = icons(filter: filter)
        guard filteredIcons.indices.contains(index) else {
            return nil
        }
        return filteredIcons[index]
    }
}

private extension String {

    var unicodeCodePoint: String {
        unicodeScalars.first.map { String($0.value, radix: 16, uppercase: true) } ?? ""
    }
}

struct StorybookIconsPreviews: PreviewProvider {

    static var previews: some View {
        ZuperPreviewWrapper {
            ScrollView {
                StorybookIcons.storybook()
            }
        }
    }
}
