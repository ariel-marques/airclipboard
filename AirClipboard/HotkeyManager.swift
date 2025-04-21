//
//  HotkeyManager.swift
//  AirClipboard
//
//  Created by Ariel Marques on 04/04/25.
//

import Foundation
import HotKey
import AppKit

class HotkeyManager {
    static let shared = HotkeyManager()
    
    private var hotKey: HotKey?

    func register() {
        let shortcutString = UserDefaults.standard.string(forKey: "shortcutKey") ?? "⌃⌘V"
        updateShortcut(shortcutString)
    }

    func updateShortcut(_ shortcut: String) {
        // Cancela o atalho anterior, se houver
        hotKey = nil

        // Converte string para Key + Modifiers
        guard let parsed = parseShortcut(shortcut) else {
            print("⚠️ Atalho inválido: \(shortcut)")
            return
        }

        hotKey = HotKey(key: parsed.key, modifiers: parsed.modifiers)
        hotKey?.keyDownHandler = {
            print("⚡️ Atalho pressionado: \(shortcut)")
            WindowManager.shared.toggleMainWindow()
        }
    }

    // MARK: - Utilitário para converter string como "⌃⌘V" para HotKey
    private func parseShortcut(_ shortcut: String) -> (key: Key, modifiers: NSEvent.ModifierFlags)? {
        var modifiers: NSEvent.ModifierFlags = []
        var key: Key?

        if shortcut.contains("⌃") { modifiers.insert(.control) }
        if shortcut.contains("⌘") { modifiers.insert(.command) }
        if shortcut.contains("⌥") { modifiers.insert(.option) }
        if shortcut.contains("⇧") { modifiers.insert(.shift) }

        let letters = shortcut.replacingOccurrences(of: "[^A-Z0-9]", with: "", options: .regularExpression)
        if let lastChar = letters.last, let parsedKey = Key(string: String(lastChar)) {
            key = parsedKey
        }

        if let key = key {
            return (key, modifiers)
        }
        return nil
    }
}
