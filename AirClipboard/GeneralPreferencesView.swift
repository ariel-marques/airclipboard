//
//  GeneralPreferencesView.swift
//  AirClipboard
//
//  Created by Ariel Marques on 13/04/25.
//

import SwiftUI
import ServiceManagement

struct GeneralPreferencesView: View {
    @AppStorage("playClickSound") private var playClickSound = true
    @AppStorage("launchAtLogin") private var launchAtLogin = false
    @AppStorage("shortcutKey") private var recordedShortcut = "⌃⌘V"

    @State private var isRecordingShortcut = false

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Título da seção
            Text("Geral")
                .font(.title2)
                .fontWeight(.semibold)

            VStack(spacing: 16) {
                preferenceSwitchRow(title: "Play click sound", isOn: $playClickSound)

                preferenceSwitchRow(title: "Launch at login", isOn: $launchAtLogin)
                    .onChange(of: launchAtLogin) { newValue in
                        if #available(macOS 13.0, *) {
                            do {
                                if newValue {
                                    try SMAppService.mainApp.register()
                                    print("✅ App registrado para iniciar com o sistema")
                                } else {
                                    try SMAppService.mainApp.unregister()
                                    print("🛑 App removido do login automático")
                                }
                            } catch {
                                print("🚫 Erro ao configurar login automático: \(error)")
                            }
                        } else {
                            print("⚠️ Essa função requer macOS 13 ou superior")
                        }
                    }
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Atalho")
                        .foregroundColor(.primary)
                    Spacer()
                    ShortcutFieldView(
                        isRecording: $isRecordingShortcut,
                        recordedShortcut: $recordedShortcut
                    )
                }

                Text("Pressione o atalho desejado para abrir o ɅirClipboard.")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text("⚠️ Alguns atalhos simples como ⌃V podem não funcionar corretamente em certos apps. Recomendamos ⌃⌘V, ⌥⌘C ou combinações com Shift.")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    private func preferenceSwitchRow(title: String, isOn: Binding<Bool>) -> some View {
        HStack {
            Text(title)
            Spacer()
            Toggle("", isOn: isOn)
                .toggleStyle(.switch)
                .labelsHidden()
        }
    }
}
