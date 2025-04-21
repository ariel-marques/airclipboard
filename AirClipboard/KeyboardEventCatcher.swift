//
//  KeyboardEventCatcher.swift
//  AirClipboard
//
//  Created by Ariel Marques on 16/04/25.
//

import SwiftUI

struct KeyboardEventCatcher: NSViewRepresentable {
    @Binding var isRecording: Bool
    @Binding var shortcut: String
    var onCommit: () -> Void

    func makeNSView(context: Context) -> NSView {
        let view = NSEventCatcher()
        view.onKeyDown = { event in
            guard isRecording else { return }

            if event.keyCode == 53 { // ESC
                isRecording = false
                print("❌ Gravação cancelada")
                return
            }

            var parts: [String] = []
            if event.modifierFlags.contains(.control) { parts.append("⌃") }
            if event.modifierFlags.contains(.option)  { parts.append("⌥") }
            if event.modifierFlags.contains(.shift)   { parts.append("⇧") }
            if event.modifierFlags.contains(.command) { parts.append("⌘") }

            if let chars = event.charactersIgnoringModifiers {
                parts.append(chars.uppercased())
            }

            shortcut = parts.joined()
            isRecording = false
            onCommit()
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {}

    class NSEventCatcher: NSView {
        var onKeyDown: ((NSEvent) -> Void)?

        override var acceptsFirstResponder: Bool { true }

        override func keyDown(with event: NSEvent) {
            onKeyDown?(event)
        }

        override func viewDidMoveToWindow() {
            window?.makeFirstResponder(self)
        }
    }
}
