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
        .custom(name, size: size, relativeTo: style)
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
        case .extraSmall:                           return 0.8
        case .small:                                return 0.85
        case .medium:                               return 0.9
        case .large:                                return 1   // Default
        case .extraLarge:                           return 1.1
        case .extraExtraLarge:                      return 1.2
        case .extraExtraExtraLarge:                 return 1.35
        case .accessibilityMedium:                  return 1.6
        case .accessibilityLarge:                   return 1.9
        case .accessibilityExtraLarge:              return 2.35
        case .accessibilityExtraExtraLarge:         return 2.75
        case .accessibilityExtraExtraExtraLarge:    return 3.1
        @unknown default:                           return 1
        }
    }
    
    /// Effective size ratio for controls, based on font size ratio.
    /// The ratio is smaller than font size ratio and should be used for components or indicators that are already large enough.
    var controlRatio: CGFloat {
        1 + (ratio - 1) * 0.5
    }
}
