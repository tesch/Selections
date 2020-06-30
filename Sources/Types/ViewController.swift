//
// ViewController.swift
//
// Created by Marcel Tesch on 2020-06-05.
// Think different.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var pathField: PathField!

    @IBOutlet weak var patternField: TextField!

    private let menuController = MenuController<String>()

}

extension ViewController {

    @IBAction private func selectDirectory(_ sender: Any) {
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

    private func presentAlert(title: String, text: String, style: NSAlert.Style = .informational) {
        let alert = NSAlert()

        alert.messageText = title
        alert.informativeText = text
        alert.alertStyle = style

        alert.beginSheetModal(for: view.window!)
    }

    @IBAction private func createSelection(_ sender: Any) {
        guard let contents = pathField.url?.contentsOfDirectory(includeHiddenFiles: Preferences.includeHiddenFiles) else {
            presentAlert(title: "Invalid Path", text: "The given path does not correspond to an existing directory.", style: .critical)

            return
        }

        guard !contents.isEmpty else {
            presentAlert(title: "Empty Directory", text: "The given directory does not contain any items.")

            return
        }

        let selection = contents.select(with: patternField.stringValue)

        guard !selection.isEmpty else {
            presentAlert(title: "Empty Selection", text: "The given pattern does not match any items.")

            return
        }

        NSWorkspace.shared.activateFileViewerSelecting(selection)
    }

}

extension ViewController: NSTextFieldDelegate {

    func control(_ control: NSControl, textView: NSTextView, doCommandBy selector: Selector) -> Bool {
        switch selector {
        case #selector(insertNewline):
            textView.insertTab(self)

        case #selector(insertTab):
            pathField.updatePartialString { prefixPath, suffixPath in
                guard let url = URL(fileURLWithAbsolutePath: prefixPath.expandingTilde) else { return "" }

                let (prefix, prediction, completions) = url.predictDirectoryPaths(hasTrailingSlash: prefixPath.hasSuffix("/"), includeHiddenFiles: Preferences.includeHiddenFiles)

                let suffix = suffixPath.hasPrefix("/") ? "" : "/"

                var options = Dictionary<String, String>()

                for completion in completions {
                    options[prefix + completion] = completion
                }

                let offset = -prefix.count

                if completions.count > 1, let completion = menuController.presentMenu(withOptions: options, at: offset, for: textView) {
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
