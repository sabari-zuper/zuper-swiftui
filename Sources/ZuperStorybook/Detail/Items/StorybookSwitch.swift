import SwiftUI
import Zuper

struct StorybookSwitch {

    static var basic: some View {
        VStack(spacing: .large) {
            HStack(spacing: .large) {
                switchView(isOn: true)
                switchView(isOn: true, hasIcon: true)
                switchView(isOn: true, isEnabled: false)
                switchView(isOn: true, hasIcon: true, isEnabled: false)
            }
            HStack(spacing: .large) {
                switchView(isOn: false)
                switchView(isOn: false, hasIcon: true)
                switchView(isOn: false, isEnabled: false)
                switchView(isOn: false, hasIcon: true, isEnabled: false)
            }
        }
    }

    static func switchView(isOn: Bool, hasIcon: Bool = false, isEnabled: Bool = true) -> some View {
        StateWrapper(initialState: isOn) { isOnState in
            Switch(isOn: .constant(isOn), isEnabled: true)
        }
    }
}

struct StorybookSwitchPreviews: PreviewProvider {

    static var previews: some View {
        ZuperPreviewWrapper {
            StorybookSwitch.basic
        }
    }
}
