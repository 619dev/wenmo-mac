import AppKit
import InputMethodKit

@main
enum WenmoMain {
    static func main() {
        switch CommandLine.arguments.dropFirst().first {
        case "--register-input-source":
            exit(with: WenmoInputSourceInstaller.register(), operation: "register")
        case "--enable-input-source":
            exit(with: WenmoInputSourceInstaller.enable(), operation: "enable")
        case "--select-input-source":
            exit(with: WenmoInputSourceInstaller.select(), operation: "select")
        default:
            break
        }

        let connectionName = Bundle.main.object(forInfoDictionaryKey: "InputMethodConnectionName") as? String
            ?? "com.fm619.wenmo.inputmethod.Wenmo_Connection"
        _ = IMKServer(name: connectionName, bundleIdentifier: Bundle.main.bundleIdentifier)
        NSApplication.shared.run()
    }

    private static func exit(with status: OSStatus, operation: String) -> Never {
        if status == noErr {
            print("Wenmo input source \(operation) succeeded")
            Foundation.exit(EXIT_SUCCESS)
        }
        fputs("Wenmo input source \(operation) failed: \(status)\n", stderr)
        Foundation.exit(EXIT_FAILURE)
    }
}
