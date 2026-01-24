//
//  SwiftUIView.swift
//  Zuper
//
//  Created by Sabarinathan Jayakodi on 16/07/25.
//

import SwiftUI

/// Lightweight Text component optimized for performance in lists
/// Removes HTML processing, attributed strings, overlays, and GeometryReader usage
/// while maintaining the same API as your original Text component
public struct Text: View {
    
    @Environment(\.sizeCategory) var sizeCategory
    
    let content: String
    let size: TextSize
    let color: TextColor?
    let weight: Font.Weight
    let lineSpacing: CGFloat?
    let alignment: TextAlignment
    let kerning: CGFloat
    let strikethrough: Bool
    
    public var body: some View {
        if !content.isEmpty {
            textContent()
                .multilineTextAlignment(alignment)
                .fixedSize(horizontal: false, vertical: true)
                .lineSpacing(lineSpacing ?? 0)
                .kerning(kerning)
                .strikethrough(strikethrough, color: foregroundColor.map { Color(uiColor: $0) })
        }
    }
    
    func textContent() -> SwiftUI.Text {
        let baseText = SwiftUI.Text(verbatim: content)
            .zuperFont(
                size: size.value,
                weight: weight,
                style: size.textStyle,
                sizeCategory: sizeCategory
            )
        
        if let foregroundColor = foregroundColor {
            return baseText.foregroundColor(Color(uiColor: foregroundColor))
        } else {
            return baseText  // No .foregroundColor() applied
        }
    }
    
    var foregroundColor: UIColor? {
        color?.uiValue
    }
}

// MARK: - Inits (Same API as your original Text component)
public extension Text {
    
    /// Creates Lightweight Text component with same API as original Text
    /// Uses ZuperFont system for consistent typography
    ///
    /// - Parameters:
    ///   - content: String to display (HTML tags will be ignored)
    ///   - size: Font size
    ///   - color: Font color
    ///   - weight: Font weight
    ///   - lineSpacing: Line spacing
    ///   - alignment: Text alignment
    ///   - kerning: Character spacing
    ///   - strikethrough: Strikethrough style
    init(
        _ content: String,
        size: TextSize = .subheadline,  // 15pt - Minimal change from old .normal (14pt)
        color: TextColor? = .inkDark,
        weight: Font.Weight = .regular,
        lineSpacing: CGFloat? = nil,
        alignment: TextAlignment = .leading,
        strikethrough: Bool = false,
        kerning: CGFloat = 0
    ) {
        self.content = content
        self.size = size
        self.color = color
        self.weight = weight
        self.lineSpacing = lineSpacing
        self.alignment = alignment
        self.kerning = kerning
        self.strikethrough = strikethrough
    }
}

// MARK: - Types

/// Apple HIG-aligned text size enum for consistent typography across iOS.
/// See: https://developer.apple.com/design/human-interface-guidelines/typography
public enum TextSize {
    // MARK: - Apple HIG Text Styles

    /// 34pt - Navigation bars, main screen titles
    case largeTitle
    /// 28pt - Section headers
    case title
    /// 22pt - Subheadings
    case title2
    /// 20pt - Tertiary headers
    case title3
    /// 17pt - Emphasized body text (semibold by default in HIG)
    case headline
    /// 17pt - Primary content
    case body
    /// 16pt - Secondary content
    case callout
    /// 15pt - Smaller body text
    case subheadline
    /// 13pt - Auxiliary information
    case footnote
    /// 12pt - Supplementary content
    case caption
    /// 11pt - Smallest readable text
    case caption2
    /// Custom size
    case custom(CGFloat)

    // MARK: - Deprecated Legacy Aliases (backward compatibility)

    @available(*, deprecated, renamed: "caption", message: "Use .caption (12pt) for Apple HIG compliance")
    public static let small = TextSize.caption

    @available(*, deprecated, renamed: "subheadline", message: "Use .subheadline (15pt) for Apple HIG compliance")
    public static let normal = TextSize.subheadline

    @available(*, deprecated, renamed: "callout", message: "Use .callout (16pt) for Apple HIG compliance")
    public static let large = TextSize.callout

    @available(*, deprecated, renamed: "title3", message: "Use .title3 (20pt) for Apple HIG compliance")
    public static let xLarge = TextSize.title3

    @available(*, deprecated, renamed: "callout", message: "Use .callout (16pt) for Apple HIG compliance")
    public static let body1 = TextSize.callout

    @available(*, deprecated, renamed: "subheadline", message: "Use .subheadline (15pt) for Apple HIG compliance")
    public static let body2 = TextSize.subheadline

    @available(*, deprecated, renamed: "caption", message: "Use .caption (12pt) for Apple HIG compliance")
    public static let body3 = TextSize.caption

    // MARK: - Computed Properties

    /// Point size value for the text style
    public var value: CGFloat {
        switch self {
        case .largeTitle:           return 34
        case .title:                return 28
        case .title2:               return 22
        case .title3:               return 20
        case .headline:             return 17
        case .body:                 return 17
        case .callout:              return 16
        case .subheadline:          return 15
        case .footnote:             return 13
        case .caption:              return 12
        case .caption2:             return 11
        case .custom(let size):     return size
        }
    }

    /// Apple text style for Dynamic Type scaling
    public var textStyle: Font.TextStyle {
        switch self {
        case .largeTitle:           return .largeTitle
        case .title:                return .title
        case .title2:               return .title2
        case .title3:               return .title3
        case .headline:             return .headline
        case .body:                 return .body
        case .callout:              return .callout
        case .subheadline:          return .subheadline
        case .footnote:             return .footnote
        case .caption:              return .caption
        case .caption2:
            if #available(iOS 14.0, *) {
                return .caption2
            } else {
                return .caption
            }
        case .custom:               return .body
        }
    }

    /// UIKit text style for Dynamic Type scaling (used in attributed strings)
    public var uiTextStyle: UIFont.TextStyle {
        switch self {
        case .largeTitle:           return .largeTitle
        case .title:                return .title1
        case .title2:               return .title2
        case .title3:               return .title3
        case .headline:             return .headline
        case .body:                 return .body
        case .callout:              return .callout
        case .subheadline:          return .subheadline
        case .footnote:             return .footnote
        case .caption:              return .caption1
        case .caption2:             return .caption2
        case .custom:               return .body
        }
    }

    /// Line height based on Apple HIG recommendations (approximately 1.2x font size)
    public var lineHeight: CGFloat {
        switch self {
        case .largeTitle:           return 41
        case .title:                return 34
        case .title2:               return 28
        case .title3:               return 25
        case .headline:             return 22
        case .body:                 return 22
        case .callout:              return 21
        case .subheadline:          return 20
        case .footnote:             return 18
        case .caption:              return 16
        case .caption2:             return 13
        case .custom(let size):     return size * 1.2
        }
    }

    /// Icon size to align with text
    public var iconSize: CGFloat {
        switch self {
        case .largeTitle:           return 40
        case .title:                return 34
        case .title2:               return 28
        case .title3:               return 25
        case .headline, .body:      return 22
        case .callout:              return 21
        case .subheadline:          return 20
        case .footnote:             return 18
        case .caption:              return 16
        case .caption2:             return 13
        case .custom(let size):     return size * 1.2
        }
    }

    /// Default weight per Apple HIG (headline is semibold, others are regular)
    public var defaultWeight: Font.Weight {
        switch self {
        case .headline:             return .semibold
        default:                    return .regular
        }
    }
}
    
/// Text color options aligned with Apple Human Interface Guidelines.
///
/// ## Apple HIG Semantic Colors
/// Use semantic names for better code clarity:
/// - `.primary` - Main content text (maps to `.inkDark`)
/// - `.secondary` - Supporting text (maps to `.inkNormal`)
/// - `.tertiary` - Placeholder/disabled text (maps to `.inkLight`)
/// - `.inverse` - Text on dark backgrounds (maps to `.white`)
///
public enum TextColor: Equatable {

    // MARK: - Apple HIG Semantic Names (Recommended)

    /// Primary text color - Use for main content and titles.
    /// Maps to Apple HIG's `.label` semantic color.
    case primary

    /// Secondary text color - Use for subtitles and supporting text.
    /// Maps to Apple HIG's `.secondaryLabel` semantic color.
    case secondary

    /// Tertiary text color - Use for placeholder text and disabled states.
    /// Maps to Apple HIG's `.tertiaryLabel` semantic color.
    case tertiary

    /// Inverse text color - Use for text on dark backgrounds.
    case inverse

    // MARK: - Legacy Names (Backward Compatibility)

    /// Zuper Ink Dark color (same as `.primary`).
    case inkDark

    /// Zuper Ink Normal color (same as `.secondary`).
    case inkNormal

    /// White color for dark backgrounds (same as `.inverse`).
    case white

    // MARK: - Custom

    /// Custom color using UIColor.
    case custom(UIColor)

    // MARK: - Color Values

    public var value: SwiftUI.Color {
        SwiftUI.Color(uiValue)
    }

    public var uiValue: UIColor {
        switch self {
        case .primary, .inkDark:        return .inkDark
        case .secondary, .inkNormal:    return .inkNormal
        case .tertiary:                 return .inkLight
        case .inverse, .white:          return .whiteNormal
        case .custom(let color):        return color
        }
    }
}


// MARK: - Constants
extension Text {
    
    // Alignment ratio for text size.
    public static var firstBaselineRatio: CGFloat { 0.26 }
}
