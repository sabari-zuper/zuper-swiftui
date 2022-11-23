import SwiftUI
import Zuper

struct StorybookTileGroup {

    static var basic: some View {
        TileGroup {
            tiles(intrinsic: false)
        }
    }

    @ViewBuilder static func tiles(intrinsic: Bool) -> some View {
        Tile("Title")
        Tile("Custom content", icon: .grid, action: {}) {
            if intrinsic {
                intrinsicContentPlaceholder
            } else {
                contentPlaceholder
            }
        }
        Tile("Title", description: "No disclosure", icon: .alert, disclosure: .none)
        Tile("No Separator", icon: .alert)
            .tileSeparator(false)
        Tile("Title", description: "Description", icon: .alertCircle)
    }
}

struct StorybookTileGroupPreviews: PreviewProvider {

    static var previews: some View {
        ZuperPreviewWrapper {
            StorybookTileGroup.basic
        }
    }
}
