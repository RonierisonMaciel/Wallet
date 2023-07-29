import SwiftUI

struct UIWindowSceneKey: EnvironmentKey {
    static var defaultValue: UIWindowScene? = nil
}

extension EnvironmentValues {
    var windowScene: UIWindowScene? {
        get { self[UIWindowSceneKey.self] }
        set { self[UIWindowSceneKey.self] = newValue }
    }
}
