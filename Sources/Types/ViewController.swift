//
// ViewController.swift
//
// Created by Marcel Tesch on 2020-06-05.
// Think different.
//

import Cocoa

class ViewController: NSViewController, NSTextFieldDelegate {

    @IBOutlet weak var pathField: PathField!

    @IBOutlet weak var patternField: TextField!

    let selectionMenu: SelectionMenu<String> = .init()

}

extension ViewController {

    @IBAction func selectDirectory(_ sender: Any) {
        let dialog = NSOpenPanel()

        dialog.canChooseFiles = false
        dialog.canChooseDirectories = true
        dialog.canCreateDirectories = true
        dialog.resolvesAliases = false
        dialog.allowsMultipleSelection = false

        dialog.beginSheetModal(for: view.window!) { result in
            if result == .OK {
                self.pathField.url = dialog.url
            }
        }
    }

}

extension ViewController {

    func showAlert(title: String, text: String, style: NSAlert.Style = .informational) {
        let alert = NSAlert()

        alert.messageText = title
        alert.informativeText = text
        alert.alertStyle = style

        alert.beginSheetModal(for: view.window!)
    }

    @IBAction func createSelection(_ sender: Any) {
        guard let contents = pathField.url?.contentsOfDirectory(includeHiddenFiles: Preferences.includeHiddenFiles) else {
            showAlert(title: "Invalid Path", text: "The given path does not correspond to an existing directory.", style: .critical)

            return
        }

        guard !contents.isEmpty else {
            showAlert(title: "Empty Directory", text: "The given directory does not contain any items.")

            return
        }

        let selection = contents.select(with: patternField.stringValue)

        guard !selection.isEmpty else {
            showAlert(title: "Empty Selection", text: "The given pattern does not match any items.")

            return
        }

        NSWorkspace.shared.activateFileViewerSelecting(selection)
    }

}

extension ViewController {

    func locationOfMenu(offset: Int, in textView: NSTextView) -> NSPoint? {
        guard let cursorIndex = textView.cursorStringIndex else { return nil }

        let index = textView.string.index(cursorIndex, offsetBy: offset)

        guard let rect = textView.characterRect(at: index) else { return nil }

        return .init(x: rect.origin.x - 21, y: rect.origin.y + rect.height + 13)
    }

    func showMenu(prefix: String, completions: Array<String>, for textView: NSTextView) -> String? {
        defer { selectionMenu.removeAllItems() }

        guard let location = locationOfMenu(offset: -prefix.count, in: textView) else { return nil }

        for completion in completions.sorted() {
            let title = NSAttributedString(string: prefix + completion, attributes: textView.typingAttributes)

            selectionMenu.addItem(title: title, value: completion)
        }

        return selectionMenu.selectItem(at: location, in: textView)
    }

    func control(_ control: NSControl, textView: NSTextView, doCommandBy selector: Selector) -> Bool {
        switch selector {
        case #selector(insertNewline):
            textView.insertTab(self)

        case #selector(insertTab):
            pathField.updatePartialString { prefixPath, suffixPath in
                guard let url = URL(fileURLWithAbsolutePath: prefixPath.expandingTilde) else { return "" }

                let (prefix, prediction, completions) = url.predictDirectoryPaths(hasTrailingSlash: prefixPath.hasSuffix("/"), includeHiddenFiles: Preferences.includeHiddenFiles)

                let suffix = suffixPath.hasPrefix("/") ? "" : "/"

                if completions.count > 1, let completion = showMenu(prefix: prefix, completions: completions, for: textView) {
                    return completion + suffix
                } else if completions.count == 1 {
                    return prediction + suffix
                }

                return ""
            }

        default:
            textView.perform(selector, with: self)
        }

        return true
    }

}
