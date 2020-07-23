//
// TableView.swift
//
// Created by Marcel Tesch on 2020-07-21.
// Think different.
//

import Cocoa

class TableView: NSTableView {

    var controller: TableViewController { delegate as! TableViewController }

    override func keyDown(with event: NSEvent) {
        let modifier = event.modifierFlags.intersection(.deviceIndependentFlagsMask)

        if event.keyCode == 49 {
            controller.presentQuicklookPanel(fullscreen: modifier == .option)
        } else if event.keyCode == 125, modifier == [.command, .function, .numericPad] {
            controller.openSelectedItems()
        } else {
            super.keyDown(with: event)
        }
    }

    override func willOpenMenu(_ menu: NSMenu, with event: NSEvent) {
        if selectedRowIndexes.contains(clickedRow), selectedRowIndexes.count > 1 {
            menu.items[1].title = "Copy Paths"
        } else {
            menu.items[1].title = "Copy Path"
        }
    }

}

extension TableView {

    @IBAction func openMenuItem(_ sender: Any) {
        controller.openSelectedItems()
    }

    @IBAction func copyMenuItem(_ sender: Any) {
        controller.copySelectedItemPaths()
    }

}
