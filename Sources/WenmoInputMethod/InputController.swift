import AppKit
import InputMethodKit

@objc(WenmoInputController)
final class InputController: IMKInputController {
    private lazy var engine = InputEngine(dictionaryURL: Bundle.main.url(
        forResource: "cedict_pinyin", withExtension: "tsv"
    ))
    private lazy var candidateWindow: IMKCandidates? = IMKCandidates(
        server: server(), panelType: kIMKSingleColumnScrollingCandidatePanel
    )

    override func activateServer(_ sender: Any!) {
        super.activateServer(sender)
        guard let sender else { return }
        updateMarkedText(sender)
    }

    override func deactivateServer(_ sender: Any!) {
        if let sender { commitRawComposition(sender) }
        candidateWindow?.hide()
        super.deactivateServer(sender)
    }

    override func handle(_ event: NSEvent!, client sender: Any!) -> Bool {
        guard let event, let sender else { return false }
        guard event.type == .keyDown else { return false }
        let modifiers = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
        if !modifiers.intersection([.command, .control, .option]).isEmpty { return false }

        switch event.keyCode {
        case 51: // delete
            guard !engine.composition.isEmpty else { return false }
            engine.backspace(); refresh(sender); return true
        case 36, 76: // return
            guard !engine.composition.isEmpty else { return false }
            commit(engine.candidates.first ?? engine.composition, sender: sender); return true
        case 49: // space
            guard !engine.composition.isEmpty else { return false }
            commit(engine.candidates.first ?? engine.composition, sender: sender); return true
        case 53: // escape
            guard !engine.composition.isEmpty else { return false }
            engine.clear(); refresh(sender); return true
        default: break
        }

        guard let characters = event.characters?.lowercased(), characters.count == 1,
              let character = characters.first, character.isASCII, character.isLetter else {
            if !engine.composition.isEmpty, let text = event.characters, !text.isEmpty {
                commit(engine.candidates.first ?? engine.composition, sender: sender)
            }
            return false
        }
        engine.type(character)
        refresh(sender)
        return true
    }

    override func candidates(_ sender: Any!) -> [Any]! { engine.candidates }

    override func candidateSelected(_ candidateString: NSAttributedString!) {
        guard let client = client(), let candidateString else { return }
        commit(candidateString.string, sender: client)
    }

    @objc private func toggleScript() {
        engine.script = engine.script == .simplified ? .traditional : .simplified
        if let client = client() { refresh(client) }
    }

    override func menu() -> NSMenu! {
        let menu = NSMenu(title: "问墨")
        let title = engine.script == .simplified ? "切换为繁体" : "切换为简体"
        let item = NSMenuItem(title: title, action: #selector(toggleScript), keyEquivalent: "")
        item.target = self
        menu.addItem(item)
        return menu
    }

    private func refresh(_ sender: Any) {
        updateMarkedText(sender)
        if engine.composition.isEmpty || engine.candidates.isEmpty {
            candidateWindow?.hide()
        } else {
            candidateWindow?.update()
            candidateWindow?.show()
        }
    }

    private func updateMarkedText(_ sender: Any) {
        guard let client = sender as? IMKTextInput else { return }
        let text = NSAttributedString(string: engine.composition)
        client.setMarkedText(text, selectionRange: NSRange(location: text.length, length: 0),
                             replacementRange: NSRange(location: NSNotFound, length: NSNotFound))
    }

    private func commit(_ text: String, sender: Any) {
        guard let client = sender as? IMKTextInput else { return }
        client.insertText(text, replacementRange: NSRange(location: NSNotFound, length: NSNotFound))
        engine.clear()
        refresh(sender)
    }

    private func commitRawComposition(_ sender: Any) {
        guard !engine.composition.isEmpty else { return }
        commit(engine.composition, sender: sender)
    }
}
