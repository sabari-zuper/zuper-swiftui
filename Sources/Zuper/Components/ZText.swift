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
public struct ZText: View {
    
    @Environment(\.sizeCategory) var sizeCategory
    
    let content: String
    let size: Text.Size
    let color: Text.Color?
    let weight: Font.Weight
    let lineSpacing: CGFloat?
    let alignment: TextAlignment
    let kerning: CGFloat
    let strikethrough: Bool
    let lineLimit: Int?
    
    public var body: some View {
        if !content.isEmpty {
            SwiftUI.Text(content)
                .zuperFont(
                    size: size.value,
                    weight: weight,
                    style: size.textStyle,
                    sizeCategory: sizeCategory
                )
                .foregroundColor(foregroundColor)
                .multilineTextAlignment(alignment)
                .lineSpacing(lineSpacing ?? 0)
                .kerning(kerning)
                .strikethrough(strikethrough, color: foregroundColor)
        }
    }
    
    private var foregroundColor: SwiftUI.Color {
        color?.value ?? .primary
    }
}

// MARK: - Inits (Same API as your original Text component)
public extension ZText {
    
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
        size: Text.Size = .normal,
        color: Text.Color? = .inkDark,
        weight: Font.Weight = .regular,
        lineSpacing: CGFloat? = nil,
        alignment: TextAlignment = .leading,
        kerning: CGFloat = 0,
        strikethrough: Bool = false,
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
