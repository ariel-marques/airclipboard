//
//  PreferencesWindowController.swift
//  AirClipboard
//
//  Created by Ariel Marques on 12/04/25.
//

import Cocoa
import SwiftUI

class PreferencesWindowController: NSWindowController {
    init() {
        let view = PreferencesView() // sua view SwiftUI
        let hosting = NSHostingController(rootView: view)

        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 400),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        window.center()
        window.title = "Preferências"
        window.contentView = hosting.view
        window.isReleasedWhenClosed = false

        super.init(window: window)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
