import SwiftUI

public struct ZuperPreviewWrapper<Content: View>: View {

    @ViewBuilder let content: Content

    public var body: some View {
        content
    }

    public init(@ViewBuilder content: () -> Content) {
        Font.registerZuperFonts()
        self.content = content()
    }
}

typealias PreviewWrapper = ZuperPreviewWrapper
