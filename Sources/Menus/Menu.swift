//
// Menu.swift
//
// Created by Marcel Tesch on 2020-06-05.
// Think different.
//

import Cocoa

class Menu<Element>: NSMenu {

    private var result: Element?

}

extension Menu {

    func addItem(title: NSAttributedString, value: Element) {
        let item = MenuItem()

        item.attributedTitle = title

        item.setAction { self.result = value }

        addItem(item)
    }

    func selectItem(at location: NSPoint, in view: NSView) -> Element? {
        result = nil

        popUp(positioning: items.first, at: location, in: view)

        return result
    }

}
