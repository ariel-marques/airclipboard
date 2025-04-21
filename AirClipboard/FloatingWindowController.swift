//
//  FloatingWindowController.swift
//  AirClipboard
//
//  Created by Ariel Marques on 06/04/25.
//

import Cocoa
import SwiftUI

class FloatingWindowController: NSWindowController {
    convenience init<Content: View>(rootView: Content) {
        let hostingController = NSHostingController(rootView: rootView)
        let hostingView = hostingController.view
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        hostingView.wantsLayer = true
        hostingView.layer?.backgroundColor = .clear

        // 🍃 Janela flutuante com estilo leve
        let window = CustomPanel(
            contentRect: NSRect(x: 300, y: 300, width: 400, height: 600),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )

        window.isOpaque = false
        window.backgroundColor = .clear
        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = true
        window.hasShadow = true
        window.isFloatingPanel = true
        window.level = .floating
        print("🎯 Nível de janela após setar .floating: \(window.level.rawValue)") // Deve ser 3 se .statusBar
        window.collectionBehavior = [.canJoinAllSpaces, .transient]
        window.isReleasedWhenClosed = false
        window.standardWindowButton(.closeButton)?.isHidden = true
        window.isMovableByWindowBackground = true

        // ☁️ Blur + arredondamento
        let visualEffectView = NSVisualEffectView()
        visualEffectView.blendingMode = .behindWindow
        visualEffectView.material = .popover
        visualEffectView.state = .active
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        visualEffectView.wantsLayer = true
        visualEffectView.layer?.cornerRadius = 16
        visualEffectView.layer?.masksToBounds = true
        visualEffectView.addSubview(hostingView)

        NSLayoutConstraint.activate([
            hostingView.topAnchor.constraint(equalTo: visualEffectView.topAnchor),
            hostingView.bottomAnchor.constraint(equalTo: visualEffectView.bottomAnchor),
            hostingView.leadingAnchor.constraint(equalTo: visualEffectView.leadingAnchor),
            hostingView.trailingAnchor.constraint(equalTo: visualEffectView.trailingAnchor)
        ])

        // Container transparente
        let containerView = NSView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.wantsLayer = true
        containerView.layer?.backgroundColor = .clear
        containerView.addSubview(visualEffectView)

        NSLayoutConstraint.activate([
            visualEffectView.topAnchor.constraint(equalTo: containerView.topAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            visualEffectView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            visualEffectView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])

        window.contentView = containerView

        // Exibe janela
        self.init(window: window)
        WindowManager.shared.registerWindow(window)
        window.becomesKeyOnlyIfNeeded = true
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)

        if let contentView = window.contentView {
            window.makeFirstResponder(contentView)
        }

        // Fecha a janela se perder o foco
        NotificationCenter.default.addObserver(
            forName: NSWindow.didResignKeyNotification,
            object: window,
            queue: .main
        ) { _ in
            window.orderOut(nil)
        }
    }
}
