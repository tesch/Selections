//
// Preferences.swift
//
// Created by Marcel Tesch on 2020-06-12.
// Think different.
//

import Foundation

enum Preferences {

    static let hiddenFilesKey = "IncludeHiddenFilesKey"

    static let userDefaults = UserDefaults()

}

extension Preferences {

    static var includeHiddenFiles: Bool {
        get {
            if let result = userDefaults.object(forKey: hiddenFilesKey) as? Bool {
                return result
            } else {
                return false
            }
        }
        set(value) {
            userDefaults.set(value, forKey: hiddenFilesKey)
        }
    }

}
