//
// OutlineViewController.swift
//
// Created by Marcel Tesch on 2020-07-03.
// Think different.
//

import Cocoa

class OutlineViewController: NSObject, NSOutlineViewDelegate, NSOutlineViewDataSource {

    weak var viewController: ViewController!

    init(_ viewController: ViewController) {
        self.viewController = viewController
    }

}

extension OutlineViewController {

    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        guard let matches = viewController.selectionController.matches, matches.indices.contains(index) else { return 0 }

        return matches[index]
    }

    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        return viewController.selectionController.matches?.count ?? 0
    }

    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return false
    }

    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        guard let item = item as? URL else { return nil }

        guard let cell = outlineView.makeView(withIdentifier: .init("TableCellView"), owner: self) as? NSTableCellView else { return nil }

        cell.textField?.stringValue = item.lastPathComponent

        return cell
    }

}
