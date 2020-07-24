//
// SelectionController.swift
//
// Created by Marcel Tesch on 2020-07-03.
// Think different.
//

import Foundation

class SelectionController {

    private let queue = DispatchQueue(label: "de.marceltesch.selections.update", qos: .userInteractive, attributes: .concurrent)

    private var contentTime = DispatchTime.now()
    var content: Array<URL>?

    private var matchesTime = DispatchTime.now()
    var matches: Array<URL>?

    private weak var viewController: ViewController!

    init(_ viewController: ViewController, block: (() -> ())? = nil) {
        self.viewController = viewController

        update(block)
    }

}

extension SelectionController {

    func updateContent(_ block: (() -> ())? = nil) {
        let contentTime = DispatchTime.now()

        let url = self.viewController.pathField.url

        queue.async {
            let result = url?.contentsOfDirectory(includeHiddenFiles: Preferences.includeHiddenFiles)

            DispatchQueue.main.async {
                if self.contentTime < contentTime {
                    self.contentTime = contentTime
                    self.content = result

                    block?()
                }
            }
        }
    }

    func updateMatches(_ block: (() -> ())? = nil) {
        let matchesTime = DispatchTime.now()

        let content = self.content

        let pattern = self.viewController.patternField.stringValue

        queue.async {
            let result = content?.filter { url in url.lastPathComponent.range(of: pattern, options: .regularExpression) != nil }
                                 .sorted { lhs, rhs in lhs.lastPathComponent < rhs.lastPathComponent }

            DispatchQueue.main.async {
                if self.matchesTime < matchesTime {
                    self.matchesTime = matchesTime
                    self.matches = result

                    block?()
                }
            }
        }
    }

    func update(_ block: (() -> ())? = nil) {
        updateContent {
            self.updateMatches(block)
        }
    }

}
