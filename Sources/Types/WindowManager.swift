//
// WindowManager.swift
//
// Created by Marcel Tesch on 2020-06-05.
// Think different.
//

import Cocoa

class WindowManager {

    let storyboard: NSStoryboard = .init(name: "Main", bundle: nil)

    var controllers: Array<(controller: NSWindowController, type: WindowType)> = []

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

extension WindowManager {

    private func contains(_ controller: NSWindowController) -> Bool {
        return controllers.contains { value, _ in value == controller }
    }

    private func index(of controller: NSWindowController) -> Int? {
        return controllers.firstIndex { value, _ in value == controller }
    }

}

extension WindowManager {

    func registerController(_ controller: NSWindowController, ofType type: WindowType) {
        if !contains(controller) {
            NotificationCenter.default.addObserver(self, selector: #selector(closeWindow), name: NSWindow.willCloseNotification, object: controller.window)

            controllers.append((controller, type))
        }
    }

    func unregisterController(_ controller: NSWindowController) {
        if let index = index(of: controller) {
            NotificationCenter.default.removeObserver(self, name: NSWindow.willCloseNotification, object: controller.window)

            controllers.remove(at: index)
        }
    }

}

extension WindowManager {

    private func instantiateController(ofType type: WindowType) -> NSWindowController {
        guard let controller = storyboard.instantiateController(withIdentifier: type.rawValue) as? NSWindowController else { fatalError() }

        return controller
    }

    func createController(ofType type: WindowType) -> NSWindowController {
        switch type {
        case .regular:
            let controller = instantiateController(ofType: .regular)

            if let frame = NSApp.mainWindow?.frame {
                let point = NSPoint(x: frame.minX, y: frame.minY - 15)

                controller.window?.cascadeTopLeft(from: point)
            }

            return controller
        case .about:
            let result = controllers.first { _, value in value == .about }

            return result?.controller ?? instantiateController(ofType: .about)
        }
    }

}

extension WindowManager {

    func createWindow(ofType type: WindowType) {
        let controller = createController(ofType: type)

        registerController(controller, ofType: type)

        controller.showWindow(nil)
    }

    @objc func closeWindow(_ notification: NSNotification? = nil) {
        guard let controller = (notification?.object as? NSWindow)?.windowController ?? NSApp.mainWindow?.windowController else { return }

        unregisterController(controller)

        controller.close()
    }

    func closeAllWindows() {
        for (controller, _) in controllers {
            unregisterController(controller)

            controller.close()
        }
    }

}
