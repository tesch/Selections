//
// Sequence.swift
//
// Created by Marcel Tesch on 2020-06-05.
// Think different.
//

import Foundation

extension Sequence where Element == URL {

    func select(with pattern: String) -> Array<URL> {
        return filter { url in url.lastPathComponent.range(of: pattern, options: .regularExpression) != nil }
    }

}
