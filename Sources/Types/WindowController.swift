//
// WindowController.swift
//
// Created by Marcel Tesch on 2020-06-05.
// Think different.
//

import Cocoa

class WindowController: NSWindowController, NSWindowDelegate {

    override var window: NSWindow? {
        didSet {
            window?.registerForDraggedTypes([.fileURL])
        }
    }

    func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        guard window!.makeFirstResponder(window) else { fatalError() }

        return .copy
    }

    func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard let items = sender.draggingPasteboard.pasteboardItems, items.count == 1 else { return false }

        guard let path = items.first?.propertyList(forType: .fileURL) as? String else { return false }

        let url = URL(fileURLWithPath: path).standardized

        if let viewController = window?.contentViewController as? ViewController, url.resolvesToDirectoryPath {
            viewController.pathField.url = url

            return true
        }

        return false
    }

}
