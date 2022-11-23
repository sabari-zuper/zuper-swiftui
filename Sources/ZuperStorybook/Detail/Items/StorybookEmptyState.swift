import SwiftUI
import Zuper

struct StorybookEmptyState {

    static let title = "Sorry, we couldn't find that connection."
    static let description = "Try changing up your search a bit. We'll try harder next time."
    static let button = "Adjust search"

    static var basic: some View {
        VStack(spacing: .xxLarge) {
            standalone
            Separator()
            subtle
            Separator()
            noAction
        }
    }

    static var standalone: some View {
        
        EmptyState(title, description: description,action: .button(button), imgName: "ic_time", bundle: .current)
    }

    static var subtle: some View {
        
        EmptyState(title, description: description,action: .button(button, style: .secondary), imgName: "ic_time", bundle: .current)
    }

    static var noAction: some View {
        EmptyState(title, description: description, imgName: "ic_time", bundle: .current)
    }
}

struct StorybookEmptyStatePreviews: PreviewProvider {

    static var previews: some View {
        ZuperPreviewWrapper {
            StorybookEmptyState.basic
        }
    }
}
