//
//  AppDelegate.swift
//  AirClipboard
//
//  Created by Ariel Marques on 06/04/25.
//

import Cocoa
import SwiftUI
import ServiceManagement

class AppDelegate: NSObject, NSApplicationDelegate {
    static weak var shared: AppDelegate?

    var floatingWindowController: FloatingWindowController?
    var preferencesWindowController: PreferencesWindowController?

    @AppStorage("launchAtLogin") private var launchAtLogin: Bool = false

    func applicationDidFinishLaunching(_ notification: Notification) {
        print("🚀 AirClipboardApp iniciado com AppDelegate ✅")
        AppDelegate.shared = self
        applyLaunchAtLogin()
        configureMainWindow()
        registerGlobalHotkey()
    }

    private func configureMainWindow() {
        let rootView = ContentView()
            .preferredColorScheme(AppTheme.current.colorScheme)

        floatingWindowController = FloatingWindowController(rootView: rootView)
        floatingWindowController?.showWindow(nil)
    }

    private func registerGlobalHotkey() {
        HotkeyManager.shared.register()
    }

    func showPreferences() {
        print("🧩 showPreferences() foi chamado")

        if preferencesWindowController == nil {
            preferencesWindowController = PreferencesWindowController()
        }

        preferencesWindowController?.showWindow(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    private func applyLaunchAtLogin() {
        if #available(macOS 13.0, *) {
            do {
                let status = SMAppService.mainApp.status
                if launchAtLogin && status != .enabled {
                    try SMAppService.mainApp.register()
                } else if !launchAtLogin && status == .enabled {
                    try SMAppService.mainApp.unregister()
                }
            } catch {
                print("🚫 Erro ao aplicar login automático: \(error)")
            }
        }
    }
}
