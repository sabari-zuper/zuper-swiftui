import SwiftUI

struct TimelineIndicator: View {

    public static let indicatorDiameter: CGFloat = Icon.Size.large.value

    @Environment(\.sizeCategory) var sizeCategory
    @Environment(\.accessibilityReduceMotion) var isReduceMotionEnabled

    let type: TimelineItemType

    @State var animationLoopTrigger = false

    var body: some View {
        indicator
            .frame(
                width: TimelineIndicator.indicatorDiameter * sizeCategory.ratio,
                height: TimelineIndicator.indicatorDiameter * sizeCategory.ratio
            )
            .alignmentGuide(.firstTextBaseline){ dimensions in
                iconContentBaselineOffset(height: dimensions.height)
            }
            .onAppear { animationLoopTrigger = !isReduceMotionEnabled }
    }

    @ViewBuilder var indicator: some View {
        switch type {
            case .future, .present(nil):
                icon
            case .present(.warning), .present(.critical), .present(.success):
                Circle()
                    .frame(
                        width: (animationLoopTrigger ? .medium : .xMedium) * sizeCategory.ratio,
                        height: (animationLoopTrigger ? .medium : .xMedium) * sizeCategory.ratio
                    )
                    .foregroundColor(animationLoopTrigger ? Color.clear : type.color.opacity(0.1))
                    .animation(animation, value: animationLoopTrigger)
                    .overlay(icon)
            case .past:
                Circle()
                    .foregroundColor(type.color.opacity(0.1))
                    .frame(width: .xMedium * sizeCategory.ratio, height: .xMedium * sizeCategory.ratio)
                    .overlay(icon)
        }
    }

    @ViewBuilder var icon: some View {
        switch type {
        case .future:
            Circle()
                .strokeBorder(type.color, lineWidth: 2)
                .background(Circle().fill(Color.whiteNormal))
                .frame(width: .small * sizeCategory.ratio, height: .small * sizeCategory.ratio)
        case .present(nil):
            ZStack(alignment: .center) {
                Circle()
                    .frame(
                        width: (animationLoopTrigger ? .medium : .xMedium) * sizeCategory.ratio,
                        height: (animationLoopTrigger ? .medium : .xMedium) * sizeCategory.ratio
                    )
                    .animation(animation, value: animationLoopTrigger)
                    .foregroundColor(type.color.opacity(0.1))
                
                Circle()
                    .strokeBorder(type.color, lineWidth: 2)
                    .background(Circle().fill(Color.whiteNormal))
                    .frame(width: .small * sizeCategory.ratio, height: .small * sizeCategory.ratio)
                
                Circle()
                    .frame(width: .xxSmall * sizeCategory.ratio, height: .xxSmall * sizeCategory.ratio)
                    .scaleEffect(animationLoopTrigger ? .init(width: 0.5, height: 0.5) : .init(width: 1, height: 1))
                    .foregroundColor(animationLoopTrigger ? Color.clear : type.color)
                    .animation(animation, value: animationLoopTrigger)
                
            }
        case .present(.warning), .present(.critical), .present(.success), .past:
            type.iconSymbol
                .background(Circle().fill(Color.whiteNormal).padding(2))
        }
    }

    var animation: Animation {
        Animation.easeInOut.repeatForever().speed(0.25)
    }

    func iconContentBaselineOffset(height: CGFloat) -> CGFloat {
        Icon.Size.small.textBaselineAlignmentGuide(sizeCategory: sizeCategory, height: height)
    }
}
