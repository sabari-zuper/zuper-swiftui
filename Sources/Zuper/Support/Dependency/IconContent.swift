//
//  File.swift
//  
//
//  Created by SabariZuper on 17/11/22.
//

import Foundation
import SwiftUI
public extension Icon.Content {
    
    static let sort: Self = .sfSymbol("arrow.up.arrow.down", color: nil)
    static let notificationAdd: Self = .sfSymbol("bell", color: nil)
    static let money: Self = .sfSymbol("banknote.fill", color: nil)
    static let remove: Self = .sfSymbol("trash.fill", color: nil)
    static let circleEmpty: Self = .sfSymbol("circle", color: nil)
    static let checkCircle: Self = .sfSymbol("checkmark.circle.fill", color: nil)
    static let circleSmall: Self = .sfSymbol("circlebadge.fill", color: nil)
    static let check: Self = .sfSymbol("checkmark", color: nil)
    static let infoCircle: Self = .sfSymbol("info.circle.fill", color: nil)
    static let alert: Self = .sfSymbol("exclamationmark.triangle.fill", color: nil)
    static let alertCircle: Self = .sfSymbol("exclamationmark.circle.fill", color: nil)
    static let person: Self = .sfSymbol("person.fill", color: nil)
    static let lock: Self = .sfSymbol("lock.fill", color: nil)
    static let lockOpen: Self = .sfSymbol("lock.open.fill", color: nil)
    static let visibilityOn: Self = .sfSymbol("eye.fill", color: .inkNormal)
    static let visibilityOff: Self = .sfSymbol("eye.slash.fill", color: .inkNormal)
    static let email: Self = .sfSymbol("envelope.fill", color: .inkNormal)
    static let chevronDown: Self = .image(Image("ic_arrow_down",bundle:.current), mode: .fit)
    static let datePicker: Self = .sfSymbol("calendar", color: .inkNormal)
    static let chevron: Self = .image(Image("ic_arrow_down",bundle:.current), mode: .fit)
    static let chevronRight: Self = .sfSymbol("chevron.right", color: .inkNormal)
}

public func icon(_ iconContent: String, color: Color? = nil) -> Icon {
    return Icon(sfSymbol: iconContent, color: color)
}
