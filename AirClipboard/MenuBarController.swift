//
//  MenuBarController.swift
//  AirClipboard
//
//  Created by Ariel Marques on 08/04/25.
//

import SwiftUI

struct MenuBarController: Scene {
    var body: some Scene {
        MenuBarExtra("", image: "MenuBarIcon") {
            // 🧭 Título
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
            .controlSize(.regular)

            // ⚙️ Preferências
            Button {
                print("🛠️ Preferências (MenuBar) clicado")
                AppDelegate.shared?.showPreferences()
            } label: {
                Label("Preferências...", systemImage: "gearshape")
            }

            Divider()
        }
        .menuBarExtraStyle(.window)
    }
}
