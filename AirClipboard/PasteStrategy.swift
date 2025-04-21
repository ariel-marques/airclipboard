//
//  PasteStrategy.swift
//  AirClipboard
//
//  Created by Ariel Marques on 12/04/25.
//

import AppKit

struct PasteStrategy {
    // Apps que ainda precisam de AppleScript por restrições de segurança ou comportamento
    static let fallbackApps: Set<String> = [
        "com.apple.Terminal",
        "com.apple.TextEdit",
        "com.apple.dt.Xcode",
        "com.apple.Numbers"
    ]

    static func performPaste() {
        guard let frontApp = NSWorkspace.shared.frontmostApplication else {
            print("🚫 Não foi possível identificar o app em foco.")
            return
        }

        let bundleID = frontApp.bundleIdentifier ?? "desconhecido"
        print("📦 App em foco: \(bundleID)")

        if fallbackApps.contains(bundleID) {
            print("↩️ Usando fallback (AppleScript)")
            performPasteWithAppleScript(for: frontApp)
        } else {
            print("🚀 Usando paste via CGEvent")
            performPasteWithCGEvent(for: frontApp)
        }
    }

    private static func performPasteWithCGEvent(for app: NSRunningApplication) {
        let pid = app.processIdentifier
        let source = CGEventSource(stateID: .hidSystemState)

        let cmdDown = CGEvent(keyboardEventSource: source, virtualKey: 0x37, keyDown: true)
        cmdDown?.flags = .maskCommand

        let vDown = CGEvent(keyboardEventSource: source, virtualKey: 0x09, keyDown: true)
        vDown?.flags = .maskCommand

        let vUp = CGEvent(keyboardEventSource: source, virtualKey: 0x09, keyDown: false)
        vUp?.flags = .maskCommand

        let cmdUp = CGEvent(keyboardEventSource: source, virtualKey: 0x37, keyDown: false)

        cmdDown?.postToPid(pid)
        vDown?.postToPid(pid)
        vUp?.postToPid(pid)
        cmdUp?.postToPid(pid)

        print("✅ Paste via CGEvent para PID: \(pid)")
    }

    private static func performPasteWithAppleScript(for app: NSRunningApplication) {
        let appName = app.localizedName ?? "AppDesconhecido"

        let appleScript = """
        tell application "System Events"
            tell application process "\(appName)"
                keystroke "v" using {command down}
            end tell
        end tell
        """

        if let script = NSAppleScript(source: appleScript) {
            var errorDict: NSDictionary?
            script.executeAndReturnError(&errorDict)

            if let error = errorDict {
                print("❌ AppleScript falhou: \(error)")
            } else {
                print("✅ Paste via AppleScript executado no app: \(appName)")
            }
        }
    }
}
