//
// Collection.swift
//
// Created by Marcel Tesch on 2020-06-05.
// Think different.
//

import Foundation

extension Collection where Element == String {

    func longestCommonPrefix() -> String {
        guard var prefix = first else { return "" }

        for value in dropFirst() {
            while !value.hasPrefix(prefix) {
                prefix.removeLast()
            }
        }

        return prefix
    }

}
