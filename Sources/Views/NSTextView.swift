//
// NSTextView.swift
//
// Created by Marcel Tesch on 2020-06-05.
// Think different.
//

import Cocoa

extension NSTextView {

    var selectedStringRange: Range<String.Index>? { Range(selectedRange, in: string) }

    var cursorStringIndex: String.Index? {
        guard let range = selectedStringRange, range.isEmpty else { return nil }

        return range.lowerBound
    }

}

extension NSTextView {

    func characterRect(at index: String.Index) -> CGRect? {
        guard let window = window else { return nil }

        let range = NSRange(index ..< index, in: string)

        let screenRect = firstRect(forCharacterRange: range, actualRange: nil)

        let windowRect = window.convertFromScreen(screenRect)

        return convert(windowRect, from: window.contentView)
    }

}
