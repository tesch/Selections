//
// NSTextField.swift
//
// Created by Marcel Tesch on 2020-06-05.
// Think different.
//

import Cocoa

extension NSTextField {

    var isActive: Bool {
        guard let firstResponder = window?.firstResponder as? NSText, let delegate = firstResponder.delegate as? NSTextField else { return false }

        return self == delegate
    }

}

extension NSTextField {

    var fieldEditor: NSTextView? { currentEditor() as? NSTextView }

}

extension NSTextField {

    var selectedRange: Range<String.Index>? { fieldEditor?.selectedStringRange }

    var cursorIndex: String.Index? { fieldEditor?.cursorStringIndex }

}
