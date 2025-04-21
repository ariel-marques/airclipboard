//
//  WindowManager.swift
//  AirClipboard
//
//  Created by Ariel Marques on 07/04/25.
//

import Foundation
import AppKit

class WindowManager: ObservableObject {
    static let shared = WindowManager()
    weak var window: NSWindow?

    func registerWindow(_ window: NSWindow) {
        self.window = window
        print("🔍 Janela registrada com nível: \(window.level.rawValue)")
    }

    func showMainWindow() {
        guard let window = window else { return }

        let windowSize = window.frame.size
        let padding: CGFloat = 10

        if let screen = NSScreen.screens.first(where: { $0.frame.contains(NSEvent.mouseLocation) }) {
            let screenFrame = screen.frame
            let mouseLocation = NSEvent.mouseLocation

            // Corrige a origem Y (coordenadas invertidas no macOS)
            let adjustedY = mouseLocation.y

            var x = mouseLocation.x + padding
            var y = adjustedY - windowSize.height - padding

            // Garante que a janela fique dentro da tela
            if x + windowSize.width > screenFrame.maxX {
                x = mouseLocation.x - windowSize.width - padding
            }
            if y < screenFrame.minY {
                y = screenFrame.minY + padding
            }

            window.setFrameOrigin(NSPoint(x: x, y: y))
        }

        window.orderFrontRegardless()
        window.makeKeyAndOrderFront(nil)
        window.makeKey()
        NSApp.activate(ignoringOtherApps: true)

        if let contentView = window.contentView {
            window.makeFirstResponder(contentView)
        }

        print("📍 Janela posicionada com base no cursor.")
    }

    func hideMainWindow() {
        guard let window = window else { return }
        window.orderOut(nil)
        print("🔴 Janela oculta")
    }

    func toggleMainWindow() {
        guard let window = window else { return }

        if window.isVisible {
            hideMainWindow()
        } else {
            showMainWindow()
        }
    }
}
