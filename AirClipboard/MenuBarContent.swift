//
//  MenuBarContent.swift
//  AirClipboard
//
//  Created by Ariel Marques on 24/04/25.
//

import SwiftUI

struct MenuBarContent: View {
    @ObservedObject private var environment = AppEnvironment.shared
    @State private var hoveredButton: Int? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("ɅirClipboard")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.horizontal, 12)
                .padding(.top, 6)

            Divider()

            menuButton(id: 0, label: "menu_show", image: {
                Image(systemName: "v.square")
                    .rotationEffect(.degrees(180))
                    .symbolRenderingMode(.monochrome)
                    .font(.system(size: 14, weight: .medium))
            }) {
                WindowManager.shared.showMainWindow()
            }

            menuButton(id: 1, label: "menu_preferences", image: {
                Image(systemName: "gearshape")
            }) {
                AppDelegate.shared?.showPreferences()
            }

            Divider().padding(.vertical, 2)

            menuButton(id: 2, label: "menu_quit", image: {
                Image(systemName: "power")
            }) {
                NSApp.terminate(nil)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .environment(\.locale, environment.locale)
        .id(environment.selectedLanguage)
    }

    // MARK: - Botão com efeito hover e imagem customizada
    @ViewBuilder
    private func menuButton(id: Int, label: String, image: () -> some View, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                image()
                Text(LocalizedStringKey(label))
                Spacer()
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 6)
            .background(
                hoveredButton == id
                    ? Color.gray.opacity(0.3)
                    : Color.clear
            )
            .cornerRadius(4)
        }
        .buttonStyle(.plain)
        .focusable(false)
        .onHover { hovering in
            hoveredButton = hovering ? id : nil
        }
    }
}
