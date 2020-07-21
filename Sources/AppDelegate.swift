//
// AppDelegate.swift
//
// Created by Marcel Tesch on 2020-06-05.
// Think different.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let manager = WindowManager()

}

extension AppDelegate {

    func applicationDidFinishLaunching(_ notification: Notification) {
        UserDefaults.standard.set(true, forKey: "NSDisabledDictationMenuItem")
        UserDefaults.standard.set(true, forKey: "NSDisabledCharacterPaletteMenuItem")

        UserDefaults.standard.set(false, forKey: "NSFullScreenMenuItemEverywhere")

        createWindow(self)
    }

    func applicationWillTerminate(_ notification: Notification) {

    }

}

extension AppDelegate {

    @IBAction private func showAboutWindow(_ sender: Any) {
        manager.createWindow(ofType: .about)
    }

    @IBAction private func showInfo(_ sender: Any) {
        URL(string: "https://github.com/tesch/selections")?.open()
    }

    @IBAction private func createWindow(_ sender: Any) {
        manager.createWindow(ofType: .regular)
    }

    @IBAction private func closeWindow(_ sender: Any) {
        manager.closeWindow()
    }

    @IBAction private func closeAllWindows(_ sender: Any) {
        manager.closeAllWindows()
    }

}
