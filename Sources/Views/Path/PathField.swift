//
// PathField.swift
//
// Created by Marcel Tesch on 2020-06-05.
// Think different.
//

import Cocoa

class PathField: TextField {

    func updateString(with string: String, in range: Range<String.Index>) {
        activateWithFieldEditor { fieldEditor in
            let range = NSRange(range, in: stringValue)

            let attributedString = NSAttributedString(string: string, attributes: fieldEditor.typingAttributes)

            guard fieldEditor.shouldChangeText(in: range, replacementString: string) else { fatalError() }

            fieldEditor.textStorage?.replaceCharacters(in: range, with: attributedString)

            fieldEditor.didChangeText()

            fieldEditor.scrollRangeToVisible(.init(location: range.location + attributedString.length, length: 0))
        }
    }

    func updateString(with string: String, at index: String.Index) {
        updateString(with: string, in: index ..< index)
    }

    func replaceString(with string: String) {
        updateString(with: string, in: stringValue.startIndex ..< stringValue.endIndex)
    }

}

extension PathField {

    var url: URL? {
        get {
            return URL(fileURLWithAbsolutePath: stringValue.expandingTilde)
        }
        set(url) {
            guard let string = url?.path.abbreviatingTilde else { return }

            replaceString(with: string + "/")
        }
    }

}

extension PathField {

    func updatePartialString(_ block: (_ prefixPath: String, _ suffixPath: String) -> String) {
        guard let cursorIndex = cursorIndex else { return }

        let prefixPath = String(stringValue[stringValue.startIndex ..< cursorIndex])

        let suffixPath = String(stringValue[cursorIndex ..< stringValue.endIndex])

        let string = block(prefixPath, suffixPath)

        if !string.isEmpty {
            updateString(with: string, at: cursorIndex)
        }
    }

}
