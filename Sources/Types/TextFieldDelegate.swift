//
// TextFieldDelegate.swift
//
// Created by Marcel Tesch on 2020-06-02.
// Think different.
//

import Cocoa

class TextFieldDelegate: NSObject, NSTextFieldDelegate {

    weak var viewController: ViewController!

    private let block: () -> ()

    init(_ viewController: ViewController, _ block: @escaping () -> ()) {
        self.viewController = viewController

        self.block = block
    }

}

extension TextFieldDelegate {

    func controlTextDidChange(_ notification: Notification) {
        block()
    }

}
