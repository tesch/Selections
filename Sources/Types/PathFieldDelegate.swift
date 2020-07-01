//
// PathFieldDelegate.swift
//
// Created by Marcel Tesch on 2020-06-02.
// Think different.
//

import Cocoa

class PathFieldDelegate: TextFieldDelegate {

    private func performCompletion(for textView: NSTextView) {
        viewController.pathField.updatePartialString { prefixPath, suffixPath in
            guard let url = URL(fileURLWithAbsolutePath: prefixPath.expandingTilde) else { return "" }

            let (prefix, prediction, completions) = url.predictDirectoryPaths(hasTrailingSlash: prefixPath.hasSuffix("/"), includeHiddenFiles: Preferences.includeHiddenFiles)

            let suffix = suffixPath.hasPrefix("/") ? "" : "/"

            var options = Dictionary<String, String>()

            for completion in completions {
                options[prefix + completion] = completion
            }

            let offset = -prefix.count

            if completions.count > 1, let completion = viewController.menuController.presentMenu(withOptions: options, at: offset, for: textView) {
                return completion + suffix
            } else if completions.count == 1 {
                return prediction + suffix
            }

            return ""
        }
    }

    func control(_ control: NSControl, textView: NSTextView, doCommandBy selector: Selector) -> Bool {
        switch selector {
        case #selector(textView.insertNewline):
            textView.insertTab(self)
        case #selector(textView.insertTab):
            performCompletion(for: textView)
        default:
            textView.perform(selector, with: self)
        }

        return true
    }

}
