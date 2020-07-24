//
// URL.swift
//
// Created by Marcel Tesch on 2020-06-05.
// Think different.
//

import Cocoa

extension URL {

    static var homeDirectory: Self { FileManager.default.homeDirectoryForCurrentUser }

}

extension URL {

    init?(fileURLWithAbsolutePath path: String) {
        guard path.hasPrefix("/") else { return nil }

        self.init(fileURLWithPath: path)
    }

}

extension URL {

    func open() {
        NSWorkspace.shared.open(self)
    }

}

extension URL {

    var resolvingAlias: Self? { try? Self(resolvingAliasFileAt: self) }

    var resolvingAliases: Self? {
        var result: Self? = nil

        for pathComponent in standardized.pathComponents {
            guard let resolved = Self(fileURLWithPath: pathComponent, relativeTo: result).resolvingAlias else { return nil }

            result = resolved
        }

        return result
    }

    var resolvesToDirectoryPath: Bool { resolvingAliases?.hasDirectoryPath ?? false }

}

extension URL {

    var isHidden: Bool { (try? resourceValues(forKeys: [.isHiddenKey]))?.isHidden ?? false }

    var isVisible: Bool { !isHidden }

}

extension URL {

    func contentsOfDirectory(includeHiddenFiles: Bool = true) -> Array<Self>? {
        guard let url = resolvingAliases else { return nil }

        guard let contents = try? FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: [], options: []) else { return nil }

        return includeHiddenFiles ? contents : contents.filter(\.isVisible)
    }

    var directoriesInDirectory: Array<Self>? { contentsOfDirectory()?.filter(\.resolvesToDirectoryPath) }

}

extension URL {

    func splitLastPathComponent() -> (Self, String) {
        return (Self(fileURLWithPath: "/" + pathComponents.dropFirst().dropLast().joined(separator: "/")), lastPathComponent)
    }

    func predictDirectoryPaths(hasTrailingSlash: Bool, includeHiddenFiles: Bool = true) -> (prefix: String, prediction: String, completions: Array<String>) {
        let (url, prefix) = hasTrailingSlash ? (self, "") : splitLastPathComponent()

        let directories = url.directoriesInDirectory ?? []

        let components = directories.map(\.lastPathComponent) + [".", ".."]

        let completions = components.compactMap { value in value.deletingPrefix(prefix) }.filter { value in
            if hasTrailingSlash, !includeHiddenFiles {
                return !value.hasPrefix(".")
            }

            return true
        }

        let prediction = completions.longestCommonPrefix()

        return (prefix, prediction, completions)
    }

}
