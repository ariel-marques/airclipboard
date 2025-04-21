//  AirClipboardApp.swift
//  AirClipboard
//
//  Created by Ariel Marques on 18/04/25.
//

import SwiftUI

@main
struct AirClipboardApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        MenuBarExtra("", image: "MenuBarIcon") {
            Button("Mostrar ɅirClipboard") {
                WindowManager.shared.showMainWindow()
            }

            Divider()

            Button("Preferências...") {
                print("🛠️ Preferências (MenuBarExtra) clicado")
                AppDelegate.shared?.showPreferences()
            }
        }
        .menuBarExtraStyle(.window)
    }
}
