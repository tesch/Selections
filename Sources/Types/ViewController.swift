//
// ViewController.swift
//
// Created by Marcel Tesch on 2020-06-05.
// Think different.
//

import Cocoa

class ViewController: NSViewController {

    var selectionController: SelectionController!

    @IBOutlet weak var pathField: PathField!
    var pathFieldDelegate: PathFieldDelegate!

    @IBOutlet weak var patternField: TextField!
    var patternFieldDelegate: TextFieldDelegate!

    @IBOutlet weak var tableView: NSTableView!
    var tableViewController: TableViewController!

    @IBOutlet weak var infoLabel: NSTextField!

    let menuController = MenuController<String>()

    override func viewDidLoad() {
        super.viewDidLoad()

        selectionController = .init(self)

        let block = { [unowned self] in
            self.selectionController.createSelection()

            self.tableView.reloadData()

            self.infoLabel.stringValue = "\(self.selectionController.fileCount) files, \(self.selectionController.directoryCount) folders"
        }

        pathFieldDelegate = .init(self, block)
        pathField.delegate = pathFieldDelegate

        patternFieldDelegate = .init(self, block)
        patternField.delegate = patternFieldDelegate

        tableViewController = .init(self)
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
        switch selectionController.selection {
        case .invalidPath:
            presentAlert(title: "Invalid Path", text: "The given path does not correspond to an existing directory.", style: .critical)
        case .emptyDirectory:
            presentAlert(title: "Empty Directory", text: "The given directory does not contain any items.")
        case .emptySelection:
            presentAlert(title: "Empty Selection", text: "The given pattern does not match any items.")
        case .matches(let matches):
            NSWorkspace.shared.activateFileViewerSelecting(matches)
        }
    }

}
