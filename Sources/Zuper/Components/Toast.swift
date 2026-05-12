import Combine
import SwiftUI

/// Toast shows a brief message that’s clear & understandable.
///
/// Apply ``Toast`` as a `.top` overlay to an existing view.
/// Provide an instance of ``ToastQueue``, which manages a queue of toasts.
///
/// The following example shows a ``Toast`` applied to a view:
///
///    ```swift
///    let toastQueue = ToastQueue()
///
///    var body: some View {
///        VStack {
///            // content over which to display Toasts
///        }
///        .overlay(Toast(toastQueue: toastQueue))
///    }
///    ```
///
/// Use ``ToastWrapper`` if you need gesture handling, but no queue management.
///
/// Use ``ToastContent`` if you don't need gesture handling or queue management.
/// - Important: Component expands horizontally to infinity.
public struct Toast: View {
    
    @ObservedObject var toastQueue: ToastQueue

    public var body: some View {
        if let toast = toastQueue.toast {
            ToastWrapper(
                toast.description,
                icon: toast.icon,
                pauseAction: toastQueue.pause,
                resumeAction: toastQueue.resume,
                dismissAction: toastQueue.dismiss
            )
            .id(toast.id)
            .padding(.xSmall)
            .transition(.move(edge: .top).combined(with: .opacity))
        }
    }
    
    /// Creates Zuper Toast component with queue management and gesture handling.
    public init(toastQueue: ToastQueue) {
        self.toastQueue = toastQueue
    }
}

/// Variant of Zuper `Toast` component with no gesture handling or queue management.
public struct ToastContent: View {

    @Environment(\.colorScheme) var colorScheme

    let description: String
    let iconContent: Icon.Content

    public var body: some View {
        HStack {
            Label(
                description,
                icon: iconContent,
                style: .text(weight: .regular, color: .none),
                spacing: .xSmall
            )
            .foregroundColor(foregroundColor)
            .padding(.small)

            Spacer()
        }
        .contentShape(Rectangle())
        .background(background)
        .cardGlassEffect(cornerRadius: BorderRadius.iOS26)
    }

    @ViewBuilder var background: some View {
        if #available(iOS 26.0, *) {
            Color.clear
        } else {
            backgroundColor
                .clipShape(shape)
                .elevation(.sheet, shape: .roundedRectangle(borderRadius: BorderRadius.iOS26))
        }
    }

    var foregroundColor: Color {
        if #available(iOS 26.0, *) {
            return .inkDark
        }
        return colorScheme == .light ? .whiteNormal : .inkDark
    }

    var backgroundColor: Color {
        colorScheme == .light ? .inkDark : .whiteDarker
    }

    var shape: some Shape {
        RoundedRectangle(cornerRadius: BorderRadius.iOS26, style: .continuous)
    }

    /// Creates Zuper `Toast` component variant with no gesture handling or queue management.
    public init(_ description: String, icon: Icon.Content = .none) {
        self.description = description
        self.iconContent = icon
    }
}

/// Variant of Zuper `Toast` component with gesture handling, but no queue management.
public struct ToastWrapper: View {
    
    static let minOffsetY: CGFloat = -10
    static let maxOffsetY: CGFloat = 10
    
    let description: String
    let iconContent: Icon.Content
    let pauseAction: () -> Void
    let resumeAction: () -> Void
    let dismissAction: () -> Void

    @State private var offsetY: CGFloat = 0
    @State private var gaveFeedback: Bool = false

    public var body: some View {
        ToastContent(description, icon: iconContent)
            .opacity(opacity)
            .offset(y: cappedOffsetY)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { gesture in
                        pauseAction()
                        offsetY = gesture.translation.height / 2
                        processDragChanged()
                    }
                    .onEnded { _ in
                        if isOffsetDismiss {
                            dismissAction()
                        } else {
                            resumeAction()
                            withAnimation(ToastQueue.animationIn) {
                                offsetY = 0
                            }
                        }
                    }
            )
    }
    
    var isOffsetDismiss: Bool {
        offsetY < Self.minOffsetY
    }
    
    var dismissProgress: CGFloat {
        min(0, cappedOffsetY) / Self.minOffsetY
    }
    
    var opacity: CGFloat {
        return 1 - dismissProgress * 0.2
    }
    
    var cappedOffsetY: CGFloat {
        min(Self.maxOffsetY, offsetY)
    }
    
    /// Creates Zuper `Toast` component variant with gesture handling.
    public init(
        _ description: String,
        icon: Icon.Content = .none,
        pauseAction: @escaping () -> Void = {},
        resumeAction: @escaping() -> Void = {},
        dismissAction: @escaping () -> Void = {}
    ) {
        self.description = description
        self.iconContent = icon
        self.pauseAction = pauseAction
        self.resumeAction = resumeAction
        self.dismissAction = dismissAction
    }
    
    private func processDragChanged() {
        if dismissProgress >= 1, gaveFeedback == false {
            HapticsProvider.sendHapticFeedback(.notification(.warning))
            gaveFeedback = true
        }
        
        if dismissProgress == 0 {
            gaveFeedback = false
        }
    }
}

// MARK: - Previews
struct ToastPreviews: PreviewProvider {

    static let description = "Toast shows a brief message that's clear & understandable."
    static let toastQueue = ToastQueue()
    static let toastLiveQueue = ToastQueue()
    
    static var previews: some View {
        PreviewWrapper {
            standalone
            standaloneWrapper
            storybook
            glassEffect
        }
        .padding(.xLarge)
        .previewLayout(.sizeThatFits)

        PreviewWrapper {
            storybook
                .padding(.xLarge)
                .background(Color.screen)
                .environment(\.colorScheme, .dark)
        }
        .previewLayout(.sizeThatFits)

        PreviewWrapper {
            storybookLive
        }
    }

    static var glassEffect: some View {
        ToastContent(description, icon: .checkCircle)
            .previewDisplayName("Glass Effect (iOS 26+)")
    }

    static var standalone: some View {
        ToastContent(description, icon: gridIcon)

    }

    static var standaloneWrapper: some View {
        ToastWrapper(description, icon: .checkCircle)
            .previewDisplayName("ToastWrapper")
    }

    static var storybook: some View {
        VStack(alignment: .leading, spacing: .xxxLarge) {
            ToastContent(description)
            ToastContent(description, icon: .checkCircle)
            ToastContent("Toast shows a brief message that's clear & understandable.", icon: .checkCircle)
        }
        .padding(.top, .large)
        .padding(.bottom, .xxxLarge)
    }

    static var storybookLive: some View {
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

    static var snapshot: some View {
        storybook
            .padding(.medium)
    }
}

struct ToastDynamicTypePreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            content
                .environment(\.sizeCategory, .extraSmall)
                .previewDisplayName("Dynamic Type - XS")
            content
                .environment(\.sizeCategory, .accessibilityExtraLarge)
                .previewDisplayName("Dynamic Type - XL")
        }
        .padding(.xLarge)
        .previewLayout(.sizeThatFits)
    }

    @ViewBuilder static var content: some View {
        ToastPreviews.standaloneWrapper
    }
}
