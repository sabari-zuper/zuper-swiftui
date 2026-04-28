import CoreGraphics

/// Defines Zuper border radiuses.
public enum BorderRadius {
    /// 3 pts border radius.
    public static let desktop: CGFloat = 3
    /// 6 pts border radius.
    public static let `default`: CGFloat = 6
    /// 10 pts border radius for text inputs and form fields (HIG-aligned).
    public static let input: CGFloat = 10
    /// 16 pts border radius.
    public static let large: CGFloat = 16
    /// 22 pts border radius (capsule-like, reserved for chips and pills).
    public static let iOS26: CGFloat = 22
}
