//
// FieldEditor.swift
//
// Created by Marcel Tesch on 2020-06-05.
// Think different.
//

import Cocoa

class FieldEditor: NSTextView {

    override var acceptableDragTypes: [NSPasteboard.PasteboardType] { [] }

}

extension FieldEditor {

    override func insertNewlineIgnoringFieldEditor(_ sender: Any?) {

    }

    override func paste(_ sender: Any?) {
        guard let items = NSPasteboard.general.pasteboardItems, items.count == 1 else { return }

        guard let text = items.first?.string(forType: .string) else { return }

        insertText(text.replacingOccurrences(of: "\n", with: " "), replacementRange: selectedRange())
    }

}
