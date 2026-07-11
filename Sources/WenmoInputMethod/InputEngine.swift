import Foundation

struct Candidate: Equatable {
    let simplified: String
    let traditional: String
}

final class InputEngine {
    enum Script { case simplified, traditional }

    private(set) var composition = ""
    var script: Script = .simplified
    private var index: [String: [Candidate]] = [:]

    init(dictionaryURL: URL?) {
        guard let dictionaryURL,
              let text = try? String(contentsOf: dictionaryURL, encoding: .utf8) else { return }
        for line in text.split(separator: "\n") where !line.hasPrefix("#") {
            let fields = line.split(separator: "\t", omittingEmptySubsequences: false)
            guard fields.count == 3 else { continue }
            let key = String(fields[0])
            guard index[key, default: []].count < 48 else { continue }
            index[key, default: []].append(Candidate(
                simplified: String(fields[1]),
                traditional: String(fields[2])
            ))
        }
    }

    func type(_ character: Character) {
        guard character.isASCII, character.isLowercase else { return }
        composition.append(character)
    }

    func backspace() { if !composition.isEmpty { composition.removeLast() } }
    func clear() { composition = "" }

    var candidates: [String] {
        (index[composition] ?? []).map {
            script == .simplified ? $0.simplified : $0.traditional
        }
    }
}
