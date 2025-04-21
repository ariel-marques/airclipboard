//
//  StatusMenuController.swift
//  AirClipboard
//
//  Created by Ariel Marques on 19/04/25.
//

// import AppKit
// import SwiftUI

// class StatusMenuController {
//     private var statusItem: NSStatusItem!

//     init() {
//         setupMenu()
//     }

//     private func setupMenu() {
//         statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

//         if let button = statusItem.button {
//             print("✅ Botão da status bar configurado!")
//             if let image = NSImage(named: "MenuBarIcon") {
//                 print("✅ Imagem MenuBarIcon carregada!")
//                 button.image = image
//                 button.image?.isTemplate = true
//             } else {
//                 print("🚫 Falha ao carregar MenuBarIcon!")
//             }
//         }

//         let menu = NSMenu()

//         // 🧭 Título estilizado (não clicável)
//         let titleItem = NSMenuItem()
//         titleItem.title = "ɅirClipboard"
//         titleItem.isEnabled = false
//         menu.addItem(titleItem)

//         menu.addItem(.separator())

//         // 📂 Mostrar app
//         let showItem = NSMenuItem(
//             title: "Mostrar ɅirClipboard",
//             action: #selector(showMainWindow),
//             keyEquivalent: ""
//         )
//         showItem.image = NSImage(systemSymbolName: "doc.on.doc", accessibilityDescription: nil)
//         showItem.target = self
//         menu.addItem(showItem)

//         // ⚙️ Preferências
//         let preferencesItem = NSMenuItem(
//             title: "Preferências...",
//             action: #selector(openPreferences),
//             keyEquivalent: ","
//         )
//         preferencesItem.image = NSImage(systemSymbolName: "gearshape", accessibilityDescription: nil)
//         preferencesItem.target = self
//         menu.addItem(preferencesItem)

//         // (Removido botão "Sair" a pedido)

//         statusItem.menu = menu
//     }

//     // MARK: - Ações

//     @objc private func showMainWindow() {
//         print("📂 Mostrar ɅirClipboard clicado")
//         WindowManager.shared.showMainWindow()
//     }

//     @objc private func openPreferences() {
//         print("🛠️ Preferências (MenuBar) clicado")
//         if let appDelegate = NSApp.delegate as? AppDelegate {
//             appDelegate.showPreferences()
//         } else {
//             print("⚠️ NSApp.delegate não é AppDelegate")
//         }
//     }
// }
