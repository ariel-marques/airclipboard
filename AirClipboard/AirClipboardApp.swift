//
//  AirClipboardApp.swift
//  AirClipboard
//
//  Created by Ariel Marques on 18/04/25.
//

import SwiftUI

@main
struct AirClipboardApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @ObservedObject private var environment = AppEnvironment.shared

    var body: some Scene {
        MenuBarExtra("", image: "MenuBarIcon") {
            // 🔄 Avisa internamente que deve reconstruir ao mudar de idioma
            MenuBarContent()
                .id(environment.selectedLanguage) // 💡 ID aqui, onde é View
        }
        .menuBarExtraStyle(.window)
        .environment(\.locale, environment.locale) // 🌍 aplica idioma
    }
}
