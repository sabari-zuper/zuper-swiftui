import UIKit
import SwiftUI

public extension UIFont {

    enum Size: Int, Comparable {

        // MARK: Text

        /// Size 12. Equals to `Title 5`.
        case small = 12
        /// Size 14. Equals to `Title 4`.
        case normal = 14
        /// Size 16. Equals to `Title 3`.
        case large = 16
        /// Size 12
        static let body3 = Size.small
        /// Size 14
        static let body2 = Size.normal
        /// Size 16
        static let body1 = Size.large
        /// Size 16
        static let h6 = Size.large

        // MARK: Headings

        /// Size 18..
        case xLarge = 18
        /// Size 18..
        static let h5 = Size.xLarge
        
        /// Size 20..
        static let h4 = 20

        /// Size 22. Equals to `Display Subtitle`.
        case title2 = 22
        
        /// Size 24..
        static let h3 = 24
      
        /// Size 28.
        case title1 = 28
        /// Size 28
        static let h2 = Size.title1
        
        /// Size 36.
        case displayTitle = 36
        /// Size 36
        static let h1 = Size.displayTitle

        // MARK: iOS Specific
        /// Size 11.
        case tabBar = 11
        /// Size 17.
        case navigationBar = 17

        public static func < (lhs: Size, rhs: Size) -> Bool {
            lhs.rawValue < rhs.rawValue
        }

        public var cgFloat: CGFloat {
            CGFloat(self.rawValue)
        }
    }

    /// Creates Zuper font.
    static func zuper(size: Size = .normal, weight: Weight = .regular) -> UIFont {
        zuper(size: size.cgFloat, weight: weight)
    }

    static var zuper: UIFont {
        zuper()
    }
}

extension UIFont {

    static func zuper(size: CGFloat, weight: Weight = .regular) -> UIFont {

        if zuperFontNames.isEmpty {
            return .systemFont(ofSize: size, weight: weight)
        }

        guard let fontName = zuperFontNames[weight.swiftUI], let font = UIFont(name: fontName, size: size) else {
            assertionFailure("Unsupported font weight")
            return .systemFont(ofSize: size, weight: weight)
        }

        return font
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
