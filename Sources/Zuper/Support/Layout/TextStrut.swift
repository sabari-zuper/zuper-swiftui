import SwiftUI

/// Invisible vertical line of fixed height based on text size.
///
/// Can be used to unify the height of elements that contain variable combination of icons and texts.
public struct TextStrut: View {
    
    let textSize: TextSize
    
    public var body: some View {
        Text("I", size: textSize, color: .custom(.clear))
            .accessibility(hidden: true)
            .accessibility(removeTraits: .isStaticText)
            .frame(width: 0)
    }

    /// Creates invisible strut of height of text based on provided text size.
    public init(_ textSize: TextSize) {
        self.textSize = textSize
    }
}

// MARK: - Previews
struct TextStrutPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            HStack(spacing: .xxxSmall) {
                TextStrut(.callout)
                    .padding(.horizontal, 1)
                    .overlay(Color.redNormal)
                    .padding(.vertical, .xSmall)
                    .background(Color.redLight)
                Text("Text", size: .callout)
            }
            .padding(.xxSmall)

            HStack(spacing: .xxxSmall) {
                TextStrut(.callout)
                    .padding(.horizontal, 1)
                    .overlay(Color.redNormal)
                    .padding(.vertical, .xSmall)
                    .background(Color.redLight)
              //  Icon(.grid, size: .text(.callout))
            }
            .padding(.xxSmall)

            HStack(spacing: .xxxSmall) {
               // Icon(.grid, size: .text(.callout))
                TextStrut(.callout)
                    .padding(.horizontal, 1)
                    .overlay(Color.redNormal)
                    .padding(.vertical, .xSmall)
                    .background(Color.redLight)
                Text("Text", size: .callout)
            }
            .padding(.xxSmall)
        }
        .previewLayout(.sizeThatFits)
    }
}
