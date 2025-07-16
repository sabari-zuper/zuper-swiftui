import SwiftUI
import Zuper

// MARK: - Card
struct StorybookCard {

    static var basic: some View {
        LazyVStack(spacing: .large) {
            standalone
            content
        }
    }

    static var standalone: some View {
        Card() {
            contentPlaceholder
            contentPlaceholder
        }
    }

    @ViewBuilder static var content: some View {
        cardWithFillLayoutContent
        cardWithFillLayoutContentNoHeader
        cardWithOnlyCustomContent
        cardWithTiles
        cardMultilineCritical
        clear
    }

    static var cardWithFillLayoutContent: some View {
        Card(contentLayout: .fill) {
            contentPlaceholder
            Separator()
            contentPlaceholder
        }
    }

    static var cardWithFillLayoutContentNoHeader: some View {
        Card(contentLayout: .fill) {
            contentPlaceholder
            Separator()
            contentPlaceholder
        }
    }

    static var cardWithOnlyCustomContent: some View {
        Card {
            contentPlaceholder
            contentPlaceholder
        }
    }

    static var cardWithTiles: some View {
        Card() {
            contentPlaceholder
                .frame(height: 30).clipped()
            Tile("Tile")

            TileGroup {
                Tile("Tile in TileGroup 1")
                Tile("Tile in TileGroup 2")
            }

            TileGroup {
                Tile("Tile in TileGroup 1 (fixed)")
                Tile("Tile in TileGroup 2 (fixed)")
            }
            .fixedSize(horizontal: true, vertical: false)

            ListChoice("ListChoice 1")
                .padding(.trailing, -.medium)
            ListChoice("ListChoice 2")
                .padding(.trailing, -.medium)
            contentPlaceholder
                .frame(height: 30).clipped()
        }
    }

    static var cardMultilineCritical: some View {
        Card() {
            contentPlaceholder
        }
    }

    static var clear: some View {
        Card {
            VStack(spacing: 0) {
                ListChoice("ListChoice")
                ListChoice("ListChoice", description: "ListChoice description", icon: .alert, showSeparator: false)
            }
            .padding(.top, .xSmall)
        }
    }
}

struct StorybookCardPreviews: PreviewProvider {

    static var previews: some View {
        ZuperPreviewWrapper {
            StorybookCard.basic
        }
    }
}
