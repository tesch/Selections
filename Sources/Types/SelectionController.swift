//
// SelectionController.swift
//
// Created by Marcel Tesch on 2020-07-03.
// Think different.
//

import Foundation

class SelectionController {

    enum Selection {

        case invalidPath

        case emptyDirectory

        case emptySelection

        case matches(Array<URL>)

    }

    var selection: Selection = .invalidPath

    weak var viewController: ViewController!

    init(_ viewController: ViewController) {
        self.viewController = viewController

        createSelection()
    }

}

extension SelectionController {

    var matches: Array<URL>? {
        switch selection {
        case .matches(let matches):
            return matches
        default:
            return nil
        }
    }

    var directoryCount: Int { matches?.filter(\.hasDirectoryPath).count ?? 0 }

    var fileCount: Int { (matches?.count ?? 0) - directoryCount }

}

extension SelectionController {

    func createSelection() {
        guard let contents = viewController.pathField.url?.contentsOfDirectory(includeHiddenFiles: Preferences.includeHiddenFiles) else {
            selection = .invalidPath

            return
        }

        guard !contents.isEmpty else {
            selection = .emptyDirectory

            return
        }

        let pattern = viewController.patternField.stringValue

        let matches = contents.filter { url in url.lastPathComponent.range(of: pattern, options: .regularExpression) != nil }
                              .sorted { lhs, rhs in lhs.lastPathComponent < rhs.lastPathComponent }

        guard !matches.isEmpty else {
            selection = .emptySelection

            return
        }

        selection = .matches(matches)
    }

}
