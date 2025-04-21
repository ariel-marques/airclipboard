// ⚠️ Currently unused
// This view allows programmatic focus on TextField using @FocusState
// May be used in future versions to enable ⌘A, arrow key navigation, etc.
//
//  FocusableTextField.swift
//  AirClipboard
//
//  Created by Ariel Marques on 14/04/25.
//

import SwiftUI
import AppKit

struct FocusableTextField: NSViewRepresentable {
    @Binding var text: String
    @Binding var isFirstResponder: Bool

    class Coordinator: NSObject, NSTextFieldDelegate {
        var parent: FocusableTextField

        init(_ parent: FocusableTextField) {
            self.parent = parent
        }

        func controlTextDidChange(_ obj: Notification) {
            guard let textField = obj.object as? NSTextField else { return }
            parent.text = textField.stringValue
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeNSView(context: Context) -> NSTextField {
        let textField = NSTextField(string: text)
        textField.delegate = context.coordinator
        textField.focusRingType = .none
        textField.isBezeled = false
        textField.isBordered = false
        textField.font = .systemFont(ofSize: 14)
        textField.drawsBackground = false
        return textField
    }

    func updateNSView(_ nsView: NSTextField, context: Context) {
        nsView.stringValue = text

        if isFirstResponder, let window = nsView.window {
            DispatchQueue.main.async {
                window.makeFirstResponder(nsView)
            }
        }
    }
}
