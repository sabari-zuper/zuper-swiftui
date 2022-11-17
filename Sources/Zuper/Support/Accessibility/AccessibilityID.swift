import SwiftUI

/// Zuper accessibility identifier for use in wrapper components.
public enum AccessibilityID: String {
    case alertButtonPrimary             = "zuper.alert.button.primary"
    case alertButtonSecondary           = "zuper.alert.button.secondary"
    case alertTitle                     = "zuper.alert.title"
    case alertIcon                      = "zuper.alert.icon"
    case alertDescription               = "zuper.alert.description"
    case cardTitle                      = "zuper.card.title"
    case cardIcon                       = "zuper.card.icon"
    case cardDescription                = "zuper.card.description"
    case cardActionButtonLink           = "zuper.card.action.buttonLink"
    case checkboxTitle                  = "zuper.checkbox.title"
    case checkboxDescription            = "zuper.checkbox.description"
    case choiceTileTitle                = "zuper.choicetile.title"
    case choiceTileIcon                 = "zuper.choicetile.icon"
    case choiceTileDescription          = "zuper.choicetile.description"
    case choiceTileBadge                = "zuper.choicetile.badge"
    case dialogTitle                    = "zuper.dialog.title"
    case dialogDescription              = "zuper.dialog.description"
    case dialogButtonPrimary            = "zuper.dialog.button.primary"
    case dialogButtonSecondary          = "zuper.dialog.button.secondary"
    case dialogButtonTertiary           = "zuper.dialog.button.tertiary"
    case emptyStateTitle                = "zuper.emptystate.title"
    case emptyStateDescription          = "zuper.emptystate.description"
    case emptyStateButton               = "zuper.emptystate.button"
    case fieldLabel                     = "zuper.field.label"
    case fieldMessage                   = "zuper.field.message"
    case fieldMessageIcon               = "zuper.field.message.icon"
    case inputPrefix                    = "zuper.input.prefix"
    case inputSuffix                    = "zuper.input.suffix"
    case inputValue                     = "zuper.input.value"
    case inputFieldPasswordToggle       = "zuper.inputfield.password.toggle"
    case keyValueKey                    = "zuper.keyvalue.key"
    case keyValueValue                  = "zuper.keyvalue.value"
    case listChoiceTitle                = "zuper.listchoice.title"
    case listChoiceIcon                 = "zuper.listchoice.icon"
    case listChoiceDescription          = "zuper.listchoice.description"
    case listChoiceValue                = "zuper.listchoice.value"
    case passwordStrengthIndicator      = "zuper.passwordstrengthindicator"
    case radioTitle                     = "zuper.radio.title"
    case radioDescription               = "zuper.radio.description"
    case tileTitle                      = "zuper.tile.title"
    case tileIcon                       = "zuper.tile.icon"
    case tileDescription                = "zuper.tile.description"
    case tileDisclosureButtonLink       = "zuper.tile.disclosure.buttonlink"
    case tileDisclosureIcon             = "zuper.tile.disclosure.icon"
}

extension View {

    /// Uses the specified Zuper identifier to identify the view inside a component.
    func accessibility(_ identifier: AccessibilityID) -> some View {
        self.accessibility(identifier: identifier.rawValue)
    }
}
