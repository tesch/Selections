//
// ViewController.swift
//
// Created by Marcel Tesch on 2020-06-05.
// Think different.
//

import Cocoa

import Quartz

class ViewController: NSViewController {

    var selectionController: SelectionController!

    @IBOutlet weak var pathField: PathField!
    private var pathFieldDelegate: PathFieldDelegate!

    @IBOutlet weak var patternField: TextField!
    private var patternFieldDelegate: TextFieldDelegate!

    @IBOutlet weak var tableView: NSTableView!
    private var tableViewController: TableViewController!

    @IBOutlet weak var infoLabel: NSTextField!

    let menuController = MenuController<String>()

}

extension ViewController {

    private func updateTable() {
        tableView.reloadData()

        infoLabel.stringValue = "\(selectionController.matches?.count ?? 0) of \(selectionController.content?.count ?? 0)"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        selectionController = .init(self) { [unowned self] in self.updateTable() }

        pathFieldDelegate = .init(self) { [unowned self] in self.selectionController.update { self.updateTable() } }
        pathField.delegate = pathFieldDelegate

        patternFieldDelegate = .init(self) { [unowned self] in self.selectionController.updateMatches { self.updateTable() } }
        patternField.delegate = patternFieldDelegate

        tableViewController = .init(self)

        tableView.target = tableViewController
        tableView.doubleAction = #selector(tableViewController.handleDoubleClick)

        tableView.delegate = tableViewController
        tableView.dataSource = tableViewController
    }

}

extension ViewController {

    @IBAction private func selectDirectory(_ sender: Any) {
        let dialog = NSOpenPanel()

        dialog.canChooseFiles = false
        dialog.canChooseDirectories = true
        dialog.canCreateDirectories = true
        dialog.resolvesAliases = false
        dialog.allowsMultipleSelection = false

        dialog.beginSheetModal(for: view.window!) { result in
            if result == .OK {
                self.pathField.url = dialog.url
            }
        }
    }

}

extension ViewController {

    private func presentAlert(title: String, text: String, style: NSAlert.Style = .informational) {
        let alert = NSAlert()

        alert.messageText = title
        alert.informativeText = text
        alert.alertStyle = style

        alert.beginSheetModal(for: view.window!)
    }

    @IBAction private func createSelection(_ sender: Any) {
        guard let content = selectionController.content, let matches = selectionController.matches else {
            presentAlert(title: "Invalid Path", text: "The given path does not correspond to an existing directory.", style: .critical)

            return
        }

        guard !content.isEmpty else {
            presentAlert(title: "Empty Directory", text: "The given directory does not contain any items.")

            return
        }

        guard !matches.isEmpty else {
            presentAlert(title: "Empty Selection", text: "The given pattern does not match any items.")

            return
        }

        NSWorkspace.shared.activateFileViewerSelecting(matches)
    }

}

extension ViewController {

    override func acceptsPreviewPanelControl(_ panel: QLPreviewPanel!) -> Bool {
        return true
    }

    override func beginPreviewPanelControl(_ panel: QLPreviewPanel!) {
        panel.delegate = tableViewController
        panel.dataSource = tableViewController
    }

    override func endPreviewPanelControl(_ panel: QLPreviewPanel!) {
        panel.delegate = nil
        panel.dataSource = nil
    }

}
