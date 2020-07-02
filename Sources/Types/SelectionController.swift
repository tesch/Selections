//
// SelectionController.swift
//
// Created by Marcel Tesch on 2020-07-03.
// Think different.
//

import Foundation

class SelectionController {

    private let queue = DispatchQueue(label: "de.marceltesch.selections.update", qos: .userInteractive)

    var content: Array<URL>?

    var matches: Array<URL>?

    private weak var viewController: ViewController!

    init(_ viewController: ViewController, block: (() -> ())? = nil) {
        self.viewController = viewController

        update(block)
    }

}

extension SelectionController {

    func updateContent(_ block: (() -> ())? = nil) {
        queue.async {
            let result = self.viewController.pathField.url?.contentsOfDirectory(includeHiddenFiles: Preferences.includeHiddenFiles)

            DispatchQueue.main.async {
                self.content = result

                block?()
            }
        }
    }

    func updateMatches(_ block: (() -> ())? = nil) {
        queue.async {
            let pattern = self.viewController.patternField.stringValue

            let result = self.content?.filter { url in url.lastPathComponent.range(of: pattern, options: .regularExpression) != nil }
                                      .sorted { lhs, rhs in lhs.lastPathComponent < rhs.lastPathComponent }

            DispatchQueue.main.async {
                self.matches = result

                block?()
            }
        }
    }

    func update(_ block: (() -> ())? = nil) {
        updateContent {
            self.updateMatches(block)
        }
    }

}
