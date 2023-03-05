//
//  ExpandableText.swift
//  
//
//  Created by SabariZuper on 05/03/23.
//

import SwiftUI

public struct ExpandableText: View {
    @State private var expanded: Bool = false
    @State private var truncated: Bool = false
    @State private var shrinkText: String
    let font: UIFont
    let lineLimit: Int
    
    let label: String
    let labelColor: BadgeList.LabelColor
    let size: BadgeList.Size
    let style: BadgeList.Style
    let linkAction: TextLink.Action
    private var moreLessText: String {
        if !truncated {
            return ""
        } else {
            return self.expanded ? " \("show less")" : " ...\("show more")"
        }
    }
    
    public var body: some View {
        
        ZStack(alignment: .bottomLeading) {
            Group {
                Text(
                    self.expanded ? label : shrinkText,
                    size: size.textSize,
                    color: .custom(labelColor.color),
                    accentColor: style.iconColor,
                    linkColor: .custom(labelColor.color),
                    linkAction: linkAction
                )
                + Text(moreLessText, color: .inkDark, weight: .bold)
                
            }
            .lineLimit(expanded ? nil : lineLimit)
            .overlay(
                // Render the limited text and measure its size
                Text(label).lineLimit(lineLimit)
                    .background(GeometryReader { visibleTextGeometry in
                        Color.clear.onAppear {
                            let size = CGSize(width: visibleTextGeometry.size.width, height: .greatestFiniteMagnitude)
                            let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font]
                            // Binary search until mid == low && mid == high
                            var lowValue = 0
                            var heighValue = shrinkText.count
                            var midValue = heighValue // start from top so that if text contain we does not need to loop
                            while (heighValue - lowValue) > 1 {
                                let attributedText = NSAttributedString(string: shrinkText + moreLessText, attributes: attributes)
                                let boundingRect = attributedText.boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
                                if boundingRect.size.height > visibleTextGeometry.size.height {
                                    truncated = true
                                    heighValue = midValue
                                    midValue = (heighValue + lowValue) / 2
                                    
                                } else {
                                    if midValue == label.count {
                                        break
                                    } else {
                                        lowValue = midValue
                                        midValue = (lowValue + heighValue) / 2
                                    }
                                }
                                shrinkText = String(label.prefix(midValue))
                            }
                            if truncated {
                                shrinkText = String(shrinkText.prefix(shrinkText.count - 2))  // -2 extra as highlighted text is bold
                            }
                        }
                    })
                    .hidden() // Hide the background
            )
            .font(Font(font)) // set default font
            if truncated {
                SwiftUI.Button(action: {
                    expanded.toggle()
                }, label: {
                    HStack { // taking tap on only last line, As it is not possible to get 'see more' location
                        Spacer()
                        Text("")
                    }.opacity(0)
                })
            }
        }
    }
    
}

struct ExpandableText_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: 10) {
            ExpandableText("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Sed ut laborum", lineLimit: 6)
            ExpandableText("Small text", lineLimit: 3)
            ExpandableText("Render the limited text and measure its size, R", lineLimit: 1)
            ExpandableText("Create a ZStack with unbounded height to allow the inner Text as much, Render the limited text and measure its size, Hide the background Indicates whether the text has been truncated in its display.", lineLimit: 3)
            
            
        }.padding()
    }
}

// MARK: - Inits
public extension ExpandableText {

    /// Creates Zuper BadgeList component.
    init(
        _ label: String = "",
        labelColor: BadgeList.LabelColor = .primary,
        size: BadgeList.Size = .normal,
        style: BadgeList.Style = .neutral,
        lineLimit: Int,
        font: UIFont = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body),
        linkAction: @escaping TextLink.Action = { _, _ in }
    ) {
        self.label = label
        self.labelColor = labelColor
        self.size = size
        self.linkAction = linkAction
        self.lineLimit = lineLimit
        self._shrinkText = State(wrappedValue: label)
        self.font = font
        self.style = style
    }
}
