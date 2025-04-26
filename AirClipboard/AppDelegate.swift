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
        AppEnvironment.shared.startTrialIfNeeded()
        applyLaunchAtLogin()
        configureMainWindow()
        registerGlobalHotkey()
    }

    private func configureMainWindow() {
        let rootView = ContentView()
            .environmentObject(AppEnvironment.shared)
            .environment(\.locale, AppEnvironment.shared.locale)

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

    func showPreferences(selecting section: PreferencesSection) {
        if preferencesWindowController == nil {
            preferencesWindowController = PreferencesWindowController()
        }

        preferencesWindowController?.showWindow(nil)
        NSApp.activate(ignoringOtherApps: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            NotificationCenter.default.post(name: .selectPreferencesSection, object: section)
        }
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

   extension Notification.Name {
       static let selectPreferencesSection = Notification.Name("selectPreferencesSection")
   }
