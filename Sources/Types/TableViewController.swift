//
// TableViewController.swift
//
// Created by Marcel Tesch on 2020-07-03.
// Think different.
//

import Cocoa

class TableViewController: NSObject, NSTableViewDelegate, NSTableViewDataSource {

    private weak var viewController: ViewController!

    init(_ viewController: ViewController) {
        self.viewController = viewController
    }

}

extension TableViewController {

    func numberOfRows(in tableView: NSTableView) -> Int {
        return viewController.selectionController.matches?.count ?? 0
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row index: Int) -> NSView? {
        guard let matches = viewController.selectionController.matches, matches.indices.contains(index) else { return nil }

        guard let view = tableView.makeView(withIdentifier: .init("TableCellView"), owner: self) as? NSTableCellView else { return nil }

        view.textField?.stringValue = matches[index].lastPathComponent

        return view
    }

}
