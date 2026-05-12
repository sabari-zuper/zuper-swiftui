import SwiftUI
import Zuper

struct StorybookToast {

    static let description = "Toast shows a brief message that's clear & understandable."
    static let toastQueue = ToastQueue()
    static let toastLiveQueue = ToastQueue()

    static var basic: some View {
        VStack(alignment: .leading, spacing: .xxxLarge) {
            ToastContent(description)
            ToastContent(description, icon: .checkCircle)
            ToastContent("Toast shows a brief message that's clear & understandable.", icon: .checkCircle)
        }
        .padding(.top, .large)
        .padding(.bottom, .xxxLarge)
    }

    static var live: some View {
        VStack(alignment: .leading, spacing: .medium) {
            Heading("Toast enabled screen", style: .h2)

            Spacer()

            Button("Add toast 1") { toastLiveQueue.add(description) }
            Button("Add toast 2") { toastLiveQueue.add("Another toast message.") }
        }
        .padding(.medium)
        .previewDisplayName("Live Preview")
    }

    static var toast: some View {
        Toast(toastQueue: toastLiveQueue)
    }
}

struct StorybookToastPreviews: PreviewProvider {

    static var previews: some View {
        ZuperPreviewWrapper {
            StorybookToast.basic
            StorybookToast.live
        }
    }
}
