import Combine
import SwiftUI

/// Serial queue for Zuper Toast component.
///
/// Allows adding new Toasts and dismissing or pausing the currently displayed Toast.
public final class ToastQueue: ObservableObject {

    public static let toastsBufferSize = 5
    public static let dismissTimeout: TimeInterval = 5
    public static let appearDelay: TimeInterval = 0.3
    public static let animationIn: Animation = .spring(response: 0.7, dampingFraction: 0.55)
    public static let animationOut: Animation = .easeIn(duration: 0.35)
    
    enum ToastAction {
        case run
        case pause
        case dismiss
    }
    
    /// View model for Zuper Toast component.
    public struct Toast: Identifiable {
        public let id: UUID
        let description: String
        let icon: Icon.Content
        let progress: Double
        let showProgress: Bool

        init(id: UUID = UUID(), description: String, icon: Icon.Content, progress: Double, showProgress: Bool = false) {
            self.id = id
            self.description = description
            self.icon = icon
            self.progress = progress
            self.showProgress = showProgress
        }

        public init(_ description: String, icon: Icon.Content = .none, showProgress: Bool = false) {
            self.init(description: description, icon: icon, progress: 0, showProgress: showProgress)
        }

        func withProgress(_ progress: Double) -> Self {
            .init(id: id, description: description, icon: icon, progress: max(min(1, progress), 0), showProgress: showProgress)
        }
    }
    
    /// Currently active Toast.
    @Published private(set) var toast: Toast?

    private var cancellable: AnyCancellable?
    private var toastsSubject = PassthroughSubject<Toast, Never>()
    private var currentToastActionSubject: CurrentValueSubject<ToastAction, Never>?

    public init() {
        cancellable = toastsSubject
            .buffer(size: Self.toastsBufferSize, prefetch: .keepFull, whenFull: .dropOldest)
            .delay(for: .seconds(Self.appearDelay), scheduler: RunLoop.main)
            .flatMap(maxPublishers: .max(1)) { [weak self] toast in
                self?.toastPublisher(for: toast) ?? Just(nil).eraseToAnyPublisher()
            }
            .sink { [weak self] toast in
                self?.processToast(toast)
            }
    }

    /// Add a new Toast to be displayed as soon as there is no active Toast displayed.
    /// ShowProgress: Whether to show progress animation (default: false)
    public func add(_ description: String, icon: Icon.Content = .none, showProgress: Bool = false) {
        add(Toast(description, icon: icon, showProgress: showProgress))
    }

    /// Add a new Toast to be displayed as soon as there is no active Toast displayed.
    public func add(_ toast: Toast) {
        toastsSubject.send(toast)
    }
    
    /// Pause the active Toast dismiss progress.
    public func pause() {
        currentToastActionSubject?.send(.pause)
    }
    
    /// Resume the active Toast dismiss progress.
    public func resume() {
        currentToastActionSubject?.send(.run)
    }
    
    /// Dismiss currently active Toast.
    public func dismiss() {
        currentToastActionSubject?.send(.dismiss)
    }
    
    private func toastPublisher(for toast: Toast) -> AnyPublisher<Toast?, Never> {
        let currentToastActionSubject = CurrentValueSubject<ToastAction, Never>(.run)
        self.currentToastActionSubject = currentToastActionSubject
        
        // If progress is true then use progressToastPublisher else simpleToastPublisher
        return toast.showProgress ? progressToastPublisher(for: toast, currentToastActionSubject: currentToastActionSubject) : simpleToastPublisher(for: toast, currentToastActionSubject: currentToastActionSubject)
    }
    
    /// Simple Toast Publisher (No Progress Timer)
    private func simpleToastPublisher(for toast: Toast, currentToastActionSubject: CurrentValueSubject<ToastAction, Never>) -> AnyPublisher<Toast?, Never> {
        let dismissPublisher = currentToastActionSubject
            .flatMap { action -> AnyPublisher<Void, Never> in
                switch action {
                case .run:
                    return Just(())
                        .delay(for: .seconds(Self.dismissTimeout), scheduler: RunLoop.main)
                        .eraseToAnyPublisher()
                case .pause:
                    return Empty<Void, Never>().eraseToAnyPublisher()
                case .dismiss:
                    return Just(()).eraseToAnyPublisher()
                }
            }
            .first()
            .map { _ in nil as Toast? }
        
        return Just(toast)
            .merge(with: dismissPublisher)
            .eraseToAnyPublisher()
    }
    
    /// Progress Toast Publisher
    private func progressToastPublisher(for toast: Toast, currentToastActionSubject: CurrentValueSubject<ToastAction, Never>) -> AnyPublisher<Toast?, Never> {
        var timerPublisher: AnyPublisher<Void, Never> {
            Timer
                .publish(every: 0.1, on: RunLoop.main, in: .common)
                .autoconnect()
                .map { _ in () }
                .eraseToAnyPublisher()
        }

        var progressPublisher: AnyPublisher<TimeInterval, Never> {
            Publishers.CombineLatest(timerPublisher, currentToastActionSubject)
                .map(\.1.incrementProgress)
                .scan(0, +)
                .map { (progress: Double) -> Double in
                    progress / Self.dismissTimeout
                }
                .prepend(0)
                .eraseToAnyPublisher()
        }
        
        return Publishers.CombineLatest(progressPublisher, currentToastActionSubject)
            .prefix { (progress: Double, action: ToastAction) in
                progress <= 1 && action != .dismiss
            }
            .map(\.0)
            .map(toast.withProgress)
            .append(Just(nil))
            .eraseToAnyPublisher()
    }
    
    private func processToast(_ toast: Toast?) {
        if let toast = toast {
            if self.toast == nil {
                showToast(toast)
            } else {
                updateCurrentToastWith(toast)
            }
        } else {
            hideCurrentToast()
        }
    }
    
    private func showToast(_ toast: Toast) {
        withAnimation(Self.animationIn) {
            self.toast = toast
        }
    }
    
    private func updateCurrentToastWith(_ toast: Toast) {
        withAnimation(.linear(duration: 0.1)) {
            self.toast = toast
        }
    }
    
    private func hideCurrentToast() {
        withAnimation(Self.animationOut) {
            self.toast = nil
        }
    }
}

private extension ToastQueue.ToastAction {

    var incrementProgress: TimeInterval {
        switch self {
            case .run:          return 0.1
            case .pause:        return 0
            case .dismiss:      return 1
        }
    }
}
