import Carbon
import Foundation

let sources = TISCreateInputSourceList(nil, true).takeRetainedValue()
print("count=\(CFArrayGetCount(sources))")
for index in 0..<CFArrayGetCount(sources) {
    let source = unsafeBitCast(CFArrayGetValueAtIndex(sources, index), to: TISInputSource.self)
    func string(_ key: CFString) -> String? {
        guard let value = TISGetInputSourceProperty(source, key) else { return nil }
        return unsafeBitCast(value, to: CFString.self) as String
    }
    let id = string(kTISPropertyInputSourceID) ?? ""
    let bundleID = string(kTISPropertyBundleID) ?? ""
    if id.localizedCaseInsensitiveContains("wenmo") ||
       bundleID.localizedCaseInsensitiveContains("wenmo") ||
       id.contains("fm619") || bundleID.contains("fm619") {
        print("id=\(id) bundle=\(bundleID)")
    }
}
