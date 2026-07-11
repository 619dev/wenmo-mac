import AppKit
import InputMethodKit

@main
enum WenmoMain {
    static func main() {
        let connectionName = Bundle.main.object(forInfoDictionaryKey: "InputMethodConnectionName") as? String
            ?? "com.fm619.wenmo.mac.inputmethod"
        _ = IMKServer(name: connectionName, bundleIdentifier: Bundle.main.bundleIdentifier)
        NSApplication.shared.run()
    }
}
