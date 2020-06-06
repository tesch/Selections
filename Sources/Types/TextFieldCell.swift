//
// TextFieldCell.swift
//
// Created by Marcel Tesch on 2020-06-06.
// Think different.
//

import Cocoa

class TextFieldCell: NSTextFieldCell {

    private static var fieldEditor: FieldEditor?

    override func fieldEditor(for view: NSView) -> NSTextView? {
        guard view is TextField else { return nil }

        if Self.fieldEditor == nil {
            Self.fieldEditor = .init()

            Self.fieldEditor?.isFieldEditor = true
        }

        return Self.fieldEditor
    }

}
