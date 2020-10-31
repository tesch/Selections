//
// MenuController.swift
//
// Created by Marcel Tesch on 2020-06-02.
// Think different.
//

import Cocoa

class MenuController<Element> {

    private let menu = Menu<Element>()

}

extension MenuController {

    private func menuLocation(at offset: Int, in textView: NSTextView) -> NSPoint? {
        guard let cursorIndex = textView.cursorStringIndex else { return nil }

        let index = textView.string.index(cursorIndex, offsetBy: offset)

        guard let rect = textView.characterRect(at: index) else { return nil }

        return .init(x: rect.origin.x - 21, y: rect.origin.y + rect.height + 13)
    }

    func presentMenu(withOptions options: Dictionary<String, Element>, at offset: Int, for textView: NSTextView) -> Element? {
        defer { menu.removeAllItems() }

        guard let location = menuLocation(at: offset, in: textView) else { return nil }

        let block: (String, String) -> Bool = { lhs, rhs in lhs.localizedStandardCompare(rhs) == .orderedAscending }

        for title in options.keys.sorted(by: block) {
            guard let value = options[title] else { continue }

            let title = NSAttributedString(string: title, attributes: textView.typingAttributes)

            menu.addItem(title: title, value: value)
        }

        return menu.selectItem(at: location, in: textView)
    }

}
