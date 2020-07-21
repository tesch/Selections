//
// TableView.swift
//
// Created by Marcel Tesch on 2020-07-21.
// Think different.
//

import Cocoa

class TableView: NSTableView {

    override func keyDown(with event: NSEvent) {
        let modifier = event.modifierFlags.intersection(.deviceIndependentFlagsMask)

        let controller = delegate as! TableViewController

        if event.keyCode == 49 {
            controller.presentQuicklookPanel(fullscreen: modifier == .option)
        } else if event.keyCode == 125, modifier == [.command, .function, .numericPad] {
            controller.openSelectedItems()
        } else {
            super.keyDown(with: event)
        }
    }

}
