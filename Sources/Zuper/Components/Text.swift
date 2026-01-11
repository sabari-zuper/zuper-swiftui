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
        size: TextSize = .normal,
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
            return .title3
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
