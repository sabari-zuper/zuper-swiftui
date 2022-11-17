import UIKit
import SwiftUI

var zuperFontNames: [Font.Weight: String] = [:]

public extension Font {

    /// Fonts used for rendering text in Zuper.
    static var zuperFonts: [Font.Weight: URL?] = [
        .regular: Bundle.current.url(forResource: "Zuper-Regular.otf", withExtension: nil),
        .medium: Bundle.current.url(forResource: "Zuper-Medium.otf", withExtension: nil),
        .semibold: Bundle.current.url(forResource: "Zuper-SemiBold.otf", withExtension: nil),
        .bold: Bundle.current.url(forResource: "Zuper-Bold.otf", withExtension: nil)
    ]

    /// Creates Zuper font.
    static func zuper(size: CGFloat, scaledSize: CGFloat, weight: Weight = .regular, style: Font.TextStyle = .body) -> Font {

        if zuperFontNames.isEmpty {
            return nonScalingSystemFont(size: scaledSize, weight: weight)
        }

        guard let fontName = zuperFontNames[weight] else {
            assertionFailure("Unsupported font weight")
            return nonScalingSystemFont(size: scaledSize, weight: weight)
        }

        return customFont(fontName, size: size, style: style)
    }
    
    /// Registers Zuper fonts set in the `zuperTextFonts` property
    static func registerZuperFonts() {

        if let iconsFontURL = Bundle.current.url(forResource: "Icons.ttf", withExtension: nil) {
            _ = registerFont(at: iconsFontURL)
        }

        for case let (weight, url?) in zuperFonts {
            guard let font = registerFont(at: url) else { continue }

            zuperFontNames[weight] = font.postScriptName as String?
        }
    }

    static func registerFont(at url: URL) -> CGFont? {

        guard let data = try? Data(contentsOf: url),
              let dataProvider = CGDataProvider(data: data as CFData),
              let font = CGFont(dataProvider)
        else {
            fatalError("Unable to load custom font from \(url)")
        }

        var error: Unmanaged<CFError>?
        if CTFontManagerRegisterGraphicsFont(font, &error) == false {
            print("Custom font registration error: \(String(describing: error))")
        }

        return font
    }

    private static func nonScalingSystemFont(size: CGFloat, weight: Font.Weight) -> Font {
        .system(size: size, weight: weight)
    }

    private static func customFont(_ name: String, size: CGFloat, style: Font.TextStyle = .body) -> Font {
        if #available(iOS 14.0, *) {
            return .custom(name, size: size, relativeTo: style)
        } else {
            return .custom(name, size: size)
        }
    }
}

extension Font.Weight {

    var uiKit: UIFont.Weight {
        switch self {
        case .regular:  return .regular
        case .bold:     return .bold
        case .medium:   return .medium
        case .semibold:     return .semibold
        default:        return .regular
        }
    }
}

public extension ContentSizeCategory {
    
    /// Effective font size ratio.
    var ratio: CGFloat {
        switch self {
        case .extraSmall:                           return UIDevice.current.userInterfaceIdiom == .phone ? 0.8 : 0.85
        case .small:                                return UIDevice.current.userInterfaceIdiom == .phone ? 0.85 : 0.9
        case .medium:                               return UIDevice.current.userInterfaceIdiom == .phone ? 0.9 : 1
        case .large:                                return UIDevice.current.userInterfaceIdiom == .phone ? 1 : 1.1        // Default
        case .extraLarge:                           return UIDevice.current.userInterfaceIdiom == .phone ? 1.1 : 1.2
        case .extraExtraLarge:                      return UIDevice.current.userInterfaceIdiom == .phone ? 1.2 : 1.3
        case .extraExtraExtraLarge:                 return UIDevice.current.userInterfaceIdiom == .phone ? 1.35 : 1.5
        case .accessibilityMedium:                  return UIDevice.current.userInterfaceIdiom == .phone ? 1.6 : 1.8
        case .accessibilityLarge:                   return UIDevice.current.userInterfaceIdiom == .phone ? 1.9 : 2.1
        case .accessibilityExtraLarge:              return UIDevice.current.userInterfaceIdiom == .phone ? 2.35 : 2.5
        case .accessibilityExtraExtraLarge:         return UIDevice.current.userInterfaceIdiom == .phone ? 2.75 : 3.0
        case .accessibilityExtraExtraExtraLarge:    return UIDevice.current.userInterfaceIdiom == .phone ? 3.1 : 3.2
        @unknown default:                           return UIDevice.current.userInterfaceIdiom == .phone ? 1 : 1.1
        }
    }
    
    /// Effective size ratio for controls, based on font size ratio.
    /// The ratio is smaller than font size ratio and should be used for components or indicators that are already large enough.
    var controlRatio: CGFloat {
        1 + (ratio - 1) * 0.5
    }
    
    @available(iOS, deprecated: 15.0, message: "Use DynamicTypeSize.isAccessibilitySize instead from iOS 15.0")
    var isAccessibilitySize: Bool {
        ratio >= 1.6
    }
}
