//
// TableViewController.swift
//
// Created by Marcel Tesch on 2020-07-03.
// Think different.
//

import Cocoa

import Quartz

class TableViewController: NSObject {

    private weak var viewController: ViewController!

    private var tableView: TableView { viewController.tableView }

    init(_ viewController: ViewController) {
        self.viewController = viewController
    }

}

extension TableViewController {

    private func url(at index: Int) -> URL {
        return viewController.selectionController.matches![index]
    }

    private var selectedURLs: Array<URL> { tableView.selectedRowIndexes.map { index in url(at: index) } }

    private var clickedURL: URL { url(at: tableView.clickedRow) }

}

extension TableViewController: NSTableViewDelegate, NSTableViewDataSource {

    func numberOfRows(in tableView: NSTableView) -> Int {
        return viewController.selectionController.matches?.count ?? 0
    }

    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row index: Int) -> Any? {
        return url(at: index).lastPathComponent
    }

}

extension TableViewController {

    private var clickedRowInSelection: Bool { tableView.selectedRowIndexes.contains(tableView.clickedRow) }

    @objc func openSelectedItems() {
        selectedURLs.open()
    }

    func openClickedItems() {
        if clickedRowInSelection {
            openSelectedItems()
        } else {
            clickedURL.open()
        }
    }

    func copySelectedItemPaths() {
        NSPasteboard.general.clearContents()

        let result: String

        if clickedRowInSelection {
            result = selectedURLs.map { url in url.path }
                                 .joined(separator: "\n")
        } else {
            result = clickedURL.path
        }

        NSPasteboard.general.setString(result, forType: .string)
    }

}

extension TableViewController {

    private var panel: QLPreviewPanel? { .shared() }

    func presentQuicklookPanel(fullscreen: Bool = false) {
        if panel?.isVisible == true {
            panel?.orderOut(self)
        } else {
            if fullscreen {
                panel?.enterFullScreenMode(nil, withOptions: [:])
            } else {
                panel?.makeKeyAndOrderFront(self)
            }
        }
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        if panel?.isVisible == true {
            panel?.reloadData()
        }
    }

}

extension TableViewController: QLPreviewPanelDelegate, QLPreviewPanelDataSource {

    func numberOfPreviewItems(in panel: QLPreviewPanel!) -> Int {
        return tableView.selectedRow == -1 ? 1 : tableView.selectedRowIndexes.count
    }

    func previewPanel(_ panel: QLPreviewPanel!, previewItemAt index: Int) -> QLPreviewItem! {
        if tableView.selectedRow == -1 {
            return viewController.pathField.url! as NSURL
        } else {
            let result = tableView.selectedRowIndexes

            let index = result[result.index(result.startIndex, offsetBy: index)]

            return viewController.selectionController.matches![index] as NSURL
        }
    }

}

extension TableViewController {

    func previewPanel(_ panel: QLPreviewPanel!, handle event: NSEvent!) -> Bool {
        if event.type == .keyDown, event.keyCode == 125 || event.keyCode == 126 {
            tableView.keyDown(with: event)

            return false
        }

        return true
    }

}

extension TableViewController {

    func previewPanel(_ panel: QLPreviewPanel!, sourceFrameOnScreenFor item: QLPreviewItem!) -> NSRect {
        let frame: NSRect

        if let index = tableView.selectedRowIndexes.min() {
            let rect = tableView.rect(ofRow: index)

            frame = NSRect(x: rect.minX + rect.width / 2, y: rect.minY + rect.height / 2, width: 0, height: 0)
        } else {
            let rect = tableView.enclosingScrollView!.frame

            frame = NSRect(x: rect.width / 2, y: rect.height / 2, width: 0, height: 0)
        }

        let rectInWindow = tableView.convert(frame, to: nil)

        let rectInScreen = tableView.window!.convertToScreen(rectInWindow)

        return rectInScreen
    }

}
