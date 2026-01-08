import SwiftUI

/// Consistent spacing makes an interface more clear and easy to scan.
///
/// Spacing values are based on a 4-pixel grid, aligned with Apple Human Interface Guidelines.
///
/// ## Apple HIG Spacing Guidelines
/// - **Compact (4pt)**: Tight spacing between related elements
/// - **Default (8pt)**: Standard spacing for related items
/// - **Related (12pt)**: Spacing between grouped elements
/// - **Standard (16pt)**: Section padding, screen margins
/// - **Comfortable (20pt)**: Card padding, comfortable spacing
/// - **Spacious (24pt)**: Major section breaks
/// - **Touch Target (44pt)**: Minimum touch target size per Apple HIG
///
public enum Spacing: CGFloat {

    // MARK: - Core Spacing Values (4pt Grid)

    /// 2 pts - Micro spacing for tight layouts.
    case xxxSmall = 2

    /// 4 pts - Compact spacing between tightly related elements.
    /// Also available as `.compact`.
    case xxSmall = 4

    /// 8 pts - Default spacing for related items.
    case xSmall = 8

    /// 12 pts - Spacing between grouped/related elements.
    case small = 12

    /// 16 pts - Standard section padding, screen margins.
    /// Also available as `.standard`.
    case medium = 16

    /// 20 pts - Comfortable spacing for cards and content areas.
    /// Also available as `.comfortable`.
    case xMedium = 20

    /// 24 pts - Spacious padding for major sections.
    case large = 24

    /// 32 pts - Extra large spacing for significant visual breaks.
    case xLarge = 32

    /// 44 pts - Apple HIG minimum touch target size.
    /// Also available as `.touchTarget`.
    case xxLarge = 44

    /// 60 pts - Hero/featured content spacing.
    case xxxLarge = 60

    // MARK: - Semantic Aliases (Apple HIG)

    /// 4 pts - Compact spacing for tightly related elements.
    public static let compact: Spacing = .xxSmall

    /// 16 pts - Standard padding per Apple HIG (screen margins, section padding).
    public static let standard: Spacing = .medium

    /// 20 pts - Comfortable spacing for cards and content areas.
    public static let comfortable: Spacing = .xMedium

    /// 44 pts - Minimum touch target size per Apple Human Interface Guidelines.
    public static let touchTarget: Spacing = .xxLarge

    // MARK: - Deprecated

    /// 14 pts.
    /// - Note: Deprecated because 14pt is not on the 4pt grid.
    @available(*, deprecated, renamed: "small", message: "Use .small (12pt) or .medium (16pt) for 4pt grid alignment")
    case normal = 14
}

public extension CGFloat {

    // MARK: - Core Spacing Values

    /// 2 pts - Micro spacing for tight layouts.
    static let xxxSmall = Spacing.xxxSmall.rawValue

    /// 4 pts - Compact spacing between tightly related elements.
    static let xxSmall = Spacing.xxSmall.rawValue

    /// 8 pts - Default spacing for related items.
    static let xSmall = Spacing.xSmall.rawValue

    /// 12 pts - Spacing between grouped/related elements.
    static let small = Spacing.small.rawValue

    /// 16 pts - Standard section padding, screen margins.
    static let medium = Spacing.medium.rawValue

    /// 20 pts - Comfortable spacing for cards and content areas.
    static let xMedium = Spacing.xMedium.rawValue

    /// 24 pts - Spacious padding for major sections.
    static let large = Spacing.large.rawValue

    /// 32 pts - Extra large spacing for significant visual breaks.
    static let xLarge = Spacing.xLarge.rawValue

    /// 44 pts - Apple HIG minimum touch target size.
    static let xxLarge = Spacing.xxLarge.rawValue

    /// 60 pts - Hero/featured content spacing.
    static let xxxLarge = Spacing.xxxLarge.rawValue

    // MARK: - Semantic Aliases (Apple HIG)

    /// 4 pts - Compact spacing for tightly related elements.
    static let compact = Spacing.compact.rawValue

    /// 16 pts - Standard padding per Apple HIG (screen margins, section padding).
    static let standard = Spacing.standard.rawValue

    /// 20 pts - Comfortable spacing for cards and content areas.
    static let comfortable = Spacing.comfortable.rawValue

    /// 44 pts - Minimum touch target size per Apple Human Interface Guidelines.
    static let touchTarget = Spacing.touchTarget.rawValue

    // MARK: - Deprecated

    /// 14 pts.
    @available(*, deprecated, message: "Use .small (12pt) or .medium (16pt) for 4pt grid alignment")
    static let normal = Spacing.normal.rawValue
}
