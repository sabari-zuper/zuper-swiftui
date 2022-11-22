import SwiftUI

/// Indicates when there’s no data to show, like when a search has no results.
public struct EmptyState: View {

    let title: String
    let description: String
    let action: Action
    let imgName: String
    let bundle: Bundle
    let layout: Illustration.Layout

    public var body: some View {
        VStack(spacing: .medium) {
            Illustration(imgName, bundle: bundle, layout: layout)
                .padding(.top, .large)
        
            texts
            
            actions
        }
        .accessibilityElement(children: .contain)
    }
    
    @ViewBuilder var texts: some View {
        if title.isEmpty == false || description.isEmpty == false {
            VStack(spacing: .xSmall) {
                Heading(title, style: .title4, alignment: .center)
                    .accessibility(.emptyStateTitle)
                Text(description, color: .inkNormal, alignment: .center)
                    .accessibility(.emptyStateDescription)
            }
        }
    }
    
    @ViewBuilder var actions: some View {
        switch action {
            case .none:
                EmptyView()
            case .button(let label, let style, let action):
                Button(label, style: style, action: action)
                    .idealSize()
                    .accessibility(.emptyStateButton)
        }
    }
}

// MARK: - Types
public extension EmptyState {
    
    enum Action {
        case none
        case button(_ label: String, style: Button.Style = .primary, action: () -> Void = {})
    }
}

// MARK: - Inits
public extension EmptyState {
 
    /// Creates Zuper EmptyState component.
    init(
        _ title: String = "",
        description: String = "",
        action: Action = .none,
        imgName: String = "",
        bundle:Bundle = .current,
        layout: Illustration.Layout = .frame(maxHeight: 120)
    ) {
        self.title = title
        self.description = description
        self.imgName = imgName
        self.bundle = bundle
        self.layout = layout
        self.action = action
    }
}

// MARK: - Previews
struct EmptyStatePreviews: PreviewProvider {

    static let title = "Sorry, we couldn't find that connection."
    static let description = "Try changing up your search a bit. We'll try harder next time."
    static let button = "Adjust search"

    static var previews: some View {
        PreviewWrapper {
            standalone
            subtle
            noAction
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    static var storybook: some View {
        VStack(spacing: .xxLarge) {
            standalone
            Separator()
            subtle
            Separator()
            noAction
        }
    }

    static var standalone: some View {
        EmptyState(title, description: description, action: .button(button),imgName: "ic_time")
            .padding(.medium)
    }
    
    static var subtle: some View {
        EmptyState(title, description: description, action: .button(button, style: .secondary),imgName: "ic_time")
            .padding(.medium)
    }
    
    static var noAction: some View {
        EmptyState(title, description: description)
            .padding(.medium)
    }

    static var snapshot: some View {
        standalone
            .padding(.medium)
    }
}
