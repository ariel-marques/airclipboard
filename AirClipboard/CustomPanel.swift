//
//  CustomPanel.swift
//  AirClipboard
//
//  Created by Ariel Marques on 10/04/25.
//

import AppKit

class CustomPanel: NSPanel {
    // Permite que o painel se torne a key window, evitando o som de erro
    override var canBecomeKey: Bool { true }

    // Permite que o painel se torne a main window
    override var canBecomeMain: Bool { true }

    // Evita o som de erro ao pressionar teclas como ⌘V
    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        return true
    }
}
