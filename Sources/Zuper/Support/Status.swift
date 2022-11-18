import SwiftUI

/// Non-default status of a component.
public enum Status {

    case info
    case success
    case warning
    case critical

    /// Default icon associated with status.
    var icon: Icon.Content {
        switch self {
            case .info:         return .none
            case .success:      return .check
            case .warning:      return .alert
            case .critical:     return .alertCircle
        }
    }

    /// Default color associated with status.
    var color: Color {
        switch self {
            case .info:         return .blueNormal
            case .success:      return .greenNormal
            case .warning:      return .orangeNormal
            case .critical:     return .redNormal
        }
    }
}
