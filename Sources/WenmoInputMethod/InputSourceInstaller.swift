import Carbon
import Foundation

enum WenmoInputSourceInstaller {
    static let bundleID = "com.fm619.wenmo.inputmethod.Wenmo"
    static let inputModeSuffix = ".Wenmo.Hans"

    static func register() -> OSStatus {
        TISRegisterInputSource(Bundle.main.bundleURL as CFURL)
    }

    static func enable() -> OSStatus {
        guard let source = inputSource() else { return OSStatus(fnfErr) }
        return TISEnableInputSource(source)
    }

    static func select() -> OSStatus {
        guard let source = inputSource() else { return OSStatus(fnfErr) }
        return TISSelectInputSource(source)
    }

    private static func inputSource() -> TISInputSource? {
        let sources = TISCreateInputSourceList(nil, true).takeRetainedValue()
        for index in 0..<CFArrayGetCount(sources) {
            let source = unsafeBitCast(CFArrayGetValueAtIndex(sources, index), to: TISInputSource.self)
            guard
                let idRef = TISGetInputSourceProperty(source, kTISPropertyInputSourceID),
                let bundleRef = TISGetInputSourceProperty(source, kTISPropertyBundleID)
            else { continue }
            let sourceID = unsafeBitCast(idRef, to: CFString.self) as String
            let sourceBundleID = unsafeBitCast(bundleRef, to: CFString.self) as String
            if sourceBundleID == bundleID, sourceID.hasSuffix(inputModeSuffix) { return source }
        }
        return nil
    }
}
