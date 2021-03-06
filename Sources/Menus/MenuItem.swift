//
// MenuItem.swift
//
// Created by Marcel Tesch on 2020-06-05.
// Think different.
//

import Cocoa

class MenuItem: NSMenuItem {

    private var block: (() -> ())?

    @objc private func executeBlock() {
        block?()
    }

}

extension MenuItem {

    func setAction(_ block: @escaping () -> ()) {
        self.block = block

        self.target = self

        self.action = #selector(executeBlock)
    }

}
