//
// String.swift
//
// Created by Marcel Tesch on 2020-06-05.
// Think different.
//

import Foundation

extension String {

    var expandingTilde: Self {
        if hasPrefix("~") {
            let range = startIndex ..< index(after: startIndex)

            return replacingCharacters(in: range, with: URL.homeDirectory.path)
        }

        return self
    }

    var abbreviatingTilde: Self {
        let prefix = URL.homeDirectory.path

        if hasPrefix(prefix) {
            let range = prefix.startIndex ..< prefix.endIndex

            return replacingCharacters(in: range, with: "~")
        }

        return self
    }

}

extension String {

    func deletingPrefix(_ prefix: Self) -> Self? {
        guard hasPrefix(prefix) else { return nil }

        return Self(dropFirst(prefix.count))
    }

}
