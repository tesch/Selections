//
// URL.swift
//
// Created by Marcel Tesch on 2020-06-05.
// Think different.
//

import Foundation

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

    func resolvingAliasesInPath() -> Self {
        var result: Self? = nil

        for pathComponent in pathComponents {
            result = try? Self(resolvingAliasFileAt: Self(fileURLWithPath: pathComponent, relativeTo: result))
        }

        return result ?? self
    }

    var resolvesToDirectoryPath: Bool { resolvingAliasesInPath().hasDirectoryPath }

}

extension URL {

    var isHidden: Bool { (try? resourceValues(forKeys: [.isHiddenKey]))?.isHidden == true }

    var isVisible: Bool { !isHidden }

}

extension URL {

    func contentsOfDirectory(includeHiddenFiles: Bool = true) -> Array<Self>? {
        guard let contents = try? FileManager.default.contentsOfDirectory(at: resolvingAliasesInPath(), includingPropertiesForKeys: [], options: []) else { return nil }

        return includeHiddenFiles ? contents : contents.filter(\.isVisible)
    }

    var directoriesInDirectory: Array<Self>? { standardized.contentsOfDirectory()?.filter(\.resolvesToDirectoryPath) }

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
