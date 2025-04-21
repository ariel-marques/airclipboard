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

    var body: some Scene {
        MenuBarExtra("", image: "MenuBarIcon") {
            // 🧭 Título visual (não clicável)
            Text("ɅirClipboard")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.horizontal, 12)
                .padding(.top, 6)

            Divider()

            // 📂 Mostrar app
            Button {
                print("📂 Mostrar ɅirClipboard clicado")
                WindowManager.shared.showMainWindow()
            } label: {
                Label("Mostrar ɅirClipboard", systemImage: "doc.on.doc")
            }

            // ⚙️ Preferências
            Button {
                print("🛠️ Preferências (MenuBarExtra) clicado")
                AppDelegate.shared?.showPreferences()
            } label: {
                Label("Preferências...", systemImage: "gearshape")
            }

            Divider()
        }
        .menuBarExtraStyle(.window)
    }
}
