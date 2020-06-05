//
// WindowManager.swift
//
// Created by Marcel Tesch on 2020-06-05.
// Think different.
//

import Cocoa

class WindowManager {

    let storyboard: NSStoryboard = .init(name: "Main", bundle: nil)

    var controllers: Array<NSWindowController> = []

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

extension WindowManager {

    func registerController(_ controller: NSWindowController) {
        NotificationCenter.default.addObserver(self, selector: #selector(closeWindow), name: NSWindow.willCloseNotification, object: controller.window)
    }

    func unregisterController(_ controller: NSWindowController) {
        NotificationCenter.default.removeObserver(self, name: NSWindow.willCloseNotification, object: controller.window)
    }

}

extension WindowManager {

    func createController() -> NSWindowController {
        guard let controller = storyboard.instantiateController(withIdentifier: "Window") as? NSWindowController else { fatalError() }

        if let frame = NSApp.mainWindow?.frame {
            let point = NSPoint(x: frame.minX, y: frame.minY - 15)

            controller.window?.cascadeTopLeft(from: point)
        }

        return controller
    }

}

extension WindowManager {

    func createWindow() {
        let controller = createController()

        registerController(controller)

        if !controllers.contains(controller) {
            controllers.append(controller)
        }

        controller.showWindow(nil)
    }

    @objc func closeWindow(_ notification: NSNotification? = nil) {
        guard let controller = (notification?.object as? NSWindow)?.windowController ?? NSApp.mainWindow?.windowController else { return }

        unregisterController(controller)

        controller.close()

        if let index = controllers.firstIndex(of: controller) {
            controllers.remove(at: index)
        }
    }

    func closeAllWindows() {
        for controller in controllers {
            unregisterController(controller)

            controller.close()
        }

        controllers = []
    }

}
