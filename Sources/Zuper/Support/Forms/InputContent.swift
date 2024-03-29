import SwiftUI

/// Content for inputs that share common layout with a prefix and suffix.
struct InputContent<Content: View>: View {

    @Environment(\.idealSize) var idealSize

    var prefix: Icon.Content = .none
    var suffix: Icon.Content = .none
    var sufixContent: String? = nil
    var state: InputState = .default
    var message: Message? = nil
    var isPressed: Bool = false
    var isEditing: Bool = false
    var suffixAction: (() -> Void)? = nil
    @ViewBuilder let content: Content
    
    var body: some View {
        HStack(spacing: 0) {
            prefixIcon

            content
                .lineLimit(1)
                .padding(.leading, prefix.isEmpty ? .small : 0)

            if idealSize.horizontal == nil {
                Spacer(minLength: 0)
            }

            TextStrut(.normal)
                .padding(.vertical, Button.Size.default.verticalPadding)

            if let suffixAction = suffixAction {
                suffixIcon
                    .onTapGesture(perform: suffixAction)
                    .accessibility(addTraits: .isButton)
            } else {
                suffixIcon
            }
            sufixContentLabel
        }
        .foregroundColor(state.textColor)
        .background(backgroundColor(isPressed: isPressed).animation(.default, value: message))
        .cornerRadius(BorderRadius.default)
        .overlay(
            RoundedRectangle(cornerRadius: BorderRadius.default)
                .strokeBorder(outlineColor(isPressed: isPressed), lineWidth: BorderWidth.emphasis)
        )
        .disabled(state == .disabled)
    }

    @ViewBuilder var prefixIcon: some View {
        Icon(content: prefix, size: .large)
            .foregroundColor(prefixColor)
            .padding(.horizontal, .xSmall)
            .accessibility(.inputPrefix)
    }

    @ViewBuilder var suffixIcon: some View {
        Icon(content: suffix, size: .large)
            .foregroundColor(suffixColor)
            .padding(.horizontal, .xSmall)
            .contentShape(Rectangle())
            .accessibility(.inputSuffix)
    }
    
    @ViewBuilder var sufixContentLabel: some View {
         if let sufixContent = self.sufixContent, !sufixContent.isEmpty && self.suffix == .none {
            Text(sufixContent, color: .inkNormal, weight: .regular)
                 .padding(.trailing, 6)
        }
    }
    
    private func backgroundColor(isPressed: Bool) -> Color {
        switch (state, isPressed) {
            case (.disabled, _):        return .cloudLight
            case (.default, true):      return .cloudNormalHover
            case (.default, false):     return .cloudNormal
            case (.modified, true):     return .indicoLight
            case (.modified, false):    return .indicoLight.opacity(0.7)
        }
    }

    private var prefixColor: Color {
        switch state {
            case .disabled:             return .cloudDarkActive
            case .modified:             return .indicoDark
            case .default:              return .inkDark
        }
    }

    private var suffixColor: Color {
        switch state {
            case .disabled:             return .cloudDarkActive
            case .modified:             return .indicoDark
            case .default:              return .inkNormal
        }
    }

    private func outlineColor(isPressed: Bool) -> Color {
        switch (message, state, isEditing) {
            case (.error, _, _):        return .redNormal
            case (.warning, _, _):      return .orangeNormal
            case (.help, _, _):         return .indicoNormal
            case (_, .modified, _):     return .indicoDark
            case (_, .default, true):   return .indicoNormal
            default:                    return backgroundColor(isPressed: isPressed)
        }
    }
}

// MARK: - Previews
struct InputContentPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            InputContent(prefix: .sfSymbol("exclamationmark.triangle.fill", color: nil), suffix: .sfSymbol("exclamationmark.bubble.circle.fill", color: nil), sufixContent: nil, state: .default) {
                contentPlaceholder
            }
            .padding(.medium)

            InputContent(prefix: .sfSymbol("exclamationmark.triangle.fill", color: nil), suffix: .sfSymbol("exclamationmark.bubble.circle.fill", color: nil), sufixContent: nil, state: .default, message: .error("", icon: .sfSymbol("exclamationmark.circle.fill", color: nil))) {
                contentPlaceholder
            }
            .padding(.medium)
        }
        .previewLayout(.sizeThatFits)
    }
}
