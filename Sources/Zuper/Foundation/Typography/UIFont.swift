import UIKit
import SwiftUI

public extension UIFont {

    /// Apple HIG-aligned font size enum for consistent typography across iOS.
    /// See: https://developer.apple.com/design/human-interface-guidelines/typography
    enum Size: Int, Comparable {

        // MARK: - Apple HIG Text Styles

        /// 11pt - Smallest readable text
        case caption2 = 11
        /// 12pt - Supplementary content
        case caption = 12
        /// 13pt - Auxiliary information
        case footnote = 13
        /// 15pt - Smaller body text
        case subheadline = 15
        /// 16pt - Secondary content
        case callout = 16
        /// 17pt - Primary content
        case body = 17
        /// 20pt - Tertiary headers
        case title3 = 20
        /// 22pt - Subheadings
        case title2 = 22
        /// 28pt - Section headers
        case title = 28
        /// 34pt - Navigation bars, main screen titles
        case largeTitle = 34

        // MARK: - iOS Specific

        /// Size 11 - Tab bar labels
        case tabBar = 110  // Using 110 to avoid collision with caption2
        /// Size 17 - Navigation bar titles
        case navigationBar = 170  // Using 170 to avoid collision with body

        // MARK: - Deprecated Legacy Aliases (backward compatibility)

        @available(*, deprecated, renamed: "caption", message: "Use .caption (12pt) for Apple HIG compliance")
        public static let small = Size.caption

        @available(*, deprecated, renamed: "subheadline", message: "Use .subheadline (15pt) for Apple HIG compliance")
        public static let normal = Size.subheadline

        @available(*, deprecated, renamed: "callout", message: "Use .callout (16pt) for Apple HIG compliance")
        public static let large = Size.callout

        @available(*, deprecated, renamed: "title3", message: "Use .title3 (20pt) for Apple HIG compliance")
        public static let xLarge = Size.title3

        @available(*, deprecated, renamed: "caption", message: "Use .caption (12pt) for Apple HIG compliance")
        public static let body3 = Size.caption

        @available(*, deprecated, renamed: "subheadline", message: "Use .subheadline (15pt) for Apple HIG compliance")
        public static let body2 = Size.subheadline

        @available(*, deprecated, renamed: "callout", message: "Use .callout (16pt) for Apple HIG compliance")
        public static let body1 = Size.callout

        @available(*, deprecated, renamed: "largeTitle", message: "Use .largeTitle (34pt) for Apple HIG compliance")
        public static let displayTitle = Size.largeTitle

        @available(*, deprecated, renamed: "title", message: "Use .title (28pt) for Apple HIG compliance")
        public static let title1 = Size.title

        @available(*, deprecated, renamed: "largeTitle", message: "Use .largeTitle (34pt) for Apple HIG compliance")
        public static let h1 = Size.largeTitle

        @available(*, deprecated, renamed: "title", message: "Use .title (28pt) for Apple HIG compliance")
        public static let h2 = Size.title

        @available(*, deprecated, renamed: "title2", message: "Use .title2 (22pt) for Apple HIG compliance")
        public static let h3 = Size.title2

        @available(*, deprecated, renamed: "title3", message: "Use .title3 (20pt) for Apple HIG compliance")
        public static let h4 = Size.title3

        @available(*, deprecated, renamed: "body", message: "Use .body (17pt) for Apple HIG compliance")
        public static let h5 = Size.body

        @available(*, deprecated, renamed: "callout", message: "Use .callout (16pt) for Apple HIG compliance")
        public static let h6 = Size.callout

        // MARK: - Computed Properties

        public static func < (lhs: Size, rhs: Size) -> Bool {
            lhs.cgFloat < rhs.cgFloat
        }

        public var cgFloat: CGFloat {
            switch self {
            case .tabBar:           return 11
            case .navigationBar:    return 17
            default:                return CGFloat(self.rawValue)
            }
        }

        /// Returns the corresponding UIFont.TextStyle for Dynamic Type scaling
        public var textStyle: UIFont.TextStyle {
            switch self {
            case .largeTitle:       return .largeTitle
            case .title:            return .title1
            case .title2:           return .title2
            case .title3:           return .title3
            case .body:             return .body
            case .callout:          return .callout
            case .subheadline:      return .subheadline
            case .footnote:         return .footnote
            case .caption:          return .caption1
            case .caption2:         return .caption2
            case .tabBar:           return .caption2
            case .navigationBar:    return .headline
            }
        }
    }

    /// Creates Zuper font with Dynamic Type support.
    static func zuper(size: Size = .body, weight: Weight = .regular) -> UIFont {
        zuper(size: size.cgFloat, weight: weight, textStyle: size.textStyle)
    }

    static var zuper: UIFont {
        zuper()
    }
}

extension UIFont {

    /// Creates Zuper font with Dynamic Type support using UIFontMetrics.
    /// - Parameters:
    ///   - size: Base font size in points
    ///   - weight: Font weight
    ///   - textStyle: UIFont.TextStyle for Dynamic Type scaling (default: .body)
    /// - Returns: A font that scales with Dynamic Type settings
    static func zuper(size: CGFloat, weight: Weight = .regular, textStyle: UIFont.TextStyle = .body) -> UIFont {

        let baseFont: UIFont

        if zuperFontNames.isEmpty {
            baseFont = .systemFont(ofSize: size, weight: weight)
        } else if let fontName = zuperFontNames[weight.swiftUI], let font = UIFont(name: fontName, size: size) {
            baseFont = font
        } else {
            assertionFailure("Unsupported font weight")
            baseFont = .systemFont(ofSize: size, weight: weight)
        }

        // Apply Dynamic Type scaling using UIFontMetrics
        let metrics = UIFontMetrics(forTextStyle: textStyle)
        return metrics.scaledFont(for: baseFont)
    }
}

private extension UIFont.Weight {

    var swiftUI: Font.Weight {
        switch self {
            case .regular:  return .regular
            case .bold:     return .bold
            case .medium:   return .medium
            default:        return .regular
        }
    }
}
