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
    let lineLimit: Int?
    
    public var body: some View {
        if !content.isEmpty {
            SwiftUI.Text(verbatim: content)
                .zuperFont(
                    size: size.value,
                    weight: weight,
                    style: size.textStyle,
                    sizeCategory: sizeCategory
                )
                .foregroundColor(foregroundColor)
                .multilineTextAlignment(alignment)
                .fixedSize(horizontal: false, vertical: true)
                .lineSpacing(lineSpacing ?? 0)
                .kerning(kerning)
                .strikethrough(strikethrough, color: foregroundColor)
                .lineLimit(lineLimit)
        }
    }
    
    private var foregroundColor: SwiftUI.Color? {
        color?.value
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
    ///   - lineLimit: Maximum number of lines
    init(
        _ content: String,
        size: TextSize = .normal,
        color: TextColor? = .inkDark,
        weight: Font.Weight = .regular,
        lineSpacing: CGFloat? = nil,
        alignment: TextAlignment = .leading,
        strikethrough: Bool = false,
        kerning: CGFloat = 0,
        lineLimit: Int? = nil
    ) {
        self.content = content
        self.size = size
        self.color = color
        self.weight = weight
        self.lineSpacing = lineSpacing
        self.alignment = alignment
        self.kerning = kerning
        self.strikethrough = strikethrough
        self.lineLimit = lineLimit
    }
}

// MARK: - Types
public enum TextSize {
    /// 12 pts.
    case small
    /// 14 pts.
    case normal
    /// 16 pts.
    case large
    /// 18 pts.
    case xLarge
    case custom(CGFloat)
    
    public static let body3 = TextSize.small
    public static let body2 = TextSize.normal
    public static let body1 = TextSize.large
    
    public var value: CGFloat {
        switch self {
        case .small:                return 12
        case .normal:               return 14
        case .large:                return 16
        case .xLarge:               return 18
        case .custom(let size):     return size
        }
    }
    
    public var textStyle: Font.TextStyle {
        switch self {
        case .small:                return .footnote
        case .normal:               return .body
        case .large:                return .callout
        case .xLarge:
            if #available(iOS 14.0, *) {
                return .title3
            } else {
                return .callout
            }
        case .custom:               return .body
        }
    }
    
    public var lineHeight: CGFloat {
        switch self {
        case .small:                return 16
        case .normal:               return 20
        case .large:                return 24
        case .xLarge:               return 24
        case .custom(let size):     return size * 1.31
        }
    }
    
    public var iconSize: CGFloat {
        switch self {
        case .large:                return 22
        default:                    return lineHeight
        }
    }
}
    
public enum TextColor: Equatable {
    case inkDark
    case inkNormal
    case white
    case custom(UIColor)
    
    public var value: SwiftUI.Color {
        SwiftUI.Color(uiValue)
    }
    
    public var uiValue: UIColor {
        switch self {
        case .inkDark:              return .inkDark
        case .inkNormal:            return .inkNormal
        case .white:                return .whiteNormal
        case .custom(let color):    return color
        }
    }
}


// MARK: - Constants
extension Text {
    
    // Alignment ratio for text size.
    public static var firstBaselineRatio: CGFloat { 0.26 }
}
