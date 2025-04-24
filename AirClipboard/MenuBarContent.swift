//
//  MenuBarContent.swift
//  AirClipboard
//
//  Created by Ariel Marques on 24/04/25.
//

import SwiftUI

struct MenuBarContent: View {
    @ObservedObject private var environment = AppEnvironment.shared

    var body: some View {
        VStack(spacing: 0) {
            Text("ɅirClipboard")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.horizontal, 12)
                .padding(.top, 6)

            Divider()

            Button {
                WindowManager.shared.showMainWindow()
            } label: {
                Label("menu_show", systemImage: "doc.on.doc")
            }

            Button {
                AppDelegate.shared?.showPreferences()
            } label: {
                Label("menu_preferences", systemImage: "gearshape")
            }

            Divider()
        }
        .environment(\.locale, environment.locale) // 🗣️ idioma reativo
        .id(environment.selectedLanguage) // ✅ força reconstrução do conteúdo
    }
}
