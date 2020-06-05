//
// TextField.swift
//
// Created by Marcel Tesch on 2020-06-05.
// Think different.
//

import Cocoa

class TextField: NSTextField, NSTextViewDelegate {

    let uniqueUndoManager = UndoManager()

    func undoManager(for view: NSTextView) -> UndoManager? {
        return uniqueUndoManager
    }

}

extension TextField {

    func activateWithFieldEditor(_ block: (NSTextView) -> ()) {
        if !isActive {
            guard window!.makeFirstResponder(self) else { fatalError() }
        }

        block(fieldEditor!)
    }

}
