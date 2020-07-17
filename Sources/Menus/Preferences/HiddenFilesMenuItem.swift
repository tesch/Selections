//
// HiddenFilesMenuItem.swift
//
// Created by Marcel Tesch on 2020-06-12.
// Think different.
//

import Cocoa

class HiddenFilesMenuItem: NSMenuItem {

    private static let includeLabel = "Include Hidden Files"

    private static let excludeLabel = "Exclude Hidden Files"

    required init(coder: NSCoder) {
        super.init(coder: coder)

        if Preferences.includeHiddenFiles {
            title = Self.excludeLabel
        } else {
            title = Self.includeLabel
        }

        target = self

        action = #selector(performAction)
    }

}

extension HiddenFilesMenuItem {

    @objc private func performAction() {
        switch title {
        case Self.includeLabel:
            title = Self.excludeLabel

            Preferences.includeHiddenFiles = true
        case Self.excludeLabel:
            title = Self.includeLabel

            Preferences.includeHiddenFiles = false
        default: return
        }
    }

}
