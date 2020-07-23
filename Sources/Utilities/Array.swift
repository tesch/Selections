//
// Array.swift
//
// Created by Marcel Tesch on 2020-07-21.
// Think different.
//

import Cocoa

extension Array where Element == URL {

    func open() {
        var result = Dictionary<URL?, Array<URL>>()

        for url in self {
            let url = url.resolvingAliasesInPath()

            let app = NSWorkspace.shared.urlForApplication(toOpen: url)

            if result.keys.contains(app) {
                result[app]?.append(url)
            } else {
                result[app] = [url]
            }
        }

        let options = NSWorkspace.OpenConfiguration()

        for (app, urls) in result {
            if let app = app {
                NSWorkspace.shared.open(urls, withApplicationAt: app, configuration: options)
            } else {
                for url in urls {
                    url.open()
                }
            }
        }
    }

}
