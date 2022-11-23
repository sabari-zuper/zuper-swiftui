import SwiftUI
import Zuper

struct StorybookTile {

    static let title = "Title"
    static let description = "Description"
    static let descriptionMultiline = """
        Description with <strong>very</strong> <ref>very</ref> <u>very</u> long multiline \
        description and <u>formatting</u> with <applink1>links</applink1>
        """

    static var basic: some View {
        VStack(spacing: .large) {
            Tile(title)
            Tile(title, icon: .alertCircle)
            Tile(title, description: description)
            Tile(title, description: description, icon: .alertCircle)
            Tile {
                contentPlaceholder
            }
        }
    }

    @ViewBuilder static var mix: some View {
        VStack(spacing: .large) {
            Tile("Title with very very very very very long multiline text", description: descriptionMultiline, icon: .alertCircle) {
                contentPlaceholder
            }
            Tile("SF Symbol", description: description, icon: .sfSymbol("info.circle.fill"), status: .critical)
            Tile(title, description: description, icon: .alertCircle, disclosure: .buttonLink("Action", style: .destructive))
            Tile(title, description: description, icon: .alertCircle, disclosure: .icon(.alert))
            Tile(disclosure: .none) {
                contentPlaceholder
            }
            Tile("Tile with custom content", disclosure: .none) {
                contentPlaceholder
            }
            Tile(
                "Tile with no border",
                description: descriptionMultiline,
                icon: .alertCircle,
                showBorder: false
            )
        }
    }
}

struct StorybookTilePreviews: PreviewProvider {

    static var previews: some View {
        ZuperPreviewWrapper {
            StorybookTile.basic
            StorybookTile.mix
        }
    }
}
